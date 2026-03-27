class WorkflowInstancePolicy < ApplicationPolicy
  def index? = has?("workflow.view") || admin?
  def show? = has?("workflow.view") || admin?
  def create? = has?("workflow.add") || admin?
  def new? = create?
  def transition? = has?("workflow.change") || admin?

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("workflow.view") || user&.admin? ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
