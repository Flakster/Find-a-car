class User < ApplicationRecord
  # model association
  has_many :favorites, dependent: :destroy

  # validations
  validates_presence_of :name
end
