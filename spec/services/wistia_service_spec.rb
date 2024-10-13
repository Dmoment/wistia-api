require 'rails_helper'

RSpec.describe WistiaService do
  let(:wistia_service) { WistiaService.new }

  describe '#fetch_videos' do
    context 'when the API request is successful' do
      before do
        stub_request(:get, 'https://api.wistia.com/v1/medias.json')
          .to_return(status: 200, body: [{ "hashed_id": "abc123", "name": "Sample Video" }].to_json, headers: {})
      end

      it 'returns the parsed response' do
        response = wistia_service.fetch_videos

        expect(response).to be_an(Array)
        expect(response.first['hashed_id']).to eq('abc123')
      end
    end

    context 'when the API request fails' do
      before do
        stub_request(:get, 'https://api.wistia.com/v1/medias.json')
          .to_return(status: 500, body: '', headers: {})
      end

      it 'returns an empty array' do
        response = wistia_service.fetch_videos
        expect(response).to eq([])
      end
    end
  end
end
