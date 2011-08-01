module FriendshipsHelper

  def friendship_control_links(friendship)
    case friendship.friendship_status_id
      when FriendshipStatus[:pending].id
        ("#{(link_to(:accept.l, accept_user_friendship_path(friendship.user, friendship), :method => :put, :class => 'button positive') unless friendship.initiator?)} #{link_to(:deny.l, deny_user_friendship_path(friendship.user, friendship), :method => :put, :class => 'button negative')}").html_safe
      when FriendshipStatus[:accepted].id
        ("#{link_to(:remove_this_friend.l, deny_user_friendship_path(friendship.user, friendship), :method => :put, :class => 'button negative')}").html_safe
      when FriendshipStatus[:denied].id
    		("#{link_to(:accept_this_request.l, accept_user_friendship_path(friendship.user, friendship), :method => :put, :class => 'button positive')}").html_safe
    end
  end

end
