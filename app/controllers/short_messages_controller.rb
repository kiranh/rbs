class ShortMessagesController < BaseController
  before_filter :login_required
  before_filter :find_user

  def index
    @user = User.find(params[:user_id])
    @messages = ShortMessage.find_all_by_user_id(@user.id)
    @message = ShortMessage.new
    respond_to do |format|
      format.html
      format.js
    end
  end
end
