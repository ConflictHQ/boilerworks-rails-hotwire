require "rails_helper"

RSpec.describe Product do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe "associations" do
    it { is_expected.to belong_to(:category).optional }
  end

  describe "concerns" do
    subject(:product) { create(:product) }

    it "generates a uuid on create" do
      expect(product.uuid).to be_present
    end

    it "uses uuid for to_param" do
      expect(product.to_param).to eq(product.uuid)
    end

    it "supports soft delete" do
      product.soft_delete!
      expect(product.deleted?).to be true
      expect(Product.count).to eq(0)
      expect(Product.with_deleted.count).to eq(1)
    end

    it "supports restore" do
      product.soft_delete!
      product.restore!
      expect(product.deleted?).to be false
      expect(Product.count).to eq(1)
    end
  end
end
