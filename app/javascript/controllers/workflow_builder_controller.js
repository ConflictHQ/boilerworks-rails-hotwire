import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stateList", "transitionList", "statesInput", "transitionsInput"]

  connect() {
    this.updateJson()
  }

  addState() {
    const index = this.stateListTarget.querySelectorAll(".state-row").length
    const row = document.createElement("div")
    row.className = "flex items-center gap-3 state-row"
    row.dataset.index = index
    row.innerHTML = `
      <input type="text" value="" placeholder="State name" data-field="name"
        class="flex-1 rounded-lg bg-gray-700 border border-gray-600 text-gray-100 placeholder-gray-400 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent"
        data-action="input->workflow-builder#updateJson">
      <label class="flex items-center gap-1.5 text-xs text-gray-400">
        <input type="checkbox" data-field="initial"
          class="rounded bg-gray-700 border-gray-600 text-red-500 focus:ring-red-500"
          data-action="change->workflow-builder#updateJson">
        Initial
      </label>
      <button type="button" data-action="workflow-builder#removeState"
        class="text-red-400 hover:text-red-300 text-sm">Remove</button>
    `
    this.stateListTarget.appendChild(row)
    this.updateJson()
  }

  removeState(event) {
    const row = event.target.closest(".state-row")
    if (row) {
      row.remove()
      this.updateJson()
    }
  }

  addTransition() {
    const index = this.transitionListTarget.querySelectorAll(".transition-row").length
    const row = document.createElement("div")
    row.className = "flex items-center gap-3 transition-row"
    row.dataset.index = index
    row.innerHTML = `
      <input type="text" value="" placeholder="From state" data-field="from"
        class="flex-1 rounded-lg bg-gray-700 border border-gray-600 text-gray-100 placeholder-gray-400 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent"
        data-action="input->workflow-builder#updateJson">
      <svg class="w-4 h-4 text-gray-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"/>
      </svg>
      <input type="text" value="" placeholder="To state" data-field="to"
        class="flex-1 rounded-lg bg-gray-700 border border-gray-600 text-gray-100 placeholder-gray-400 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent"
        data-action="input->workflow-builder#updateJson">
      <button type="button" data-action="workflow-builder#removeTransition"
        class="text-red-400 hover:text-red-300 text-sm">Remove</button>
    `
    this.transitionListTarget.appendChild(row)
    this.updateJson()
  }

  removeTransition(event) {
    const row = event.target.closest(".transition-row")
    if (row) {
      row.remove()
      this.updateJson()
    }
  }

  updateJson() {
    const states = []
    this.stateListTarget.querySelectorAll(".state-row").forEach((row) => {
      const nameInput = row.querySelector('[data-field="name"]')
      const initialInput = row.querySelector('[data-field="initial"]')
      if (nameInput && nameInput.value.trim()) {
        states.push({
          name: nameInput.value.trim(),
          initial: initialInput ? initialInput.checked : false
        })
      }
    })
    this.statesInputTarget.value = JSON.stringify(states)

    const transitions = []
    this.transitionListTarget.querySelectorAll(".transition-row").forEach((row) => {
      const fromInput = row.querySelector('[data-field="from"]')
      const toInput = row.querySelector('[data-field="to"]')
      if (fromInput && toInput && fromInput.value.trim() && toInput.value.trim()) {
        transitions.push({
          from: fromInput.value.trim(),
          to: toInput.value.trim()
        })
      }
    })
    this.transitionsInputTarget.value = JSON.stringify(transitions)
  }
}
