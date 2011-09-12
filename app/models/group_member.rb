class GroupMember < ActiveRecord::Base
  include AASM
  belongs_to :group
  belongs_to :member, :class_name => "User", :foreign_key => "member_id"

  aasm_column :aasm_state
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :accepted
  aasm_state :rejected

  aasm_event :accept do
    transitions :from => :pending, :to => :accepted
  end

  aasm_event :reject do
    transitions :to => :rejected, :from => [:accepted, :pending]
  end

  MODERATOR_FLAG = true

  def self.get_record(group, user)
    return self.where(:group_id => group, :member_id => user).first
  end

  def self.actual_member(group, user)
    return self.where(:group_id => group, :member_id => user, :aasm_state => "accepted").first
  end

  def self.find_pending(group, user)
    group_member = self.get_record(group.id, user.id)
    if self.pending_members(group).include?(group_member)
      return true
    else
      return false
    end
  end

  def self.make_moderator
    self.moderator = true
    self.save
  end

  def self.moderator?(group, user)
    group_member = self.get_record(group.id, user.id)
    return group_member.moderator
  end

  def self.moderator(group)
    self.find(:all, :conditions => ['group_id = ? AND moderator = ?', group.id, MODERATOR_FLAG])
  end

  def self.members(group)
    self.find(:all, :conditions => ['group_id = ? AND aasm_state = ?', group.id, "accepted"])
  end

  def self.pending_members(group)
    self.find(:all, :conditions => ['group_id = ? AND aasm_state = ?', group.id, "pending"])
  end

  def group_name
    group.title
  end

end
