document.addEventListener("DOMContentLoaded", () => {
  const feed = document.querySelector('#notifications') as HTMLElement
  const countTag = feed.querySelector(".tag") as HTMLSpanElement

  if (countTag.innerText != "0") {
    countTag.classList.replace("is-primary", "is-danger")
  }

  // Show modal when a "Create room" button is clicked
  document.querySelector("#notifications").addEventListener('click', (event) => {
    // Toggle feed list
    feed.classList.toggle('is-active')

    // Remove counter tag
    const counter = document.querySelector(".notification-counter") as HTMLElement
    counter.classList.replace('is-danger', 'is-primary')
    counter.innerHTML = '0'

    const notificationsContainer = document.querySelector("#notifications") as HTMLElement

    if (!notificationsContainer.classList.contains('read')) {
      // Mark notifications as read
      const userId = notificationsContainer.dataset.userId
      const token = document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement
      fetch(`/users/${userId}/notifications/read`, {
        credentials: 'include',
        method: 'PUT',
        headers: {
          'X-CSRF-Token': token.content
        }
      })

      notificationsContainer.classList.add('read')
    }
  })
})
