class GroupsController < BaseController
  # Filters
  before_filter :login_required
  layout "application"

  def index
    if !params[:id]
      @my_groups = current_user.member_groups
      @popular_groups = Group.popular.paginate(:page => params[:page], :per_page => 50)
      render 'my_groups'
    else
      @group = Group.find(params[:id])
      @group_member = true if GroupMember.actual_member(@group, current_user)
      @member_is_moderator = GroupMember.moderator?(@group, current_user) if @group_member
    end
  end

  def assign_values
    @pending_members = GroupMember.pending_members(@group)
    @members = GroupMember.members(@group)
    @owner = @group.user
    @moderators = GroupMember.moderator(@group)
    @current_user_pending = GroupMember.find_pending(@group, current_user)
    @posts = @group.posts.order('updated_at DESC').paginate(:per_page => 15, :page => params[:page])
    @group_member = true if GroupMember.actual_member(@group, current_user)
    @member_is_moderator = GroupMember.moderator?(@group, current_user) if @group_member
  end

  def show
    @group = Group.find(params[:id])
    assign_values
  end

  def new
    @user = current_user
    @group = @user.groups.new
  end

  def create
    @user = current_user
    @group = @user.groups.new(params[:group])
    @group.members << current_user
    if @group.save
      member = GroupMember.get_record(@group.id, current_user.id)
      member.accept!
      member.moderator = true
      member.save
      redirect_to groups_url, :notice => "Successfully created #{@group.title} Page."
    else
      flash[:error] = "Failed to Create the #{@group.title} Page"
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
    @group = @user.member_groups.where(['guid = ?', params[:id]]).first
    render :back, :notice => "You dont have rights to edit this group" if !@group
  end

  def update
    @user = current_user
    @group = @user.member_groups.where(['guid = ?', params[:id]]).first
    if @group.update_attributes(params[:group])
      Resque.enqueue(Job::PageLogo, @group.guid)
      flash[:notice] = "Successfully updated #{@group.title} Page."
      redirect_to edit_group_url(@group.guid)
    else
      flash[:error] = "Failed to edit the #{@group.title} Page"
      render :action => 'edit'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to root_url, :notice => "Successfully destroyed #{@group.title} Page."
  end

  def add_member
    @group = Page.find(params[:id])
    if @group.public
      accept_member_directly
    else
      send_request_to_moderator
    end
  end

  def send_request_to_moderator
    if !(@group.members.include?(current_user))
      @group.members << current_user
      render :text => "<h4>Request has been sent to the Moderator to approve !</h4>"
    else
      render :text => "<h4> Your Request is already in queue !</h4>"
    end
  end

  def accept_member_directly
    if !(@group.members.include?(current_user))
      @group.members << current_user
      group_member = GroupMember.get_record(@group.id, current_user.id)
      if group_member.accept!
        render :text => "<h4>You are now a member to this Page </h4>"
      end
    else
      render :text => "<h4> You are already a member !</h4>"
    end
  end

  def accept_member
    group = Page.find(params[:group])
    group_member = GroupMember.get_record(group.id, params[:member])
    if group_member.accept!
      redirect_to group_url(:id => group), :notice => "#{group_member.member.first_name} accepted as a member to this Page"
    else
      render :text => "#{group_member.member.first_name} cannot be accepted as a member to this Page"
    end
  end

  def reject_member
    group = Page.find(params[:group])
    group_member = GroupMember.get_record(group, params[:member])
    if group_member.reject!
      redirect_to group_url(:id => group), :notice => "#{group_member.member.first_name} rejected as a member to this Page"
    else
      render :text => "<h4>#{group_member.member.first_name} cannot be rejected as a member to this Page</h4>"
    end
  end

  def make_moderator
    group = Page.find(params[:group])
    group_member = GroupMember.get_record(group, params[:member])
    group_member.moderator = true
    group_member.save
    flash[:notice] = "Successfully updated as a Moderator to the Page #{group.title}."
    redirect_to groups_url(:id => group.guid)
  end

  def remove_moderator
    group = Page.where(['guid = ? or id = ?', params[:group], params[:group]]).first
    group_member = GroupMember.get_record(group, params[:member])
    group_member.moderator = false
    group_member.save
    flash[:notice] = "Successfully Removed as a Moderator to the Page #{group.title}."
    redirect_to groups_url(:id => group.guid)
  end

  def leave
    group = Group.find(params[:id])
    group_member = GroupMember.get_record(group, current_user.id)
    group_member.destroy
    redirect_to root_url, :notice => "You left the #{group.title} Page successfully."
  end

  def invite
    @group = Group.find(params[:id])
    @all_contacts_and_ids = current_user.contacts.map { |c| {:value => c.id, :name => c.email} }
    @contact = current_user.contacts.find(params[:contact_id]) if params[:contact_id]
    render :layout => false
  end

  def invite_friends
    Rails.logger.info("RESULT #{params[:contact_ids]} <-> #{params[:contact_autocomplete]}")
    if params[:contact_ids]
      user_ids = Contact.where(:id => params[:contact_ids].split(',')).map! do |contact|
        #contact.person.owner.email
        contact.person
      end
    end
    @group = params[:id]
    @group_object = Page.find_by_guid(@group)
    @sender_id = current_user.email
    Postzord::Dispatch.new(current_user, @group_object, nil).invite_group_members(person_ids)
    redirect_to :back
  end

  def search
    @groups = Page.all.paginate(
        :group => params[:group], :per_group => 30)
    @my_groups = current_user.member_groups
    render :action => "search", :layout => false
  end

  def term_search
    @groups = Page.search(params[:group_search]).paginate(
        :group => params[:group], :per_group => 30)
    @my_groups = current_user.member_groups
    respond_to do |format|
      format.js
      format.html
    end
  end
end
