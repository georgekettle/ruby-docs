import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setDarkMode()
  }

  toggle() {
    localStorage.theme = (localStorage.theme === 'light') ? 'dark' : 'light'
    this.setDarkMode()
  }

  setDarkMode() {
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }
}