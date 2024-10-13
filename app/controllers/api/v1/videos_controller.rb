module Api
  module V1
    class VideosController < ApplicationController
      before_action :find_video, only: [:update]

      # GET /api/v1/videos
      def index
        videos = Video.includes(:tags).where(visible: true)
        render json: videos.to_json(include: :tags)
      end

      # PATCH/PUT /api/v1/videos/:id
      def update
        return render_error('Video not found', :not_found) unless @video

        if @video.update(video_params)
          render json: @video, status: :ok
        else
          render_error(@video.errors.full_messages, :unprocessable_entity)
        end
      end

      private

      def find_video
        @video = Video.find_by(wistia_hash: params[:id])
      end

      def video_params
        params.require(:video).permit(:visible)
      end

      def render_error(message, status)
        render json: { error: message }, status: status
      end
    end
  end
end
