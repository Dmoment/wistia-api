require 'rails_helper'

RSpec.describe Api::V1::VideosController, type: :request do
  describe 'PATCH /api/v1/videos/:id' do
    let!(:video) { create(:video, wistia_hash: 'abc123', visible: false) }

    it 'updates the video visibility' do
      patch "/api/v1/videos/#{video.wistia_hash}", params: { video: { visible: true } }
      expect(response).to have_http_status(:ok)
      expect(video.reload.visible).to be true
    end

    it 'returns an error when video does not exist' do
      patch '/api/v1/videos/invalid_id', params: { video: { visible: true } }
      expect(response).to have_http_status(:not_found)
    end
  end
end
