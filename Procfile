web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -C config/sidekiq.yml
js: yarn build --watch
tailwind: yarn build:tailwind --watch
css: yarn build:css --watch

release: rake db:migrate