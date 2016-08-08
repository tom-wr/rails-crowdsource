class Project < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 3}
  has_many :taskflows, dependent: :destroy
  has_many :datasets, dependent: :destroy
end
