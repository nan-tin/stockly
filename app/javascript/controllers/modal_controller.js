import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = {
    closeUrl: String
  }

  close(event) {
    // モーダルの背景自体をクリックした場合だけ閉じる
    if (event.target !== event.currentTarget) return

    Turbo.visit(this.closeUrlValue)
  }

  closeWithEscape(event) {
    if (event.key !== "Escape") return

    Turbo.visit(this.closeUrlValue)
  }
}