require "rails_helper"

RSpec.describe "Dashboard" do
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when authenticated" do
      before { sign_in(user) }

      it "returns success" do
        get dashboard_path
        expect(response).to have_http_status(:success)
      end

      it "shows the dashboard" do
        get dashboard_path
        expect(response.body).to include("Dashboard")
      end
    end

    context "when not authenticated" do
      it "redirects to login" do
        get dashboard_path
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
