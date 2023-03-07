class DeletePhotoColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :photo
    remove_column :celestial_bodies, :photo
  end
end
