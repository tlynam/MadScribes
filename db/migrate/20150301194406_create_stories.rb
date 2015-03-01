class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.references :user, index: true
      t.string :title
      t.text :body
      t.integer :writing_period, default: 45, null: false
      t.integer :voting_period, default: 45, null: false

      t.timestamps null: false
    end
  end
end
