class FormSubmissionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  before_action :set_form_submission, only: %i[show approve reject]
  before_action :set_form_definition, only: %i[new create]

  def index
    authorize FormSubmission
    scope = policy_scope(FormSubmission).includes(:form_definition).order(created_at: :desc)
    scope = scope.where(form_definition_id: params[:form_definition_id]) if params[:form_definition_id].present?
    @pagy, @form_submissions = pagy(scope)
  end

  def show
    authorize @form_submission
  end

  def new
    @form_submission = @form_definition.form_submissions.new
    authorize @form_submission
  end

  def create
    @form_submission = @form_definition.form_submissions.new(
      data: submission_data,
      submitted_by: Current.user,
      status: "submitted"
    )
    authorize @form_submission

    validator = FormValidationService.new(@form_definition, submission_data)
    @validation_errors = validator.validate

    if @validation_errors.empty? && @form_submission.save
      @form_submission.update!(validated_at: Time.current)
      redirect_to(
        authenticated? ? form_submission_path(@form_submission) : root_path,
        notice: "Form submitted successfully."
      )
    else
      render :new, status: :unprocessable_entity
    end
  end

  def approve
    authorize @form_submission
    @form_submission.approve!
    redirect_to @form_submission, notice: "Submission approved."
  end

  def reject
    authorize @form_submission
    @form_submission.reject!
    redirect_to @form_submission, notice: "Submission rejected."
  end

  private

  def set_form_submission
    @form_submission = FormSubmission.find_by!(uuid: params[:id])
  end

  def set_form_definition
    @form_definition = FormDefinition.published.find_by!(uuid: params[:form_definition_id])
  end

  def submission_data
    params.fetch(:submission, {}).permit!.to_h
  end
end
