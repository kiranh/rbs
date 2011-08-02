class SearchController < BaseController 

  def auto_complete
    @users = User.find(:all, :conditions => [ 'LOWER(login) LIKE ?', '%' + (params[:search]) + '%' ])
    render :inline => "<%=raw auto_complete_result(@users, 'login') %>"
  end

  private
  
  def find_user
    @user = User.find(params[:user_id])
  end
end
