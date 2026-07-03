import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quantity"
export default class extends Controller {
  static targets = ["input"]

  increase() {
    this.inputTarget.value = Number(this.inputTarget.value) + 1
  }

  decrease() {
    const value = Number(this.inputTarget.value)

    if (value > 0) {
      this.inputTarget.value = value - 1
    }
  }
}