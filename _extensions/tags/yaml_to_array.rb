require 'json'

module Jekyll
  class YAMLToArray < Liquid::Tag
    def initialize(tag_name, params, tokens)
      super
      @file, @variable = params.split(',', 2).map{ |x| x.strip }
    end

    def render(context)
      includes_dir = File.join(context.registers[:site].source, '_includes')
      yaml_file = File.join(includes_dir, @file)

      if File.file? yaml_file
        context.environments.first[@variable] = YAML.load_file(yaml_file)
        return
      else
        "Included file '#{@file}' not found in _includes directory"
      end
    end
  end
end

Liquid::Template.register_tag('yaml_to_array', Jekyll::YAMLToArray)