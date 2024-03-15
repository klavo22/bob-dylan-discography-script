require 'dotenv/load'
require 'rspotify'
require 'trello'

class BobDylanDiscography
  def initialize
    @discography_by_decade = {}
    @albums_data = []
  end

  def fetch_albums_from_spotify
    RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

    artist = RSpotify::Artist.search('Bob Dylan').first
    artist.albums.each do |album|
      @albums_data << { name: album.name, cover: album.images.first['url'] || '' }
    end
  end

  def get_album_cover(album_name)
    album_name = album_name.downcase
    @albums_data.each do |album|
      return album[:cover] if album_name == album[:name].downcase
    end
    ''
  end

  def sort_discography
    @discography_by_decade = @discography_by_decade.sort.reverse.to_h.transform_values do |albums|
      albums.sort_by { |album| [album[:year], album[:title]] }
    end
  end

  def generate_trello_board
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
  
    board = Trello::Board.create(name: "Bob Dylan Discography")
  
    board.lists.each do |list|
      list.close! if ["To Do", "Doing", "Done"].include?(list.name)
    end    
  
    @discography_by_decade.each do |decade, albums|
      list = Trello::List.create(name: "#{decade}s", board_id: board.id)
  
      albums.each do |album|
        card = Trello::Card.create(
          name: "#{album[:year]} - #{album[:title]}",
          list_id: list.id,
          desc: "Cover: #{album[:cover]}"
        )
      end
    end

    puts "Trello board created: #{board.url}"
  end

  def process_file
    File.foreach("data/discography.txt") do |line|
      disc_data = line.split(" ", 2)
    
      year = disc_data[0]
      title = disc_data[1].chomp
      decade = (year.to_i / 10) * 10
    
      @discography_by_decade[decade] = [] unless @discography_by_decade.key?(decade)
      @discography_by_decade[decade] << { year: year, title: title, cover: get_album_cover(title) }
    end
  end

  def run
    fetch_albums_from_spotify
    process_file
    sort_discography
    generate_trello_board
  end
end
