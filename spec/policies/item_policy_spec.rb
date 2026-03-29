require "rails_helper"

RSpec.describe ItemPolicy do
  let(:item) { create(:item) }

  context "with item.view permission" do
    let(:permission) { create(:permission, slug: "item.view") }
    let(:group) { create(:group, permissions: [permission]) }
    let(:user) { create(:user, groups: [group]) }
    subject { described_class.new(user, item) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "with all item permissions" do
    let(:view) { create(:permission, slug: "item.view") }
    let(:add) { create(:permission, slug: "item.add") }
    let(:change) { create(:permission, slug: "item.change") }
    let(:delete) { create(:permission, slug: "item.delete") }
    let(:group) { create(:group, permissions: [view, add, change, delete]) }
    let(:user) { create(:user, groups: [group]) }
    subject { described_class.new(user, item) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context "without permissions" do
    let(:user) { create(:user) }
    subject { described_class.new(user, item) }

    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
