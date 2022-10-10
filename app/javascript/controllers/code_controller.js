import { Controller } from "@hotwired/stimulus"
import hljs from 'highlight.js'

hljs.addPlugin({ "before:highlightElement": ({ el }) => { el.textContent = el.innerText } });
hljs.configure({languages: ['ruby']});

// Connects to data-controller="code"
export default class extends Controller {
  connect() {
    hljs.highlightElement(this.element);
  }
}
