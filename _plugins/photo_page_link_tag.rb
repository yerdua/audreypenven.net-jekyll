module Jekyll
  class PhotoPageLinkTag < Liquid::Tag
    def initialize(tag_name, key, tokens)
      super
      @key = key.strip
    end

    def render(context)
      @title = context.registers[:site].data['photography'][@key]['title']

      "<div class='album-link portfolio-link'>#{img_tag}#{a_tag}</div>"
    end

    def img_tag
      "<img src='/images/photography/#{@key}/album-thumbnail.jpg' alt='#{@title}'>"
    end

    def a_tag
      "<a href='/photography/#{@key}'><h3 class='album-title'>#{@title}</h3></a>"
    end
  end
end
Liquid::Template.register_tag('photo_page_link_tag', Jekyll::PhotoPageLinkTag)