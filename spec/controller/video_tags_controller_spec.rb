require 'rails_helper'

RSpec.describe Api::V1::VideoTagsController, type: :request do
  let!(:video) { create(:video, wistia_hash: 'abc123') }
  let(:valid_tag_params) { { tag: { name: 'Sample Tag' } } }
  let(:invalid_video_id) { 'invalid_id' }

  describe 'POST /api/v1/videos/:video_id/video_tags' do
    context 'when the video exists' do
      context 'and the tag is successfully created or found' do
        it 'attaches the tag to the video and returns the tag' do
          expect {
            post "/api/v1/videos/#{video.wistia_hash}/video_tags", params: valid_tag_params
          }.to change { Tag.count }.by(1)

          expect(response).to have_http_status(:created)
          expect(json['name']).to eq('Sample Tag')
          expect(video.reload.tags.pluck(:name)).to include('Sample Tag')
        end

        it 'does not create a duplicate tag if it already exists' do
          create(:tag, name: 'Sample Tag')

          expect {
            post "/api/v1/videos/#{video.wistia_hash}/video_tags", params: valid_tag_params
          }.not_to change { Tag.count }

          expect(response).to have_http_status(:created)
          expect(json['name']).to eq('Sample Tag')
          expect(video.reload.tags.pluck(:name)).to include('Sample Tag')
        end
      end

      context 'and the tag creation fails' do
        let(:invalid_tag_params) { { tag: { name: '' } } }

        it 'returns an error' do
          post "/api/v1/videos/#{video.wistia_hash}/video_tags", params: invalid_tag_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json['error']).to eq('Failed to create or find tag')
        end
      end
    end

    context 'when the video does not exist' do
      it 'returns an error' do
        post "/api/v1/videos/#{invalid_video_id}/video_tags", params: valid_tag_params
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Video not found')
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end
