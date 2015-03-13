class AddWinnerToSentences < ActiveRecord::Migration
  def change
    add_column :sentences, :winner, :boolean, default: false, null: false
  end
end
