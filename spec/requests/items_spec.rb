require "rails_helper"

RSpec.describe "Items" do
  let(:view_perm) { create(:permission, slug: "item.view") }
  let(:add_perm) { create(:permission, slug: "item.add") }
  let(:change_perm) { create(:permission, slug: "item.change") }
  let(:delete_perm) { create(:permission, slug: "item.delete") }
  let(:group) { create(:group, permissions: [view_perm, add_perm, change_perm, delete_perm]) }
  let(:user) { create(:user, groups: [group]) }
  let(:item) { create(:item) }

  before { sign_in(user) }

  describe "GET /items" do
    it "returns success" do
      get items_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /items/:id" do
    it "returns success" do
      get item_path(item)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /items" do
    it "creates a item" do
      expect {
        post items_path, params: { item: { name: "Test", price: 9.99, slug: "test-item" } }
      }.to change(Item, :count).by(1)
    end
  end

  describe "PATCH /items/:id" do
    it "updates the item" do
      patch item_path(item), params: { item: { name: "Updated" } }
      expect(item.reload.name).to eq("Updated")
    end
  end

  describe "DELETE /items/:id" do
    it "soft deletes the item" do
      delete item_path(item)
      expect(Item.count).to eq(0)
      expect(Item.with_deleted.count).to eq(1)
    end
  end

  context "without authentication" do
    before { delete session_path }

    it "redirects to login" do
      get items_path
      expect(response).to redirect_to(new_session_path)
    end
  end

  context "without permissions" do
    let(:unprivileged) { create(:user) }
    before { sign_in(unprivileged) }

    it "denies access to index" do
      get items_path
      expect(response).to redirect_to(root_path)
    end
  end
end
