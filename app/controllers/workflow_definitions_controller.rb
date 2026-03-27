class WorkflowDefinitionsController < ApplicationController
  before_action :set_workflow_definition, only: %i[show edit update destroy]

  def index
    authorize WorkflowDefinition
    @workflow_definitions = policy_scope(WorkflowDefinition).order(created_at: :desc)
  end

  def show
    authorize @workflow_definition
  end

  def new
    @workflow_definition = WorkflowDefinition.new
    authorize @workflow_definition
  end

  def create
    @workflow_definition = WorkflowDefinition.new(workflow_definition_params)
    authorize @workflow_definition

    respond_to do |format|
      if @workflow_definition.save
        format.html { redirect_to @workflow_definition, notice: "Workflow definition was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @workflow_definition
  end

  def update
    authorize @workflow_definition

    respond_to do |format|
      if @workflow_definition.update(workflow_definition_params)
        format.html { redirect_to @workflow_definition, notice: "Workflow definition was successfully updated." }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @workflow_definition
    @workflow_definition.soft_delete!

    respond_to do |format|
      format.html { redirect_to workflow_definitions_path, notice: "Workflow definition was successfully deleted." }
      format.turbo_stream
    end
  end

  private

  def set_workflow_definition
    @workflow_definition = WorkflowDefinition.find_by!(uuid: params[:id])
  end

  def workflow_definition_params
    params.require(:workflow_definition).permit(:name, :slug, :description, :target_type).tap do |p|
      p[:states] = JSON.parse(params[:workflow_definition][:states]) if params[:workflow_definition][:states].present?
      p[:transitions] = JSON.parse(params[:workflow_definition][:transitions]) if params[:workflow_definition][:transitions].present?
    end
  end
end
