class Medium < ActiveRecord::Base
  belongs_to :dataset

  mount_uploader :image, ImageUploader
end
