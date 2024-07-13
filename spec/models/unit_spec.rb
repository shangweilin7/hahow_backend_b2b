require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:position) }
  end
end
