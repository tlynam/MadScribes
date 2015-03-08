class AddStartedAtToStories < ActiveRecord::Migration
  def change
    add_column :stories, :started_at, :datetime
  end
end
