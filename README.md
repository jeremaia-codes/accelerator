# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### RUBOCOP

Ruby code is linted with [RuboCop](https://rubocop.org/), using the Rails
default style ([rubocop-rails-omakase](https://github.com/rails/rubocop-rails-omakase))
plus a few project rules in `.rubocop.yml`:

- **Double quotes** for strings, including strings inside interpolation.
- **Frozen string literals:** every Ruby file must start with
  `# frozen_string_literal: true`.

### TESTING

Tests are written with [RSpec](https://rspec.info/) (`rspec-rails`) and
[Capybara](https://teamcapybara.github.io/capybara/).

- Run the whole suite: `bin/rspec`
- Run one file or example: `bin/rspec spec/requests/smoke_spec.rb:6`
- System specs (`type: :system`, in `spec/system/`) use Capybara's fast
  `rack_test` driver by default. Tag a spec with `js: true` to run it in
  headless Chrome instead (requires Chrome installed locally).
  Create one with `bin/rails generate rspec:system widgets`.
- Shared spec setup goes in `spec/support/`, which is loaded automatically.
- Test data comes from [FactoryBot](https://github.com/thoughtbot/factory_bot)
  factories in `spec/factories/`. Use `build(:widget)` / `create(:widget)`
  directly in specs. `spec/factories_spec.rb` checks that every factory is valid.

Rails generators create matching specs under `spec/`, for example:

- `bin/rails generate model Widget` → `spec/models/widget_spec.rb` and
  `spec/factories/widgets.rb`
- `bin/rails generate controller Widgets` → `spec/requests/widgets_spec.rb`
