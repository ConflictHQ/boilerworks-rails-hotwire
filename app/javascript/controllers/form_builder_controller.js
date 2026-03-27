import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fieldList", "schemaInput", "emptyState"]

  connect() {
    this.updateSchema()
  }

  addField(event) {
    const type = event.params.fieldType
    const label = event.params.fieldLabel
    const name = this.generateFieldName(label)

    const fieldHtml = this.buildFieldHtml(type, label, name)
    this.fieldListTarget.insertAdjacentHTML("beforeend", fieldHtml)

    if (this.hasEmptyStateTarget) {
      this.emptyStateTarget.remove()
    }

    this.updateSchema()
  }

  removeField(event) {
    const fieldItem = event.target.closest(".field-item")
    if (fieldItem) {
      fieldItem.remove()
      this.updateSchema()
    }
  }

  moveUp(event) {
    const fieldItem = event.target.closest(".field-item")
    if (fieldItem && fieldItem.previousElementSibling) {
      fieldItem.parentNode.insertBefore(fieldItem, fieldItem.previousElementSibling)
      this.updateSchema()
    }
  }

  moveDown(event) {
    const fieldItem = event.target.closest(".field-item")
    if (fieldItem && fieldItem.nextElementSibling) {
      fieldItem.parentNode.insertBefore(fieldItem.nextElementSibling, fieldItem)
      this.updateSchema()
    }
  }

  updateSchema() {
    const fields = []
    const fieldItems = this.fieldListTarget.querySelectorAll(".field-item")

    fieldItems.forEach((item, index) => {
      const type = item.querySelector('[data-field-attr="type"]')?.value || "text"
      const name = item.querySelector('[data-field-attr="name"]')?.value || ""
      const label = item.querySelector('[data-field-attr="label"]')?.value || ""
      const placeholder = item.querySelector('[data-field-attr="placeholder"]')?.value || ""
      const required = item.querySelector('[data-field-attr="required"]')?.checked || false

      item.dataset.index = index

      const field = {
        type: type,
        name: name,
        label: label,
        placeholder: placeholder,
        validations: {}
      }

      if (required) {
        field.validations.required = true
      }

      fields.push(field)
    })

    const schema = JSON.stringify({ fields: fields })

    if (this.hasSchemaInputTarget) {
      this.schemaInputTarget.value = schema
    }
  }

  // Private

  generateFieldName(label) {
    return label
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "_")
      .replace(/^_|_$/g, "")
  }

  buildFieldHtml(type, label, name) {
    return `
      <div class="bg-gray-900 border border-gray-700 rounded-lg p-4 field-item">
        <div class="flex items-center justify-between mb-3">
          <div class="flex items-center gap-2">
            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-700 text-gray-300">${type}</span>
            <span class="text-sm font-medium text-gray-100">${label}</span>
          </div>
          <div class="flex items-center gap-1">
            <button type="button" class="p-1 text-gray-500 hover:text-gray-300" data-action="click->form-builder#moveUp">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"/></svg>
            </button>
            <button type="button" class="p-1 text-gray-500 hover:text-gray-300" data-action="click->form-builder#moveDown">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
            </button>
            <button type="button" class="p-1 text-red-500 hover:text-red-300" data-action="click->form-builder#removeField">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="block text-xs text-gray-500 mb-1">Field Name</label>
            <input type="text" value="${name}" data-field-attr="name" class="block w-full rounded bg-gray-800 border border-gray-600 text-gray-100 text-sm px-3 py-1.5 focus:outline-none focus:ring-1 focus:ring-red-500" data-action="input->form-builder#updateSchema">
          </div>
          <div>
            <label class="block text-xs text-gray-500 mb-1">Label</label>
            <input type="text" value="${label}" data-field-attr="label" class="block w-full rounded bg-gray-800 border border-gray-600 text-gray-100 text-sm px-3 py-1.5 focus:outline-none focus:ring-1 focus:ring-red-500" data-action="input->form-builder#updateSchema">
          </div>
          <div>
            <label class="block text-xs text-gray-500 mb-1">Placeholder</label>
            <input type="text" value="" data-field-attr="placeholder" class="block w-full rounded bg-gray-800 border border-gray-600 text-gray-100 text-sm px-3 py-1.5 focus:outline-none focus:ring-1 focus:ring-red-500" data-action="input->form-builder#updateSchema">
          </div>
          <div class="flex items-end gap-3">
            <label class="flex items-center gap-2 text-sm text-gray-300">
              <input type="checkbox" data-field-attr="required" class="rounded bg-gray-800 border-gray-600 text-red-500 focus:ring-red-500" data-action="change->form-builder#updateSchema">
              Required
            </label>
          </div>
        </div>
        <input type="hidden" data-field-attr="type" value="${type}">
      </div>
    `
  }
}
