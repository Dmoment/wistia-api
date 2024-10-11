module Api
  module V1
    class VideosController < ApplicationController
      def index
        @videos = Video.includes(:tags).where(visible: true)
        render json: @videos.to_json(include: :tags)
      end

      def update
        @video = Video.find_by(wistia_hash: params[:id])
        if @video.update(video_params)
          render json: @video
        else
          render json: @video.errors, status: :unprocessable_entity
        end
      end

      private

      def video_params
        params.require(:video).permit(:visible)
      end
    end
  end
end
