require "rails_helper"

RSpec.describe Category do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:parent).class_name("Category").optional }
    it { is_expected.to have_many(:children).class_name("Category") }
    it { is_expected.to have_many(:products) }
  end

  describe "tree" do
    let!(:parent) { create(:category, name: "Parent", slug: "parent") }
    let!(:child) { create(:category, name: "Child", slug: "child", parent: parent) }

    it "establishes parent-child relationship" do
      expect(parent.children).to include(child)
      expect(child.parent).to eq(parent)
    end
  end
end
