import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="portal"
export default class extends Controller {
  static targets = ["container"]
  
  connect() {
    this.portalTarget = document.createElement('div')
    document.body.insertAdjacentElement('beforeend', this.portalTarget)
    this.contentTarget = this.containerTarget.children[0]
    this.closeWithBind = this._close.bind(this) // assigned so as to be able to refer to same function in _addEventListenersToCloseButtons and _removeEventListenersToCloseButtons
  }

  disonnect() {
    this._close()
    this.portalTarget.remove()
  }

  open(event) {
    this.portalTarget.insertAdjacentElement('beforeend', this.contentTarget)
    this._addEventListenersToCloseButtons()
  }

  close(event) {
    // See _close method below
  }
  
  _close() {
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
}
