require 'rails_helper'

RSpec.describe "WorkLogs", type: :request do

  let(:user) { create(:user) }
  
  let(:valid_attributes) {
      {
        :user_id => user.id,
        :worklog => Faker::Lorem.sentence,
      }
    }

  let(:invalid_attributes) {
    {
      :worklog => nil
    }
  }
  describe "GET /index" do

    context "unauthorised" do 
      
      it "returns http success redirection to sign_in page" do
        get "/work_logs"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authenticated user" do 
      it "returns http success when no filters" do
        sign_in user
        get "/work_logs"
        expect(response).to have_http_status(:success)
        assigns(:work_logs).should eq([])
      end
    end
  end

  describe "GET /new" do
    context "unauthorised" do 
      it "returns http success redirection to sign_in page" do
        get "/work_logs/new"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authorised" do 
      it "returns http success" do
        sign_in user
        get "/work_logs/new"
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /work_logs" do
    context "unauthorised" do 
      it "returns http success redirection to sign_in page" do
        post "/work_logs", params: {}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authorised" do 
      it "returns http success redirection for valid_attributes" do
        sign_in user
        post "/work_logs", params: {work_log: valid_attributes}
        expect(response).to redirect_to(new_work_log_path)
      end

      it "success render for invalid_attributes" do
        sign_in user
        post "/work_logs", params: {work_log: invalid_attributes}
        expect(response).to render_template('new')
      end
    end
  end

  describe "GET /work_logs/:id/edit" do
    context "unauthorised" do 
      it "returns http success redirection to sign_in page" do
        work_log = FactoryBot.create(:work_log, user: user)
        get "/work_logs/#{work_log.to_param}/edit"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authorised" do 
      it "returns http success" do
        sign_in user
        work_log = FactoryBot.create(:work_log, user: user)
        get "/work_logs/#{work_log.id}/edit"
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PUT /work_logs/:id" do
    context "un authenticated user" do 
      it "returns http success redirection to sign_in page" do
        work_log = FactoryBot.create(:work_log, user: user)
        put "/work_logs/#{work_log.to_param}", params: {work_log: valid_attributes}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authenticated user" do 
      it "http success redirection for valid_attributes" do
        sign_in user
        work_log = FactoryBot.create(:work_log, user: user)
        put "/work_logs/#{work_log.to_param}", params: {work_log: valid_attributes}
        expect(response).to redirect_to(new_work_log_path)
      end

      it "success render for invalid_attributes" do
        sign_in user
        work_log = FactoryBot.create(:work_log, user: user)
        put "/work_logs/#{work_log.to_param}", params: {work_log: invalid_attributes}
        expect(response).to render_template('edit')
      end
    end
  end

  describe "DELETE /work_logs/:id" do
    context "un authenticated user" do 
      it "returns http success redirection to sign_in page" do
        work_log = FactoryBot.create(:work_log, user: user)
        delete "/work_logs/#{work_log.to_param}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authenticated user" do 
      it "raise exception when unauthorised delete" do
        sign_in user
        work_log = FactoryBot.create(:work_log, user: user)
        work_log_1 = FactoryBot.create(:work_log)
        
        delete "/work_logs/#{work_log_1.to_param}"
        expect(response).to redirect_to(root_path)
      end

      it "returns http success redirection for valid_attributes" do
        sign_in user
        work_log = FactoryBot.create(:work_log, user: user)
        delete "/work_logs/#{work_log.to_param}"
        expect(response).to redirect_to(new_work_log_path)
      end
    end
  end

end
