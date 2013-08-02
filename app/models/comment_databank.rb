#encoding:utf-8
#点评资料库
class CommentDatabank < ActiveRecord::Base
  attr_accessible :content, :category_id,:visible,:user_id
  validates :category_id,:content, :presence => true,:uniqueness=>true    #必须输入/不为空

  belongs_to :category,:conditions=>"tp=1"
  belongs_to :user
  
end
