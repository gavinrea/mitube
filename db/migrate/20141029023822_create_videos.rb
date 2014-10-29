class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :link
      t.string :uid
      t.string :title
      t.string :author
      t.string :duration
      t.integer :likes
      t.integer :dislikes

      t.timestamps
    end
  end
end
