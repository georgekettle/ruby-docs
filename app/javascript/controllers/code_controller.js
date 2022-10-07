import { Controller } from "@hotwired/stimulus"
import hljs from 'highlight.js';

// Connects to data-controller="code"
export default class extends Controller {
  connect() {
    hljs.highlightElement(this.element);
  }
}
