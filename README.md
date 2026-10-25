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
