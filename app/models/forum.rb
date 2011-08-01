class Forum < ActiveRecord::Base
  acts_as_taggable
  acts_as_list

  validates_presence_of :name

  has_many :moderatorships, :dependent => :destroy
  has_many :moderators, :through => :moderatorships, :source => :user

  has_many :topics, :dependent => :destroy

  has_many :sb_posts
  has_many :recent_topics, :class_name => 'Topic', :order => 'replied_at desc'

  belongs_to :owner, :polymorphic => true

  format_attribute :description
  
  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end

  
end
