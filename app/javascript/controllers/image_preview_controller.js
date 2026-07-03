import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "placeholder"]

  preview() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const reader = new FileReader()

    reader.onload = (event) => {
      this.previewTarget.src = event.target.result
      this.previewTarget.classList.remove("hidden")
      this.placeholderTarget.classList.add("hidden")
    }

    reader.readAsDataURL(file)
  }
}
