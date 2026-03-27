class FormSubmissionPolicy < ApplicationPolicy
  def index? = has?("form.view") || admin?
  def show? = has?("form.view") || admin?
  def create? = true
  def new? = true
  def update? = has?("form.change") || admin?
  def approve? = has?("form.change") || admin?
  def reject? = has?("form.change") || admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("form.view") || user&.admin? ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
