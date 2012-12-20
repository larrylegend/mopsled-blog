require 'json'

module Jekyll
  class JSONToArrayTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
      super
      @file, @variable = params.split(',', 2).map{ |x| x.strip }
    end

    def render(context)
      includes_dir = File.join(context.registers[:site].source, '_includes')
      json_file = File.join(includes_dir, @file)

      if File.file? json_file
        json = File.read(json_file)
        context.environments.first[@variable] = JSON.parse(json)
        return
      else
        "Included file '#{@file}' not found in _includes directory"
      end
    end
  end
end

Liquid::Template.register_tag('json_to_array', Jekyll::JSONToArrayTag)