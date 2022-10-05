# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-dropdown", to: "https://ga.jspm.io/npm:stimulus-dropdown@2.0.0/dist/stimulus-dropdown.es.js"
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.1.0/dist/stimulus.js"
pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.10.0/dist/hotkeys.esm.js"
pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.50.0/dist/index.js"
pin "stimulus-character-counter", to: "https://ga.jspm.io/npm:stimulus-character-counter@4.1.0/dist/stimulus-character-counter.es.js"
