module Api
  module V1
    class VideoTagsController < ApplicationController
      before_action :find_video, only: [:create]

      def create
        return render_error('Video not found', :not_found) unless @video

        @tag = Tag.find_or_create_by(tag_params)

        if @tag.persisted?
          attach_tag_to_video(@video, @tag)
        else
          render_error('Failed to create or find tag', :unprocessable_entity)
        end
      end

      private

      def find_video
        @video = Video.find_by(wistia_hash: params[:video_id])
      end

      def tag_params
        params.require(:tag).permit(:name)
      end

      def attach_tag_to_video(video, tag)
        if video.tags.exclude?(tag)
          video.tags << tag
        end

        render json: tag, status: :created
      end

      def render_error(message, status)
        render json: { error: message }, status: status
      end
    end
  end
end
