class AddUnsubscribeTokenToSubscriptions < ActiveRecord::Migration
  def up
  	add_column :subscriptions, :unsubscribe_token, :text

  	Subscription.all.each do |s|
  		s.create_unsubscribe_token
  		s.save!
  	end
  end

  def down
  	remove_column :subscriptions, :unsubscribe_token
  end
end
