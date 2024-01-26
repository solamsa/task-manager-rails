require "rails_helper"


RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_least(10) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end