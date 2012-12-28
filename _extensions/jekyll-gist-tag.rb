require 'open-uri'
require 'json'
require 'pygments'
 
module Jekyll
  class RenderGist< Liquid::Tag

    def initialize(tag_name, url, tokens)
      super

      url, @language = url.split(' ')

      if %r|gist.github.com/([^/]+)/?$| =~ url
        @gist_id = $1
      else
        $stderr.puts "Failed to parse gist URL '#{url}' from tag."
        $stderr.puts "URL should be in the form 'https://gist.github.com/123456'"
        exit(1);
      end

      @gist = get_gist_data(@gist_id)
    end
    
    def render(context)
      if @gist.nil?
        gist_script_tag(@gist_id)
      else
        output = ''

        if context.registers[:site].pygments
          for name, file in @gist['files']
            output += render_pygments(context, file)
          end
        end

        output = add_script_tags(output)
      end
    end

    def render_pygments(context, file)
      language = @language || determine_language(file)

      options = {'encoding' => 'utf-8'}
      output = add_code_tags(Pygments.highlight(file['content'], :lexer => language, :options => options), language)
      output = context["pygments_prefix"] + output if context["pygments_prefix"]
      output = output + context["pygments_suffix"] if context["pygments_suffix"]
    end

    def add_code_tags(code, language)
      code = code.sub(/<pre>/,'<pre><code class="' + language + '">')
      code = code.sub(/<\/pre>/,"</code></pre><p><a href=\"https://gist.github.com/#{@gist_id}\">This Gist</a> hosted on <a href=\"http://github.com/\">GitHub</a>.</p>")
    end

    def add_script_tags(code)
      "<div class=\"gist\">#{gist_script_tag(@gist_id)}<noscript>#{code}</noscript></div>"
    end

    def gist_script_tag(gist_id)
      "<script src=\"https://gist.github.com/#{gist_id}.js\"> </script>"
    end

    def get_gist_data(gist_id)
      begin
        json = open("https://api.github.com/gists/#{gist_id}").read
        JSON.parse(json)
      rescue => error
        $stderr.puts "Unable to open gist URL: #{error}"
        $stderr.puts "\tNote: gist \##{gist_id} will not have generated <noscript> source"
      end
    end

    def determine_language(file)
      if Pygments::Lexer.find(file['language'])
        file['language'].downcase
      else
        'text'
      end
    end

  end
end

Liquid::Template.register_tag('render_gist', Jekyll::RenderGist)