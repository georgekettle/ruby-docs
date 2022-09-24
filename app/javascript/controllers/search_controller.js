import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["hits", "input"]
  static values = {
    loadingHtml: { 
      type: String,
      default: `<div class="flex justify-center items-center p-8">
                  <span class="flex h-3 w-3 relative">
                    <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary-400 opacity-75"></span>
                    <span class="relative inline-flex rounded-full h-3 w-3 bg-primary-500"></span>
                  </span>
                  <span class="ml-2 text-sm text-slate-400">Searching docs...</span>
                </div>`
    },
    query: { type: String, default: "" }
  }

  submit(e) {
    const newQuery = this.inputTarget.value
    if (newQuery != this.queryValue) {
      this.queryValue = newQuery
      this._displayLoading()
      this.inputTarget.form.requestSubmit()
    }
  }

  _displayLoading() {
    this.hitsTarget.innerHTML = this.loadingHtmlValue
  }
}
