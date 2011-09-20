class Group < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  has_many :group_members, :dependent => :destroy
  has_many :members, :through => :group_members

  has_attached_file :logo, :styles => { :medium => "250x250>", :thumb => "50x50>" }, :default_url => 'default_group_original.jpg'
  validates_attachment_content_type :logo, :content_type => configatron.photo.validation_options.content_type

  has_many :posts, :dependent => :destroy

  validates_uniqueness_of :title, :case_sensitive => false
  validates_presence_of :title, :description
  attr_accessible :user_id, :title, :description, :public, :logo

  def self.popular(limit = 0)
    #find(:all, :include => :posts).sort_by {|p| p.posts.size}.reverse.first(limit)
    @popular_pages = find(:all, :include => "group_members").sort_by { |p| p.members.size }.reverse
    if limit > 0
      @popular_pages.first(limit)
    else
      @popular_pages
    end
  end

  def self.search(search)
    if search
      where('title LIKE ? or title LIKE ? or title LIKE ?', "%#{search.downcase.strip}%", "%#{search.upcase.strip}%", "%#{search.strip}%")
    else
      all
    end
  end
end
