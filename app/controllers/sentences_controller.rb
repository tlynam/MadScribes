class SentencesController < ApplicationController
  def create
    story = Story.find(params[:story_id])

    story.sentences.create(
      user: current_user,
      body: sentence_params[:body].squish
    )

    redirect_to story
  end

  def vote
    story = Story.find(params[:story_id])
    sentence = story.sentences.find(params[:id])
    sentence.votes << current_user.id
    sentence.update_current_winner unless sentence.winner?

    sentence.save
    redirect_to story
  end

  def sentence_params
    params.require(:sentence).permit :id, :body, :story_id
  end
end
