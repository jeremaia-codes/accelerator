import { Controller } from "@hotwired/stimulus"

// Switches the site between light and dark mode by adding or removing the
// "dark" class on <html>. The choice is saved in localStorage; until someone
// picks, the system setting is used.
export default class extends Controller {
  static targets = ["toggle"]

  connect() {
    const savedTheme = localStorage.getItem("darkMode")
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches

    this.setDarkMode(savedTheme === "true" || (savedTheme === null && prefersDark))
  }

  toggle() {
    const dark = !this.isDarkMode()

    this.setDarkMode(dark)
    localStorage.setItem("darkMode", dark)
  }

  setDarkMode(dark) {
    // Adds the "dark" class to <html> when dark is true and removes it when false
    document.documentElement.classList.toggle("dark", dark)
    this.toggleTargets.forEach((button) => button.setAttribute("aria-pressed", dark))
  }

  isDarkMode() {
    return document.documentElement.classList.contains("dark")
  }
}
