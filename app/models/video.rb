class Video < ApplicationRecord
  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags

  def self.sync_with_wistia
    wistia_service = WistiaService.new
    wistia_videos = wistia_service.fetch_videos

    wistia_videos.each_slice(50) do |video_batch|
      video_batch.each do |wistia_video|
        sync_video_with_wistia(wistia_service, wistia_video)
      end
    end
  end

  def self.sync_video_with_wistia(wistia_service, wistia_video)
    video = find_or_create_by(wistia_hash: wistia_video['hashed_id'])
    play_count_data = wistia_service.fetch_video_stats(wistia_video['hashed_id'])
    play_count = play_count_data['play_count']

    video.assign_attributes(
      title: wistia_video['name'],
      description: wistia_video['description'],
      play_count: play_count || 0, # Set play_count to 0 if it's not available
      visible: true
    )

    # Only save if changes were made
    video.save if video.changed?
  end
end
