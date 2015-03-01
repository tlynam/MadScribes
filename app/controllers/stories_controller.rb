class StoriesController < ApplicationController
  def index
    @stories = Story.order(created_at: :desc).limit 5
  end

  def show
    @story = Story.find params[:id]
  end

end