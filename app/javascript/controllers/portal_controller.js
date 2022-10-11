import { Controller } from "@hotwired/stimulus"
import hotkeys from 'hotkeys-js'
hotkeys.filter = (e) => {
  return true // allows hotkeys to be active even when inside of editable fields like inputs etc
}

// Connects to data-controller="portal"
export default class extends Controller {
  static targets = ["container", "autofocus"]
  static values = {
    "triggerId": String,
    "openHotkeys": Array,
    "closeHotkeys": Array
  }
  
  connect() {
    this.portalTarget = document.createElement('div')
    document.body.insertAdjacentElement('beforeend', this.portalTarget)
    this.contentTarget = this.containerTarget.children[0]
    this.closeWithBind = this._close.bind(this) // assigned so as to be able to refer to same function in _addEventListenersToCloseButtons and _removeEventListenersFromCloseButtons
    this.openWithBind = this.open.bind(this) // assigned so as to be able to refer to same function in _setupTriggersOutsideScope
    this.hasTriggerIdValue && this._setupTriggersOutsideScope()
    this._setupHotkeyTriggers()
  }

  disconnect() {
    this.portalTarget.remove()
    this.hasTriggerIdValue && this._teardownTriggersOutsideScope()
    this._teardownHotkeyTriggers()
  }

  open(e) {
    e.preventDefault()
    document.body.insertAdjacentElement('beforeend', this.portalTarget)
    this.portalTarget.insertAdjacentElement('beforeend', this.contentTarget)
    this._addEventListenersToCloseButtons()
    this._focusAutofocusTargets()
  }
  
  _close(e) {
    e.preventDefault()
    this.containerTarget.insertAdjacentElement('beforeend', this.contentTarget)
    this._removeEventListenersFromCloseButtons()
  }

  _addEventListenersToCloseButtons() {
    const closeButtons = this.contentTarget.querySelectorAll('[data-action="click->portal#close"]')
    closeButtons.forEach((btn) => {
      btn.addEventListener('click', this.closeWithBind)
    })
  }

  _removeEventListenersFromCloseButtons() {
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

  _focusAutofocusTargets() {
    const autofocusTarget = this.contentTarget.querySelector('[data-portal-target="autofocus"]')
    autofocusTarget && autofocusTarget.focus()
  }

  _setupHotkeyTriggers() {
    this.openHotkeysValue.forEach((hotkey) => {
      hotkeys(hotkey, this.openWithBind)
    })
    this.closeHotkeysValue.forEach((hotkey) => {
      hotkeys(hotkey, this.closeWithBind)
    })
  }

  _teardownHotkeyTriggers() {
    this.openHotkeysValue.forEach((hotkey) => {
      hotkeys.unbind(hotkey)
    })
    this.closeHotkeysValue.forEach((hotkey) => {
      hotkeys.unbind(hotkey)
    })
  }
}
