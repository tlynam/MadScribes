class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.text :body, null: false
      t.references :user, null: false, index: true
      t.references :story, null: false, index: true
      t.integer :round, default: 1, null: false
      t.integer :votes, array: true, default: [], null: false, index: true

      t.timestamps null: false
    end
    add_foreign_key :sentences, :users
    add_foreign_key :sentences, :stories
  end
end
