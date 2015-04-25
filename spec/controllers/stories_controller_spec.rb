require 'rails_helper'

describe StoriesController do
  let(:user) { User.create! email: 'a@b.c', password: '123sdfh!', password_confirmation: '123sdfh!' }
  let(:user2) { User.create! email: 'bb@dd.ee', password: '123sdfh!', password_confirmation: '123sdfh!' }
  let(:story1) { Story.create! user: user, title: 'Title 1', started_at: 1.day.ago }
  let(:story2) { Story.create! user: user, title: 'Title 2', started_at: 1.day.ago }
  let(:story3) { Story.create! user: user, title: 'Title 3', started_at: 1.day.ago }

  sentences = <<-TEXT.strip_heredoc.split "\n"
    Scientists were stunned, they couldn't believe their eyes as the data scrolled out of the printer.
    "Hutchins, what is it?" one scientist asked another. "You're not going to believe this," said Hutchins, "but our sun has gone on leave."
    Dr. Mitchell removed his spectacles, his stare far off in the distance. "My. God." he whispered.
    "Alert the president immediately," The Dr. ordered. "Code 1160."
    The next day, the President and his cabinet held an emergency meeting. Order 57 had passed. Operation Silent Night began.
    Martial law was declared, soldiers roamed the streets with lights shining from their helmets. Occasionally, a gunshot was heard.
    Nobody knew why the sky was still dark. Nobody knew why officials with guns killed innocent people. The President knew. He knew everything.
    As the riots continued in the streets, a lone computer hacker named Zero Cool navigated the NY subway with his laptop.
    He thought of himself as the savior. The Vigilante. He tapped at the keys, looked up, and stared into the barrel of a gun.
  TEXT

  before do
  	sentences.each_slice(3).with_index do |sentences, index|
      story = send "story#{index + 1}"
      sentences.each_with_index do |body, index|
  		  sentence = story.sentences.build body: body, winner: true, user: user, round: index + 1
        sentence.save validate: false
      end
  	end

    Story.populate_body
  end

  describe '#start' do
    it 'starts the story' do
      test_story = Story.create! user: user, title: 'A title'

      post :start, id: test_story.id
      expect(test_story.reload.started_at).to be_a Time
    end
  end

  describe '#active?' do
    it 'should be active' do
      test_story = Story.create! user: user, title: 'A title', started_at: 1.minute.ago
      expect(test_story.active?).to eq true
    end

    it 'shouldnt be active' do
      test_story = Story.create! user: user, title: 'A title'
      expect(test_story.active?).to eq false
    end
  end

  describe '#subscribe' do
    it 'should subscribe a user' do
      sign_in user2

      expect {
        post :subscribe, id: story2.id
      }.to change{story2.subscriptions.count}.by(1)
    end
  end

  describe '#unsubscribe' do
    it 'should unsubscribe a user' do
      sign_in user

      expect {
        post :unsubscribe, id: story2.id
      }.to change{story2.subscriptions.count}.by(-1)
    end
    it 'shouldnt unsubscribe a user' do
      sign_in user2

      expect {
        post :unsubscribe, id: story2.id
      }.to change{story2.subscriptions.count}.by(0)
    end
  end

  describe '#search' do
    it 'shows all records when no search has been applied' do
      get :index
      expect(assigns(:stories).count).to eq 3
    end
    it 'shows one story' do
      get :index, q: 'cabinet'
      expect(assigns(:stories).count).to eq 1
    end
    it 'shows many stories' do
      get :index, q: 'president'
      expect(assigns(:stories).count).to eq 2
    end
    it 'shows no stories when none match' do
      get :index, q: 'excellent'
      expect(assigns(:stories).count).to eq 0
    end
  end

end
