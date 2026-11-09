import { Controller } from "@hotwired/stimulus"

// Opens the side menu as a drawer below the md breakpoint. From md upwards
// the menu is always shown by CSS, so an open drawer is closed on the way up.
export default class extends Controller {
  static targets = ["menu", "backdrop", "toggle", "closeButton", "background"]

  connect() {
    this.desktop = window.matchMedia("(min-width: 48rem)")
    this.closeOnDesktop = (event) => { if (event.matches) this.close() }
    this.desktop.addEventListener("change", this.closeOnDesktop)
  }

  disconnect() {
    this.desktop.removeEventListener("change", this.closeOnDesktop)
    this.close()
  }

  open() {
    this.setOpen(true)
    this.closeButtonTarget.focus()
  }

  close() {
    if (this.menuTarget.classList.contains("hidden")) return

    this.setOpen(false)
    this.toggleTarget.focus()
  }

  // Wraps Tab and Shift+Tab around the open drawer, so focus can't leave it
  // for the browser's own controls. Does nothing while the drawer is closed,
  // which is always the case from md up.
  wrapFocus(event) {
  if (event.key !== "Tab" || this.menuTarget.classList.contains("hidden")) return

    const focusable = this.menuTarget.querySelectorAll("a[href], button:not([disabled])")
    const [first, last] = [focusable[0], focusable[focusable.length - 1]]
    const [from, to] = event.shiftKey ? [first, last] : [last, first]

    if (document.activeElement !== from) return
    event.preventDefault()
    to.focus()
  }

  setOpen(open) {
    this.menuTarget.classList.toggle("hidden", !open)
    this.backdropTarget.classList.toggle("hidden", !open)
    this.toggleTarget.setAttribute("aria-expanded", open)
    this.backgroundTargets.forEach((element) => { element.inert = open })
    document.body.classList.toggle("overflow-hidden", open)
  }
}
