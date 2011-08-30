class ShortMessage < ActiveRecord::Base
  acts_as_commentable
  belongs_to :user
  validates_presence_of :message
end
