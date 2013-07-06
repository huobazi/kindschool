class CareerStrategy < ActiveRecord::Base
  attr_accessible :add_squad, :from_id, :graduation, :kindergarten_id, :to_id

  belongs_to :kindergarten
end
