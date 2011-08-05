class LookForController < BaseController 
  def auto_complete
    @users = User.find(:all, :conditions => [ 'LOWER(login) LIKE ?', '%' + (params[:search]) + '%' ])
    render :inline => "<%=raw auto_complete_search_result(@users, 'login') %>"
  end
end
