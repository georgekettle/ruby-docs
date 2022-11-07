// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"

// Imported stimulus controllers
import Dropdown from 'stimulus-dropdown'
application.register('dropdown', Dropdown)

import CharacterCounter from 'stimulus-character-counter'
application.register('character-counter', CharacterCounter)

import TextareaAutogrow from 'stimulus-textarea-autogrow'
application.register('textarea-autogrow', TextareaAutogrow)

import "trix"
import "@rails/actiontext"
import "./custom/trix_extensions"
