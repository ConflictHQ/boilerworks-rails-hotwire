require "rails_helper"

RSpec.describe ProductPolicy do
  let(:product) { create(:product) }

  context "with product.view permission" do
    let(:permission) { create(:permission, slug: "product.view") }
    let(:group) { create(:group, permissions: [permission]) }
    let(:user) { create(:user, groups: [group]) }
    subject { described_class.new(user, product) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "with all product permissions" do
    let(:view) { create(:permission, slug: "product.view") }
    let(:add) { create(:permission, slug: "product.add") }
    let(:change) { create(:permission, slug: "product.change") }
    let(:delete) { create(:permission, slug: "product.delete") }
    let(:group) { create(:group, permissions: [view, add, change, delete]) }
    let(:user) { create(:user, groups: [group]) }
    subject { described_class.new(user, product) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context "without permissions" do
    let(:user) { create(:user) }
    subject { described_class.new(user, product) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
