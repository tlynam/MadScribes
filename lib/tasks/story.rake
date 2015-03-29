namespace :story do

  desc "Send story email notifications"
  task send_emails: :environment do
    puts "Going to send this many story email notifications: "
    puts Story.active.long_running.count
    Story.send_emails
    puts "Sent story emails"
  end

  desc "Populates story bodies after story is finished"
  task populate_body: :environment do
  	Story.populate_body
  end

end
