require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:lecturer) }

    describe '#unique_chapter_names' do
      context 'Has same chapter names' do
        it 'Returns false' do
          chapter1 = build(:chapter, name: :name, position: 0)
          chapter2 = build(:chapter, name: :name, position: 1)
          course = build(:course, chapters: [chapter1, chapter2])
          expect(course).to be_invalid
          expect(course.errors[:unique_chapter_names]).to eq(['Has same chapter names'])
        end
      end

      context 'Has not same chapter names' do
        it 'Returns true' do
          chapter1 = build(:chapter, name: :name1, position: 0)
          chapter2 = build(:chapter, name: :name2, position: 1)
          course = build(:course, chapters: [chapter1, chapter2])
          expect(course).to be_valid
        end
      end
    end

    describe '#unique_chapter_positions' do
      context 'Has same chapter positions' do
        it 'Returns false' do
          chapter1 = build(:chapter, name: :name1, position: 0)
          chapter2 = build(:chapter, name: :name2, position: 0)
          course = build(:course, chapters: [chapter1, chapter2])
          expect(course).to be_invalid
          expect(course.errors[:unique_chapter_positions]).to eq(['Has same chapter positions'])
        end
      end

      context 'Has not same chapter positions' do
        it 'Returns false' do
          chapter1 = build(:chapter, name: :name1, position: 0)
          chapter2 = build(:chapter, name: :name2, position: 1)
          course = build(:course, chapters: [chapter1, chapter2])
          expect(course).to be_valid
        end
      end
    end
  end
end
