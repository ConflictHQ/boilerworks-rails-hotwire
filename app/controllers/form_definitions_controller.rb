class FormDefinitionsController < ApplicationController
  before_action :set_form_definition, only: %i[show edit update destroy publish archive]

  def index
    authorize FormDefinition
    @pagy, @form_definitions = pagy(policy_scope(FormDefinition).order(created_at: :desc))
  end

  def show
    authorize @form_definition
  end

  def new
    @form_definition = FormDefinition.new
    authorize @form_definition
  end

  def create
    @form_definition = FormDefinition.new(form_definition_params)
    authorize @form_definition

    respond_to do |format|
      if @form_definition.save
        format.html { redirect_to @form_definition, notice: "Form definition was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @form_definition
  end

  def update
    authorize @form_definition

    respond_to do |format|
      if @form_definition.update(form_definition_params)
        format.html { redirect_to @form_definition, notice: "Form definition was successfully updated." }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @form_definition
    @form_definition.soft_delete!

    respond_to do |format|
      format.html { redirect_to form_definitions_path, notice: "Form definition was successfully deleted." }
      format.turbo_stream
    end
  end

  def publish
    authorize @form_definition
    @form_definition.publish!
    redirect_to @form_definition, notice: "Form was published successfully."
  end

  def archive
    authorize @form_definition
    @form_definition.archive!
    redirect_to @form_definition, notice: "Form was archived successfully."
  end

  private

  def set_form_definition
    @form_definition = FormDefinition.find_by!(uuid: params[:id])
  end

  def form_definition_params
    params.require(:form_definition).permit(:name, :slug, :description, :status).tap do |p|
      p[:schema] = JSON.parse(params[:form_definition][:schema]) if params[:form_definition][:schema].present?
      p[:field_config] = JSON.parse(params[:form_definition][:field_config]) if params[:form_definition][:field_config].present?
      p[:logic_rules] = JSON.parse(params[:form_definition][:logic_rules]) if params[:form_definition][:logic_rules].present?
    rescue JSON::ParserError
      # Leave as-is if JSON is invalid; model validation will catch issues
    end
  end
end
