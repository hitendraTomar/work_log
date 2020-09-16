require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "should be valid with valid attributes" do 
    expect(user).to be_valid
  end

  it "should not valid without a email" do 
    user.email = nil
    expect(user).to_not be_valid
  end

  describe 'associations' do
    it 'has many work_logs' do
      should have_many(:work_logs)
    end
  end

  describe 'validations' do
    it "" do
      should validate_presence_of(:name)
    end
  end
end
