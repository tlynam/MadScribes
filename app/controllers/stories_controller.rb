require 'pg_notify'

class StoriesController < ApplicationController
  include Tubesock::Hijack
  include PGNotify

  def index
    @stories = Story.search(params[:q]).paginate(page: params[:page], per_page:  10).order('created_at DESC')
    @live_stories = Story.active.paginate(page: params[:page], per_page:  10).order('created_at DESC')
  end

  def show
    @story = Story.find params[:id]
    @sentence = Sentence.new story_id: @story.id unless @sentence
  end

  def new
    redirect_to new_user_session_path unless signed_in?
    @story = Story.new user: current_user
  end

  def create
    @story = Story.new **story_params.symbolize_keys, user: current_user

    if @story.save
      redirect_to @story
    else
      render 'new'
    end
  end

  def start
    story = Story.find params[:id]
    story.update_attribute(:started_at, Time.now)
    redirect_to story
  end

  def is_active
    story = Story.find params[:id]
    render json: story.active?
  end

  def subscribe
    story = Story.find params[:id]
    story.subscriptions.create user: current_user
    redirect_to story
  end

  def chat
    hijack do |websocket|
      websocket.onopen do
        listen_for 'chat' do |payload|
          if payload[:story_id] == params[:id]
            websocket.send_data payload[:message]
          end
        end
      end

      websocket.onmessage do |data|
        notify 'chat', story_id: params[:id], message: data
      end
    end
  end

  private

  def story_params
    params.require(:story).permit :id, :title, :writing_period, :voting_period, :rounds
  end
end
