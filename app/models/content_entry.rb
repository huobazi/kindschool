class ContentEntry < ActiveRecord::Base
  attr_accessible :content, :number, :page_content_id, :resource_id, :resource_type, :title

  belongs_to :page_content

  has_one :page_img, :class_name => "PageImg", :as => :resource, :dependent => :destroy

  attr_accessible :page_img_attributes
  accepts_nested_attributes_for :page_img
end
