import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-all"
export default class extends Controller {
  static targets = ["checkbox"]

  toggleAll() {
    const allChecked = this.checkboxTargets.every((checkbox) => checkbox.checked)

    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = !allChecked
    })
  }
}