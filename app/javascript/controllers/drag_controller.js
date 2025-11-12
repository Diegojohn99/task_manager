import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drag"
export default class extends Controller {
  static targets = ["column"]

  connect() {
    // enable dragover on columns
    this.columnTargets.forEach((col) => {
      col.addEventListener("dragover", (e) => {
        e.preventDefault()
        col.classList.add("border", "border-primary")
      })
      col.addEventListener("dragleave", () => {
        col.classList.remove("border", "border-primary")
      })
      col.addEventListener("drop", (e) => this.drop(e, col))
    })
  }

  dragstart(e) {
    const id = e.target.dataset.taskId
    e.dataTransfer.setData("text/plain", id)
  }

  async drop(e, col) {
    e.preventDefault()
    col.classList.remove("border", "border-primary")

    const id = e.dataTransfer.getData("text/plain")
    const newStatus = col.dataset.status

    if (!id || !newStatus) return

    // optimistic UI: move card
    const card = this.element.querySelector(`[data-task-id='${id}']`)
    if (card) col.querySelector(".list-group")?.prepend(card)

    const token = document.querySelector("meta[name='csrf-token']")?.getAttribute("content")
    try {
      const res = await fetch(`/tasks/${id}/update_status`, {
        method: "PATCH",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "X-CSRF-Token": token || ""
        },
        body: JSON.stringify({ status: newStatus })
      })
      if (!res.ok) {
        const data = await res.json().catch(() => ({}))
        alert(data.error || "No se pudo actualizar el estado")
      }
    } catch (err) {
      alert("Error de red al actualizar el estado")
    }
  }
}
