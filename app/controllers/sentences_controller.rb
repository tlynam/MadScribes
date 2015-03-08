class SentencesController < ApplicationController
  def create
    Story.find(params[:story_id]).sentences.create **sentence_params.symbolize_keys, user: current_user

    redirect_to :back
  end

  def sentence_params
    params.require(:sentence).permit :id, :body, :story_id
  end
end
