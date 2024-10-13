class WistiaService
  include HTTParty
  base_uri 'https://api.wistia.com/v1'

  def initialize
    @options = { headers: { "Authorization" => "Bearer #{ENV.fetch('WISTIA_API_TOKEN', '')}" } }
  end

  def fetch_videos
    response = self.class.get('/medias.json', @options)
    return JSON.parse(response.body) if response.success?

    log_error(response)
    []
  end

  def fetch_video_stats(video_hash)
    response = self.class.get("/stats/medias/#{video_hash}.json", @options)
    return JSON.parse(response.body) if response.success?

    log_error(response)
    {}
  end

  private

  def log_error(response)
    Rails.logger.error("Wistia API Error: #{response.code} - #{response.message}")
  end
end
