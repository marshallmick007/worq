class Category < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  belongs_to :user
end
