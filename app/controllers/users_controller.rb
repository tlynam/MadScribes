class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    
    redirect_to root_path, :flash => { :notice => "You're out of your element, you can't visit other peoples' private spaces!" } unless @user == current_user
  end
end
