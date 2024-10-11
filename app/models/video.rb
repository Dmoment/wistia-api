class Video < ApplicationRecord
  has_many :video_tags
  has_many :tags, through: :video_tags

  def self.sync_with_wistia
    wistia_service = WistiaService.new
    wistia_videos = wistia_service.fetch_videos

    wistia_videos.each do |wistia_video|
      video = find_or_initialize_by(wistia_hash: wistia_video['hashed_id'])
      play_count = wistia_service.fetch_video_stats(wistia_video['hashed_id'])['play_count']

      video.update(
        title: wistia_video['name'],
        description: wistia_video['description'],
        play_count: play_count || 0, # Set play_count to 0 if it's not available
        visible: true
      )
    end
  end
end
