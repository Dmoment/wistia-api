class Video < ApplicationRecord
  has_many :video_tags
  has_many :tags, through: :video_tags

  def self.sync_with_wistia
    wistia_service = WistiaService.new
    wistia_videos = wistia_service.fetch_videos

    wistia_videos.each do |wistia_video|
      video = find_or_initialize_by(wistia_hash: wistia_video['hashed_id'])
      video.update(
        title: wistia_video['name'],
        description: wistia_video['description'],
        visible: true
      )
    end
  end
end
