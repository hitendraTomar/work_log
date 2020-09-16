require 'rails_helper'

RSpec.describe WorkLog, type: :model do

  let!(:work_log) { create(:work_log) }

  let!(:user_1)    { create(:user) }
  let!(:user_2)    { create(:user) }

  let!(:work_log1) { create(:work_log, user_id: user_1.id) }
  let!(:work_log2) { create(:work_log, user_id: user_2.id, created_at: Date.today.yesterday) }

  describe 'associations' do
    it 'should belongs to user' do
      should belong_to(:user)
    end
  end

  describe 'scopes' do

    describe 'default scope' do
      it 'get all the work logs in created_at desc' do
        
        expect(WorkLog.all).to include(work_log1)
        expect(WorkLog.all).to include(work_log2)
      end
    end

    describe 'work_log_for_today scope' do
      it 'today worklogs' do
        
        expect(WorkLog.work_log_for_today).to include(work_log1)
      end
    end

    describe 'work_log_for_yesterday scope' do
      it 'yesterday worklogs' do   
        
        expect(WorkLog.work_log_for_yesterday).to eq([work_log2])
      end
    end
    
  end

  describe "validations" do
    it "is valid with valid attributes"do
      expect(work_log).to be_valid
    end

    it "is not valid without a user" do
      work_log.user = nil
      expect(work_log).to_not be_valid
    end
    it "is not valid without a worklog" do
      work_log.worklog = nil
      expect(work_log).to_not be_valid
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    
    it 'return false when unauthorised user' do

      expect(work_log.can_perform_action?(user.id)).to eq(false)
    end

    it 'return false when last days records' do
      
      expect(work_log.can_perform_action?(work_log2.user.id)).to eq(false)
    end

    it 'return false when created today with same user yesterday date' do
      work_log2.update_columns(user_id: user.id)
      expect(work_log2.can_perform_action?(work_log2.user_id)).to eq(false)
    end
  end

  describe 'class methods apply_filters' do 

    it 'return all when no search' do
      
      search = {}
      expect(WorkLog.apply_filters(search).count).to eq(WorkLog.all.count)
    end

    it 'search with user_id' do
      
      search = {user_id: user_1.id}

      expect(WorkLog.apply_filters(search).count).to eq(WorkLog.where(id: user_1.id).count)
    end

    it 'search with user id and from date' do
    
      search = {user_id: user_2.id, from_date: Date.today.yesterday}
      expect(WorkLog.apply_filters(search).count).to eq(WorkLog.where(id: work_log2.id).count)
    end

    it 'search with user_id, date range and content ' do

      work_log1.update_columns(worklog: "lorem content")
      search = {user_id: user_1.id, from_date: Date.today, to_date: Date.today, worklog: 'lorem'}

      expect(WorkLog.apply_filters(search).count).to eq(WorkLog.where(id: work_log1.id).count)
    end
  end

end
