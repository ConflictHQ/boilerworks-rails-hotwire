class WorkflowDefinitionPolicy < ApplicationPolicy
  def index? = has?("workflow.view") || admin?
  def show? = has?("workflow.view") || admin?
  def create? = has?("workflow.add") || admin?
  def new? = create?
  def update? = has?("workflow.change") || admin?
  def edit? = update?
  def destroy? = has?("workflow.delete") || admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("workflow.view") || user&.admin? ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
