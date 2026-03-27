class FormDefinitionPolicy < ApplicationPolicy
  def index? = has?("form.view") || admin?
  def show? = has?("form.view") || admin?
  def create? = has?("form.add") || admin?
  def new? = create?
  def update? = (has?("form.change") || admin?) && !record.archived?
  def edit? = update?
  def destroy? = has?("form.delete") || admin?
  def publish? = create? && record.draft?
  def archive? = create? && record.published?

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("form.view") || user&.admin? ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
