namespace :notifications do

  desc "Send story email notifications"
  task send_story_emails: :environment do
    puts "Going to send this many story email notifications: "
    puts Story.active.long_running.count
    Story.send_emails
    puts "Sent story emails"
  end

end
