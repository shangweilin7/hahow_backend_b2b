require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:position) }

    describe '#unique_unit_names' do
      context 'Has the same unit names' do
        it 'Returns false' do
          unit1 = build(:unit, name: :name, position: 0)
          unit2 = build(:unit, name: :name, position: 1)
          chapter = build(:chapter, units: [unit1, unit2])
          expect(chapter).to be_invalid
          expect(chapter.errors[:unique_unit_names]).to eq(['Has same unit names'])
        end
      end

      context 'Has the not same unit names' do
        it 'Returns true' do
          unit1 = build(:unit, name: :name1, position: 0)
          unit2 = build(:unit, name: :name2, position: 1)
          chapter = build(:chapter, units: [unit1, unit2])
          expect(chapter).to be_valid
        end
      end
    end

    describe '#unique_unit_positions' do
      context 'Has the same unit positions' do
        it 'Returns false' do
          unit1 = build(:unit, name: :name1, position: 0)
          unit2 = build(:unit, name: :name2, position: 0)
          chapter = build(:chapter, units: [unit1, unit2])
          expect(chapter).to be_invalid
          expect(chapter.errors[:unique_unit_positions]).to eq(['Has same unit positions'])
        end
      end

      context 'Has the not same chapter positions' do
        it 'Returns false' do
          unit1 = build(:unit, name: :name1, position: 0)
          unit2 = build(:unit, name: :name2, position: 1)
          chapter = build(:chapter, units: [unit1, unit2])
          expect(chapter).to be_valid
        end
      end
    end
  end
end
