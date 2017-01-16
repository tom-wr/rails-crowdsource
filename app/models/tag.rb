class Tag < ActiveRecord::Base
  has_many :categorys, class_name: "Tag", foreign_key: "parent"
  belongs_to :parent, class_name: "Tag"
end
