import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "backdrop", "panel"]

  connect() {
    this.closeTimer = null
  }

  disconnect() {
    if (this.closeTimer) {
      clearTimeout(this.closeTimer)
    }

    document.body.classList.remove("overflow-hidden")
  }

  open() {
    if (this.closeTimer) {
      clearTimeout(this.closeTimer)
      this.closeTimer = null
    }

    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")

    // hidden解除後にアニメーションを開始する
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.backdropTarget.classList.remove("opacity-0")
        this.backdropTarget.classList.add("opacity-100")

        this.panelTarget.classList.remove("opacity-0", "scale-95")
        this.panelTarget.classList.add("opacity-100", "scale-100")
      })
    })
  }

  close() {
    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")

    this.panelTarget.classList.remove("opacity-100", "scale-100")
    this.panelTarget.classList.add("opacity-0", "scale-95")

    this.closeTimer = setTimeout(() => {
      this.modalTarget.classList.add("hidden")
      document.body.classList.remove("overflow-hidden")
      this.closeTimer = null
    }, 200)
  }

  closeOnBackdrop(event) {
    if (event.target !== event.currentTarget) return

    this.close()
  }

  closeWithEscape(event) {
    if (event.key !== "Escape") return
    if (this.modalTarget.classList.contains("hidden")) return

    this.close()
  }
}