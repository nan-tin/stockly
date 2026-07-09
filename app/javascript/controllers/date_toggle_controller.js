import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "icon"]
  static values = {
    enabled: Boolean,
    defaultDate: String
  }

  connect() {
    this.update()
  }

  toggle() {
    this.enabledValue = !this.enabledValue

    if (this.enabledValue && !this.inputTarget.value) {
      this.inputTarget.value = this.defaultDateValue
    }

    if (!this.enabledValue) {
      this.inputTarget.value = ""
    }

    this.update()
  }

  update() {
    this.inputTarget.disabled = !this.enabledValue

    if (this.enabledValue) {
      this.buttonTarget.classList.remove("bg-white", "border", "border-stone-900")
      this.buttonTarget.classList.add("bg-stone-900", "text-white")
      this.iconTarget.classList.remove("hidden")
    } else {
      this.buttonTarget.classList.remove("bg-stone-900", "text-white")
      this.buttonTarget.classList.add("bg-white", "border", "border-stone-900")
      this.iconTarget.classList.add("hidden")
    }
  }
}