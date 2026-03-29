require "rails_helper"

RSpec.describe Item do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe "associations" do
    it { is_expected.to belong_to(:category).optional }
  end

  describe "concerns" do
    subject(:item) { create(:item) }

    it "generates a uuid on create" do
      expect(item.uuid).to be_present
    end

    it "uses uuid for to_param" do
      expect(item.to_param).to eq(item.uuid)
    end

    it "supports soft delete" do
      item.soft_delete!
      expect(item.deleted?).to be true
      expect(Item.count).to eq(0)
      expect(Item.with_deleted.count).to eq(1)
    end

    it "supports restore" do
      item.soft_delete!
      item.restore!
      expect(item.deleted?).to be false
      expect(Item.count).to eq(1)
    end
  end
end
