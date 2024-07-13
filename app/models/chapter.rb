class Chapter < ApplicationRecord
  belongs_to :course
  has_many :units, dependent: :destroy

  accepts_nested_attributes_for :units, allow_destroy: true

  validates :name, presence: true
  validates :position, presence: true
  # Don't use general validate
  # because nested_attributes only data that already exists in the database will be compared
  validate :unique_unit_names
  validate :unique_unit_positions

  private

  def unique_unit_names
    unit_names = units_without_marked_for_destruction.map(&:name)
    return if unit_names.size == unit_names.uniq.size

    errors.add :unique_unit_names, 'Has same unit names'
  end

  def unique_unit_positions
    unit_positions = units_without_marked_for_destruction.map(&:position)
    return if unit_positions.size == unit_positions.uniq.size

    errors.add :unique_unit_positions, 'Has same unit positions'
  end

  def units_without_marked_for_destruction
    @units_without_marked_for_destruction ||= units.reject(&:marked_for_destruction?)
  end
end
