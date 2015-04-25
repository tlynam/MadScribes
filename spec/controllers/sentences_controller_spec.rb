require 'rails_helper'

describe SentencesController do
  let(:story) { Story.create! user: user, title: 'A title', started_at: Time.now }
  let(:sentence) { Sentence.create! user: user, story: story, body: "Test sentence" }
  let(:user) { User.create! email: 'a@b.c', password: '123sdfh!', password_confirmation: '123sdfh!' }
  let(:user2) { User.create! email: 'b@c.c', password: '123sdfh!', password_confirmation: '123sdfh!' }
  let(:previous_page) { "http://test.host/stories/#{story.id}" }

  before do
    request.env['HTTP_REFERER'] = previous_page
    sign_in user
  end

  describe '#create' do
    it 'saves when story has started' do
      post :create, sentence: { body: 'foo' }, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.first.body).to eq 'foo.'
    end
    it 'does not save when story has not started' do
      story.update! started_at: nil

      post :create, sentence: { body: 'foo' }, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.none?).to eq true
    end
    it 'does not save when story has ended' do
      story.update! started_at: 1.day.ago

      post :create, sentence: { body: 'foo' }, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.none?).to eq true
    end
    it 'does not save when story is in voting period' do
      story.update! started_at: 45.seconds.ago

      post :create, sentence: { body: 'foo' }, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.none?).to eq true
    end
    it 'does not save when user has already submitted a sentence for this round' do
      post :create, sentence: { body: 'foo' }, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.count).to eq 1

      post :create, sentence: { body: 'bar' }, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.count).to eq 1
    end
  end

  describe '#vote' do
    it 'fails with 404 when story doesnt exist' do
      expect{
        post :vote, id: -1, story_id: -1
      }.to raise_error ActiveRecord::RecordNotFound
    end
    it 'fails with 404 when sentence doesnt exist' do
      expect{
        post :vote, id: -1, story_id: story.id
      }.to raise_error ActiveRecord::RecordNotFound
    end
    context 'within the voting period' do
      before do
        sentence
        story.update! started_at: 45.seconds.ago
      end
      it 'updates votes array with current user id' do
        post :vote, id: sentence.id, story_id: story.id
        expect(sentence.reload.votes).to eq [user.id]
      end
      it 'updates the current winner' do
        competitor = Sentence.new(user: user2, story: story, body: "Test sentence2")
        competitor.save validate: false
        competitor.update! votes: [1], winner: true
        sentence.update! votes: [1]

        post :vote, id: sentence.id, story_id: story.id
        expect(sentence.reload.winner?).to eq true
        expect(competitor.reload.winner?).to eq false
      end
    end
    context 'within the writing period' do
      before do
        sentence
        story.update! started_at: Time.now
      end
      it 'fails to update votes array' do
        post :vote, id: sentence.id, story_id: story.id
        expect(sentence.reload.votes).to eq []
      end
    end
  end
end
