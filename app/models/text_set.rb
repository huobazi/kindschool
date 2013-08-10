class TextSet < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :content
  has_one :personal_set, :class_name => "PersonalSet", :as => :resource, :dependent => :destroy
end
