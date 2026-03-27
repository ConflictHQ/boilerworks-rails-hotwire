require "rails_helper"

RSpec.describe "Products" do
  let(:view_perm) { create(:permission, slug: "product.view") }
  let(:add_perm) { create(:permission, slug: "product.add") }
  let(:change_perm) { create(:permission, slug: "product.change") }
  let(:delete_perm) { create(:permission, slug: "product.delete") }
  let(:group) { create(:group, permissions: [view_perm, add_perm, change_perm, delete_perm]) }
  let(:user) { create(:user, groups: [group]) }
  let(:product) { create(:product) }

  before { sign_in(user) }

  describe "GET /products" do
    it "returns success" do
      get products_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /products/:id" do
    it "returns success" do
      get product_path(product)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /products" do
    it "creates a product" do
      expect {
        post products_path, params: { product: { name: "Test", price: 9.99, slug: "test-product" } }
      }.to change(Product, :count).by(1)
    end
  end

  describe "PATCH /products/:id" do
    it "updates the product" do
      patch product_path(product), params: { product: { name: "Updated" } }
      expect(product.reload.name).to eq("Updated")
    end
  end

  describe "DELETE /products/:id" do
    it "soft deletes the product" do
      delete product_path(product)
      expect(Product.count).to eq(0)
      expect(Product.with_deleted.count).to eq(1)
    end
  end

  context "without authentication" do
    before { delete session_path }

    it "redirects to login" do
      get products_path
      expect(response).to redirect_to(new_session_path)
    end
  end

  context "without permissions" do
    let(:unprivileged) { create(:user) }
    before { sign_in(unprivileged) }

    it "denies access to index" do
      get products_path
      expect(response).to redirect_to(root_path)
    end
  end
end
