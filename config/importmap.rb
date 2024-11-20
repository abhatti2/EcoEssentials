# Pin npm packages by running ./bin/importmap

pin "application"

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "controllers", to: "controllers/index.js"
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
