require 'rails_helper'

describe SentencesController do
  let(:story) { Story.create! user: user, title: 'A title', started_at: Time.now }
  let(:user) { User.create! email: 'a@b.c', password: '123sdfh!', password_confirmation: '123sdfh!' }
  let(:previous_page) { "http://test.host/stories/#{story.id}" }

  before do
    request.env['HTTP_REFERER'] = previous_page
    sign_in user
  end

  describe '#create' do
    it 'saves when story has started' do
      post :create, sentence: {body: 'foo'}, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.first.body).to eq 'foo.'
    end
    it 'does not save when story has not started' do
      story.update! started_at: nil

      post :create, sentence: {body: 'foo'}, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.none?).to eq true
    end
    it 'does not save when story has ended' do
      story.update! started_at: 1.day.ago

      post :create, sentence: {body: 'foo'}, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.none?).to eq true
    end
    it 'does not save when story is in voting period' do
      story.update! started_at: 45.seconds.ago

      post :create, sentence: {body: 'foo'}, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.none?).to eq true
    end
    it 'does not save when user has already submitted a sentence for this round' do
      post :create, sentence: {body: 'foo'}, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.count).to eq 1

      post :create, sentence: {body: 'bar'}, story_id: story.id
      expect(response.location).to eq previous_page
      expect(story.sentences.count).to eq 1
    end
  end
end
