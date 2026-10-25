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

Tests are written with [RSpec](https://rspec.info/) (`rspec-rails`) and
[Capybara](https://teamcapybara.github.io/capybara/).

- Run the whole suite: `bin/rspec`
- Run one file or example: `bin/rspec spec/requests/smoke_spec.rb:6`
- System specs (`type: :system`, in `spec/system/`) all run in headless Chrome
  with JavaScript on, so there's no need to tag `js: true`. 
  See [Faster system specs](#faster-system-specs-not-set-up) to configure JS.
  Set `TEST_BROWSER=true` to watch them run in a visible Chrome window
  (see [Watching system specs](#watching-system-specs-in-a-browser)).
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

#### Watching system specs in a browser

System specs run in headless Chrome, with no window. To watch them run in a
visible Chrome window, set `TEST_BROWSER`:

```sh
TEST_BROWSER=true bin/rspec spec/system
```

`true`, `1` and `yes` turn it on; leave it unset (as CI does) for headless.
The switch lives in `spec/support/test_browser.rb`.

#### Faster system specs (not set up)

Running every system spec in Chrome is simple but slower, because each one
starts a browser. If the system suite gets slow, add this file to run plain
specs with Capybara's `rack_test` driver (no browser, no JavaScript) and only
use Chrome for specs tagged `js: true`:

```ruby
# spec/support/capybara.rb
RSpec.configure do |config|
  # Fast, JavaScript-free driver by default for system specs.
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # Tag a spec with `js: true` to run it in headless Chrome.
  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  end
end
```

If you add this, fold `spec/support/test_browser.rb` into the `js: true` block
(use `:chrome` instead of `:headless_chrome` when `TEST_BROWSER` is set) so
the switch keeps working.

Capybara's own `js: true` doesn't work in system specs, because Rails picks
the driver with `driven_by`, which is why the second block is needed. The same
pattern works for any other driver: register it with Capybara, then call
`driven_by :your_driver` in a `before` block.

- **Pros:** much faster plain specs; `rack_test` can also check HTTP status
  codes (`page.status_code`), which Chrome can't.
- **Cons:** you must remember to tag specs that need JavaScript (untagged ones
  silently skip it), and a spec can pass in `rack_test` even if the real page
  has a JavaScript error.
