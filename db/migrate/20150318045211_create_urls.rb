class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :slug, limit: 7
      t.string :url, limit: 4096

      t.timestamps null: false
    end
    add_index :urls, :slug
    add_index :urls, :url
  end
end
