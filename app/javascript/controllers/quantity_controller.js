import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values = { min: Number }

  increase() {
    this.inputTarget.value = Number(this.inputTarget.value) + 1
  }

  decrease() {
    const value = Number(this.inputTarget.value)
    const min = this.hasMinValue ? this.minValue : 0

    if (value > min) {
      this.inputTarget.value = value - 1
    }
  }
}