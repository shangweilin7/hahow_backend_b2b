class Course < ApplicationRecord
  has_many :chapters, dependent: :destroy

  accepts_nested_attributes_for :chapters, allow_destroy: true

  validates :name, presence: true
  validates :lecturer, presence: true
  # Don't use general validate
  # because nested_attributes only data that already exists in the database will be compared
  validate :unique_chapter_names
  validate :unique_chapter_positions

  private

  def unique_chapter_names
    chapter_names = chapters_without_marked_for_destruction.map(&:name)
    return if chapter_names.size == chapter_names.uniq.size

    errors.add :unique_chapter_names, 'Has same chapter names'
  end

  def unique_chapter_positions
    chapter_positions = chapters_without_marked_for_destruction.map(&:position)
    return if chapter_positions.size == chapter_positions.uniq.size

    errors.add :unique_chapter_positions, 'Has same chapter positions'
  end

  def chapters_without_marked_for_destruction
    @chapters_without_marked_for_destruction ||= chapters.reject(&:marked_for_destruction?)
  end
end
