class WorkflowInstancesController < ApplicationController
  before_action :set_workflow_instance, only: %i[show transition]

  rescue_from WorkflowTransitionService::TransitionError, with: :handle_transition_error

  def index
    authorize WorkflowInstance
    @workflow_instances = policy_scope(WorkflowInstance).includes(:workflow_definition).order(created_at: :desc)
  end

  def show
    authorize @workflow_instance
  end

  def new
    @workflow_instance = WorkflowInstance.new
    authorize @workflow_instance
    @workflow_definitions = WorkflowDefinition.order(:name)
  end

  def create
    definition = WorkflowDefinition.find(params[:workflow_instance][:workflow_definition_id])
    @workflow_instance = WorkflowInstance.new(
      workflow_definition: definition,
      current_state: definition.initial_state,
      metadata: {}
    )
    authorize @workflow_instance

    if @workflow_instance.save
      redirect_to @workflow_instance, notice: "Workflow instance was successfully created."
    else
      @workflow_definitions = WorkflowDefinition.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def transition
    authorize @workflow_instance

    service = WorkflowTransitionService.new(
      @workflow_instance,
      params[:to_state],
      user: Current.user,
      data: params[:data]&.to_unsafe_h || {}
    )
    service.execute!

    respond_to do |format|
      format.html { redirect_to @workflow_instance, notice: "Transitioned to '#{params[:to_state]}'." }
      format.turbo_stream
    end
  end

  private

  def set_workflow_instance
    @workflow_instance = WorkflowInstance.find_by!(uuid: params[:id])
  end

  def handle_transition_error(exception)
    flash[:alert] = exception.message

    respond_to do |format|
      format.html { redirect_to @workflow_instance }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
      end
    end
  end
end
