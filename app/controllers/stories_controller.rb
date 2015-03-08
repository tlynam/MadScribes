class StoriesController < ApplicationController
  def index
    @stories = Story.order(created_at: :desc).limit 5
  end

  def show
    @story = Story.find params[:id]

    @sentence = Sentence.new story_id: @story.id
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

  def story_params
    params.require(:story).permit :id, :title, :writing_period, :voting_period, :rounds
  end

  def start_story
    story = Story.find params[:id]
    story.update_attribute(:started_at, Time.now)
    redirect_to story
  end

end
