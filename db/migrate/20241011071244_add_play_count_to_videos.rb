class AddPlayCountToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :play_count, :integer
  end
end
