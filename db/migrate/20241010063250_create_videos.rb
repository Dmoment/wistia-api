class CreateVideos < ActiveRecord::Migration[7.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :wistia_hash
      t.boolean :visible

      t.timestamps
    end
  end
end
