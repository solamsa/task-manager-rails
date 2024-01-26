require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it "has a valid factory" do
    expect(user).to be_valid 
  end

  context 'Should not be valid' do
    it 'when email is not present' do
      user.email = nil
      expect(user).not_to be_valid
    end
  end
end