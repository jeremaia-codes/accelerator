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

Generates files, like models or controllers, are configured to auto-lint in `config/application.rb`.

- **Double quotes** for strings, including strings inside interpolation.
- **Frozen string literals:** every Ruby file must start with
  `# frozen_string_literal: true`.

### TESTING

Tests are written with [RSpec](https://rspec.info/) (`rspec-rails`).

- Run the whole suite: `bin/rspec`
- Run one file or example: `bin/rspec spec/requests/smoke_spec.rb:6`
- Shared spec setup goes in `spec/support/`, which is loaded automatically.
- Test data comes from [FactoryBot](https://github.com/thoughtbot/factory_bot)
  factories in `spec/factories/`. Call `build(:widget)` / `create(:widget)`
  without the `FactoryBot.` prefix; `spec/support/factory_bot.rb` sets this up
  (FactoryBot's recommended RSpec config). See [Factory lint](#factory-lint) below.

Rails generators create matching specs under `spec/`, for example:

- `bin/rails generate model Widget` → `spec/models/widget_spec.rb` and
  `spec/factories/widgets.rb`
- `bin/rails generate controller Widgets` → `spec/requests/widgets_spec.rb`

#### Factory lint
Safeguards us from committing broken factories.

`spec/factories_spec.rb` runs
[`FactoryBot.lint`](https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#linting-factories),
which creates every factory and trait and checks they're valid.

- Keep each default factory valid on its own; put variations in traits.
- For classes that aren't Active Record models, use `to_create(&:validate!)`
  (not `skip_create`) so the lint can catch invalid attributes.
