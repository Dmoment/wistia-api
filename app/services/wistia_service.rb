class WistiaService
  include HTTParty
  base_uri 'https://api.wistia.com/v1'

  def initialize
    @options = { headers: { "Authorization" => "Bearer #{ENV['WISTIA_API_TOKEN']}" } }
  end

  def fetch_videos
    self.class.get('/medias.json', @options)
  end
end
