require "rails_helper"

RSpec.describe User do
  describe "associations" do
    it { is_expected.to have_and_belong_to_many(:groups) }
    it { is_expected.to have_many(:permissions).through(:groups) }
  end

  describe "#has_permission?" do
    let(:permission) { create(:permission, slug: "product.view") }
    let(:group) { create(:group, name: "viewer") }
    let(:user) { create(:user) }

    before do
      group.permissions << permission
      user.groups << group
    end

    it "returns true for granted permissions" do
      expect(user.has_permission?("product.view")).to be true
    end

    it "returns false for ungranted permissions" do
      expect(user.has_permission?("product.delete")).to be false
    end
  end

  describe "#admin?" do
    it "returns true for admin users" do
      user = create(:user, :admin)
      expect(user.admin?).to be true
    end

    it "returns false for regular users" do
      regular = create(:user)
      expect(regular.admin?).to be false
    end
  end
end
