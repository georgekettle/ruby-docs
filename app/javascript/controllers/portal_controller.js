import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="portal"
export default class extends Controller {
  static targets = ["container"]
  static values = {
    "triggerId": String
  }
  
  connect() {
    this.portalTarget = document.createElement('div')
    document.body.insertAdjacentElement('beforeend', this.portalTarget)
    this.contentTarget = this.containerTarget.children[0]
    this.closeWithBind = this._close.bind(this) // assigned so as to be able to refer to same function in _addEventListenersToCloseButtons and _removeEventListenersToCloseButtons
    this.openWithBind = this.open.bind(this) // assigned so as to be able to refer to same function in _setupTriggersOutsideScope
    this.hasTriggerIdValue && this._setupTriggersOutsideScope()
  }

  disonnect() {
    this._close()
    this.portalTarget.remove()
    this._teardownTriggersOutsideScope()
  }

  open(e) {
    e.preventDefault()
    this.portalTarget.insertAdjacentElement('beforeend', this.contentTarget)
    this._addEventListenersToCloseButtons()
  }

  close(event) {
    // See _close method below
  }
  
  _close(e) {
    e.preventDefault()
    this.containerTarget.insertAdjacentElement('beforeend', this.contentTarget)
    this._removeEventListenersToCloseButtons()
  }

  _addEventListenersToCloseButtons() {
    const closeButtons = this.contentTarget.querySelectorAll('[data-action="click->portal#close"]')
    closeButtons.forEach((btn) => {
      btn.addEventListener('click', this.closeWithBind)
    })
  }

  _removeEventListenersToCloseButtons() {
    const closeButtons = this.contentTarget.querySelectorAll('[data-action="click->portal#close"]')
    closeButtons.forEach((btn) => {
      btn.removeEventListener('click', this.closeWithBind)
    })
  }

  _setupTriggersOutsideScope() {
    this.outsideTriggerTargets = document.querySelectorAll(`#${this.triggerIdValue}`)
    this.outsideTriggerTargets.forEach((trigger) => {
      trigger.addEventListener('click', this.openWithBind)
    })
  }

  _teardownTriggersOutsideScope() {
    this.outsideTriggerTargets.forEach((trigger) => {
      trigger.removeEventListener('click', this.openWithBind)
    })
  }
}
