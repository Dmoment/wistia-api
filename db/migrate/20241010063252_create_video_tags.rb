class CreateVideoTags < ActiveRecord::Migration[7.2]
  def change
    create_table :video_tags do |t|
      t.references :video, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
