require 'pg_notify'

class StoriesController < ApplicationController
  include Tubesock::Hijack
  @@notifier = PGNotify.new('chat')

  def index
    @stories = Story.search(params[:q]).paginate(page: params[:page], per_page:  10).order('created_at DESC')
    @live_stories = Story.active.paginate(page: params[:page], per_page:  10).order('created_at DESC')
    @pending_stories = Story.pending.paginate(page: params[:page], per_page:  10).order('created_at DESC')
  end

  def show
    @story = Story.includes(subscriptions: :user).find params[:id]
    @users = @story.subscriptions.map { |subscription| subscription.user }.uniq
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

  def unsubscribe
    story = Story.find params[:id]

    scope = story.subscriptions
    if request.post? #When clicking button on story
      scope = scope.where user: current_user
    else #When clicking unsubscribe from email
      scope = scope.where unsubscribe_token: params[:token]
    end
    scope.destroy_all

    flash[:notice] = 'You have successfully unsubscribed.'
    redirect_to story
  end

  def chat
    hijack do |websocket|
      websocket.onopen do
        @@notifier.subscribe websocket do |payload|
          if payload[:id] == params[:id]
            websocket.send_data payload[:message]
          end
        end
      end

      websocket.onclose do
        @@notifier.unsubscribe websocket
      end

      websocket.onmessage do |message|
        user = current_user ? current_user.display_name : "Anonymous"
        @@notifier.notify id: params[:id], message: "#{user}: #{message}"
      end
    end
  end

  private

  def story_params
    params.require(:story).permit :id, :title, :writing_period, :voting_period, :rounds
  end
end
