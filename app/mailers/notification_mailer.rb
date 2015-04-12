class NotificationMailer < ApplicationMailer
  default from: 'notifications@madscribes.com'
 
  def notification_email(story,user)
      @user = user
      @story = story
      @subscription = story.subscriptions.where(user: user).first
      mail(from: "have_a_good_day@madscribes.com", to: @user.email,
        subject: "Hi #{@user.display_name}, it's the #{@story.period} period in the story: #{@story.title}")
  end
end
