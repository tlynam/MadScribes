class NotificationMailer < ApplicationMailer
  default from: 'notifications@madscribes.com'
 
  def notification_email(story,user)
      @user = user
      @story = story
      mail(from: "muse_formerly_known_as_thalia@madscribes.com", to: @user.email,
        subject: "Hi #{@user.display_name}, it's the #{@story.period} period in the story: #{@story.title}")
  end
end
