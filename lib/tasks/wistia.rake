namespace :wistia do
  desc 'Sync videos from Wistia'
  task sync_videos: :environment do
    Video.sync_with_wistia
  end
end
