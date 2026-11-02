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

  setOpen(open) {
    this.menuTarget.classList.toggle("hidden", !open)
    this.backdropTarget.classList.toggle("hidden", !open)
    this.toggleTarget.setAttribute("aria-expanded", open)
    this.backgroundTargets.forEach((element) => { element.inert = open })
  }
}
