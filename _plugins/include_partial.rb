module Jekyll
  class IncludePartial < Liquid::Tag
    def initialize(tag_name, filename, tokens)
      super
      @filename = filename.strip
    end

    def render(context)
      if File.exist?(@filename)
        File.read @filename
      end
    end

  end
end
Liquid::Template.register_tag('include_partial', Jekyll::IncludePartial)