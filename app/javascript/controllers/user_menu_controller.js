import { Controller } from "@hotwired/stimulus"

// Opens and closes the user menu at the bottom of the sidenav. A click
// outside the menu or the Escape key closes it again.
export default class extends Controller {
  static targets = ["button", "menu"]

  toggle() {
    this.setOpen(this.menuTarget.classList.contains("hidden"))
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) this.setOpen(false)
  }

  // Stops Escape reaching the sidenav, so only the user menu closes
  closeWithEscape(event) {
    if (this.menuTarget.classList.contains("hidden")) return

    event.stopPropagation()
    this.setOpen(false)
    this.buttonTarget.focus()
  }

  setOpen(open) {
    this.menuTarget.classList.toggle("hidden", !open)
    this.buttonTarget.setAttribute("aria-expanded", open)
  }
}
