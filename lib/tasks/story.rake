namespace :story do

  desc "Send story email notifications"
  task send_emails: :environment do
    Story.send_emails
  end

  desc "Populates story bodies after story is finished"
  task populate_body: :environment do
  	Story.populate_body
  end

end
