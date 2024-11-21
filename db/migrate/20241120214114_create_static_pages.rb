class CreateStaticPages < ActiveRecord::Migration[8.0]
  def change
    create_table :static_pages do |t|
      t.string :title
      t.text :content
      t.string :slug

      t.timestamps
    end
    add_index :static_pages, :slug, unique: true
  end
end
