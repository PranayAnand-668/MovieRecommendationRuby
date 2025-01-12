class CreateFavoriteMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :favorite_movies do |t|
      t.string :title

      t.timestamps
    end
  end
end
