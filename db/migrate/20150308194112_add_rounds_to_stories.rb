class AddRoundsToStories < ActiveRecord::Migration
  def change
    add_column :stories, :rounds, :integer, default: 10, null: false
  end
end
