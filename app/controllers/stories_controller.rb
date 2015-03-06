class StoriesController < ApplicationController
  def index
    @stories = Story.order(created_at: :desc).limit 5
  end

  def show
    @story = Story.find params[:id]
  end

  def new
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
    params.require(:story).permit :id, :title, :writing_period, :voting_period
  end
end
