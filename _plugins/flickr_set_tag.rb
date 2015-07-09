module Jekyll
  FlickRaw.api_key = Jekyll.configuration['flickr']['api_key']
  FlickRaw.shared_secret = Jekyll.configuration['flickr']['shared_secret']

  class Album
    attr_reader :id, :primary_id, :title, :description, :primary_large_square_url
    def initialize(flickr_album)
      @id = flickr_album['id']
      @primary_id = flickr_album['primary']
      @title = flickr_album['title']
      @description = flickr_album['description']
      @primary_large_square_url = build_primary_url(flickr_album)
    end

    def flickr_url
      "https://www.flickr.com/photos/audreypenven/sets/#{id}"
    end

    # flickr size code:
    # Square:       s
    # Large Square: q
    # Thumbnail:    t
    # Small:        m
    # Small 320:    n
    # Medium 640:   z
    # Medium 800:   c
    # Large:        b
    # Original:     o
    def build_primary_url(flickr_album, size = 'q')
      if flickr_album['primary_photo_extras']
        flickr_album['primary_photo_extras']["url_#{size}"]
      else
        farm = flickr_album['farm']
        server = flickr_album['server']
        secret = flickr_album['secret']

        "https://farm#{farm}.staticflickr.com/#{server}/#{primary_id}_#{secret}_#{size}.jpg"
      end
    end
  end

  class FlickrAlbumTag < Liquid::Tag
    def initialize(tag_name, photoset_id, tokens)
      super
      @album = Album.new(flickr.photosets.getInfo(photoset_id: photoset_id.to_i))
    end

    def render(context)
      "<img src='#{@album.primary_large_square_url}'>"
    end

  end

  class FlickrRecentAlbums < Liquid::Tag
    @@user_id = Jekyll.configuration['flickr']['user_id']

    def initialize(tag_name, album_count, tokens)
      super
      @album_count = album_count || 6
      get_albums_from_flickr
    end

    def render(context)
      # I hate this one line html crap, but it breaks haml to not do it this way
      @albums.map do |album|
        "<div class='flickr-album-link album-link'><img src='#{album.primary_large_square_url}' alt='#{album.title}'><a href='#{album.flickr_url}'><h4 class='album-title'>#{album.title}</h4></a></div>"
      end.join('')
    end

    def get_albums_from_flickr
      flickr_response = flickr.photosets.getList(user_id: @@user_id, per_page: @album_count, page: 1, primary_photo_extras: 'url_q')
      @albums = flickr_response.map {|album| Album.new(album)}
    end

  end
end
Liquid::Template.register_tag('flickr_album_tag', Jekyll::FlickrAlbumTag)
Liquid::Template.register_tag('flickr_recent_albums', Jekyll::FlickrRecentAlbums)
