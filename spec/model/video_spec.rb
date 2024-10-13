require 'rails_helper'

RSpec.describe Video, type: :model do
  let(:wistia_service) { instance_double(WistiaService) }

  before do
    allow(WistiaService).to receive(:new).and_return(wistia_service)
  end

  describe '.sync_with_wistia' do
    let(:wistia_videos) do
      [
        { 'hashed_id' => 'abc123', 'name' => 'Video 1', 'description' => 'Description 1' },
        { 'hashed_id' => 'xyz789', 'name' => 'Video 2', 'description' => 'Description 2' }
      ]
    end

    let(:video_stats) { { 'play_count' => 5 } }

    before do
      allow(wistia_service).to receive(:fetch_videos).and_return(wistia_videos)
      allow(wistia_service).to receive(:fetch_video_stats).with('abc123').and_return(video_stats)
      allow(wistia_service).to receive(:fetch_video_stats).with('xyz789').and_return(video_stats)
    end

    it 'creates or updates videos based on Wistia data' do
      expect { Video.sync_with_wistia }.to change { Video.count }.by(2)
      video = Video.find_by(wistia_hash: 'abc123')
      expect(video.title).to eq('Video 1')
      expect(video.play_count).to eq(5)
    end
  end
end
