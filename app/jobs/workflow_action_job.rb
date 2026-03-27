class WorkflowActionJob < ApplicationJob
  queue_as :default

  def perform(workflow_instance_id, action)
    instance = WorkflowInstance.find(workflow_instance_id)
    action = action.with_indifferent_access

    case action[:type]
    when "notify_user"
      Rails.logger.info "[Workflow] Notify user: #{action[:recipient]} - #{action[:message]}"
    when "send_email"
      Rails.logger.info "[Workflow] Send email to: #{action[:to]} - #{action[:subject]}"
    when "call_webhook"
      Rails.logger.info "[Workflow] Call webhook: #{action[:url]}"
    when "update_field"
      if instance.workflowable.respond_to?("#{action[:field]}=")
        instance.workflowable.update!(action[:field] => action[:value])
      end
    end
  end
end
