module Api
  module V1
    class VideoTagsController < ApplicationController
      def create
        @video = Video.find_by(wistia_hash: params[:video_id])
        @tag = Tag.find_or_create_by(name: params[:tag][:name])

        if @video && @tag
          @video.tags << @tag unless @video.tags.include?(@tag)
          render json: @tag, status: :created
        else
          render json: { error: 'Video or Tag not found' }, status: :unprocessable_entity
        end
      end
    end
  end
end
