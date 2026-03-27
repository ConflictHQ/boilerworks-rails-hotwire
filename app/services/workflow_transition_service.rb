class WorkflowTransitionService
  class TransitionError < StandardError; end

  def initialize(workflow_instance, to_state, user: nil, data: {})
    @instance = workflow_instance
    @to_state = to_state
    @user = user
    @data = data
    @definition = workflow_instance.workflow_definition
  end

  def execute!
    transition = @definition.find_transition(@instance.current_state, @to_state)
    raise TransitionError, "No transition from '#{@instance.current_state}' to '#{@to_state}'" unless transition

    evaluate_conditions!(transition)

    ActiveRecord::Base.transaction do
      from_state = @instance.current_state
      @instance.update!(current_state: @to_state)
      @instance.transition_logs.create!(
        from_state: from_state,
        to_state: @to_state,
        transitioned_by: @user,
        data: @data
      )
    end

    enqueue_actions(transition)
    @instance
  end

  private

  def evaluate_conditions!(transition)
    conditions = transition["conditions"] || []
    conditions.each do |condition|
      unless evaluate_condition(condition)
        raise TransitionError, "Condition '#{condition['type']}' not met"
      end
    end
  end

  def evaluate_condition(condition)
    case condition["type"]
    when "is_authenticated"
      @user.present?
    when "is_superuser"
      @user&.admin?
    when "user_has_role"
      @user&.groups&.exists?(name: condition["value"])
    when "field_equals"
      @instance.metadata[condition["field"]] == condition["value"]
    when "field_in"
      Array(condition["values"]).include?(@instance.metadata[condition["field"]])
    else
      true
    end
  end

  def enqueue_actions(transition)
    actions = transition["actions"] || []
    actions.each do |action|
      WorkflowActionJob.perform_later(@instance.id, action)
    end
  end
end
