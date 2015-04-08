# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

sentences = <<-TEXT.split "\n"
Scientists were stunned, they couldn't believe their eyes as the data scrolled out of the printer.
"Hutchins, what is it?" one scientist asked another. "You're not going to believe this," said Hutchins, "but our sun has gone on leave."
Dr. Mitchell removed his spectacles, his stare far off in the distance. "My. God." he whispered.
"Alert the president immediately," The Dr. ordered. "Code 1160."
The next day, the President and his cabinet held an emergency meeting. Order 57 had passed. Operation Silent Night began.
Martial law was declared, soldiers roamed the streets with lights shining from their helmets. Occasionally, a gunshot was heard.
Nobody knew why the sky was still dark. Nobody knew why officials with guns killed innocent people. The President knew. He knew everything.
As the riots continued in the streets, a lone computer hacker named Zero Cool navigated the NY subway with his laptop.
He thought of himself as the savior. The Vigilante. He tapped at the keys, looked up, and stared into the barrel of a gun.
"Mr. President," he said. "Steve," said the president.
He pulled back the hammer on his revolver, "I've told you I dont know how many times. Call me Dad."
"You know I can't let you foil these plans. Too much has gone into this. The world needs to go through this transition." He continued.
In the distance Zero Cool could hear the running footsteps of his father's secret government cabal coming to his aid.
"You only have one option, Steve. You have no choice." His father's face glowed with self-assurance.
"There's always a choice..." And Zero smiled as he activated the explosives.
TEXT

user = User.create! email: "Test@test.com", password: "password123", password_confirmation: "password123"

story = Story.create! title: 'The Day the Sun Took a Break', user: user, started_at: Time.now, body: sentences.join("\n")

sentences.each_with_index do |sentence, index|
  sentence = story.sentences.build body: sentence, user: user, round: index+1, votes: [user.id]
  sentence.save validate: false
end
