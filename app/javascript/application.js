// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

let pendingScrollRestore = null

const bindInlineEditors = () => {
  document.querySelectorAll("[data-editor-target]").forEach((button) => {
    if (button.dataset.editorBound === "true") return

    button.addEventListener("click", () => {
      const target = document.getElementById(button.dataset.editorTarget)
      if (!target) return

      target.hidden = !target.hidden
    })

    button.dataset.editorBound = "true"
  })

  document.querySelectorAll("[data-editor-close]").forEach((button) => {
    if (button.dataset.editorBound === "true") return

    button.addEventListener("click", () => {
      const target = document.getElementById(button.dataset.editorClose)
      if (!target) return

      target.hidden = true
    })

    button.dataset.editorBound = "true"
  })
}

const snapshotPlannerState = () => ({
  visibleEditors: Array.from(document.querySelectorAll(".planner-editor[id]:not([hidden])"), (element) => element.id),
  scrollX: window.scrollX,
  scrollY: window.scrollY,
})

const restorePlannerState = (state) => {
  state.visibleEditors.forEach((id) => {
    const element = document.getElementById(id)
    if (element) element.hidden = false
  })

  window.scrollTo(state.scrollX, state.scrollY)
}

const restorePendingScroll = () => {
  if (!pendingScrollRestore) return

  window.scrollTo(pendingScrollRestore.x, pendingScrollRestore.y)
  pendingScrollRestore = null
}

document.addEventListener("turbo:before-visit", (event) => {
  const nextUrl = new URL(event.detail.url)
  const currentUrl = new URL(window.location.href)

  if (nextUrl.pathname !== currentUrl.pathname) return

  pendingScrollRestore = {
    x: window.scrollX,
    y: window.scrollY,
  }
})

document.addEventListener("turbo:before-render", (event) => {
  if (!pendingScrollRestore) return

  const originalRender = event.detail.render

  event.detail.render = (currentElement, newElement) => {
    originalRender(currentElement, newElement)
    requestAnimationFrame(() => restorePendingScroll())
  }
})

document.addEventListener("turbo:before-stream-render", (event) => {
  const state = snapshotPlannerState()
  const originalRender = event.detail.render

  event.detail.render = (streamElement) => {
    originalRender(streamElement)
    requestAnimationFrame(() => restorePlannerState(state))
  }
})

document.addEventListener("turbo:load", bindInlineEditors)
document.addEventListener("turbo:render", bindInlineEditors)
