class NotificationFeed {
  feed: HTMLElement

  constructor(feed: HTMLElement) {
    this.feed = feed
  }

  initHandlers(): void {
    this.onNotificationIconClick()
  }

  onNotificationIconClick(): void {
    // toggle hidden
    this.feed.hidden = !this.feed.hidden
  }
}


document.addEventListener("turbolinks:load", () => {
  // Show modal when a "Create room" button is clicked
  document.querySelector("#notifications").addEventListener('click', () => {
    console.log('clicked')
    const feed = document.querySelector('.notification-feed') as HTMLElement
    feed.classList.toggle('is-hidden')
    // const notificationFeed = document.querySelector('.notification-feed') as HTMLElement
    // new NotificationFeed(notificationFeed).initHandlers()
  })
})
