class CreateTexts < ActiveRecord::Migration[7.0]
  def change
    create_table :texts do |t|
      t.string :title
      t.string :link
      t.text :body

      t.timestamps
    end
  end
end
