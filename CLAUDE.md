# CLAUDE.md

## Writing style

- Use British English.
- Keep wording simple and direct, and don't repeat yourself.
- Favour bullet points.

## Specs

- `resize_window` lives inside `spec/system/sidenav_spec.rb` for now. When
  another system spec needs to resize the window, move it (and the `after`
  hook that restores the original size) into a shared helper in
  `spec/support/` instead of copying it.
