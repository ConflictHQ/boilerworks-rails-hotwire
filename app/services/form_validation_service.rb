class FormValidationService
  def initialize(form_definition, data)
    @form_definition = form_definition
    @data = data.with_indifferent_access
    @errors = {}
  end

  def validate
    @form_definition.field_definitions.each do |field|
      validate_field(field)
    end
    @errors
  end

  def valid?
    validate.empty?
  end

  private

  def validate_field(field)
    name = field["name"]
    value = @data[name]
    validations = field["validations"] || {}

    if validations["required"] && value.blank?
      add_error(name, "is required")
      return
    end

    return if value.blank?

    case field["type"]
    when "email"
      add_error(name, "is not a valid email") unless value.match?(URI::MailTo::EMAIL_REGEXP)
    when "url"
      add_error(name, "is not a valid URL") unless value.match?(%r{\Ahttps?://}i)
    when "number", "rating", "slider"
      num = value.to_f
      add_error(name, "must be at least #{validations['min']}") if validations["min"] && num < validations["min"].to_f
      add_error(name, "must be at most #{validations['max']}") if validations["max"] && num > validations["max"].to_f
    when "text", "textarea", "rich_text"
      add_error(name, "is too short (min #{validations['min_length']})") if validations["min_length"] && value.length < validations["min_length"].to_i
      add_error(name, "is too long (max #{validations['max_length']})") if validations["max_length"] && value.length > validations["max_length"].to_i
      add_error(name, "does not match required format") if validations["pattern"] && !value.match?(Regexp.new(validations["pattern"]))
    when "select", "radio"
      options = (field["options"] || []).map { |o| o["value"] }
      add_error(name, "is not a valid option") unless options.include?(value)
    when "multi_select"
      options = (field["options"] || []).map { |o| o["value"] }
      values = Array(value)
      invalid = values - options
      add_error(name, "contains invalid options: #{invalid.join(', ')}") if invalid.any?
      add_error(name, "requires at least #{validations['min']} selections") if validations["min"] && values.length < validations["min"].to_i
      add_error(name, "allows at most #{validations['max']} selections") if validations["max"] && values.length > validations["max"].to_i
    end
  end

  def add_error(field, message)
    @errors[field] ||= []
    @errors[field] << message
  end
end
