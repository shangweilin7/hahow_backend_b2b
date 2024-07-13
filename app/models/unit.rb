class Unit < ApplicationRecord
  belongs_to :chapter

  validates :name, presence: true
  validates :content, presence: true
  validates :position, presence: true
end
