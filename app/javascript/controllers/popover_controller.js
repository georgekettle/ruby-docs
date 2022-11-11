import { Controller } from "@hotwired/stimulus"
import tippy from 'tippy.js'

// Connects to data-controller="popover"
export default class extends Controller {
  static targets = ["content"]
  
  connect() {
    this.tippy = tippy(this.element, {
      content: this.contentTarget.innerHTML,
      allowHTML: true,
      animation: "scale",
      interactive: true,
    });
  }
}
