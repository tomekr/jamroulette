import { Controller } from "stimulus"

export default class RoomTileToggleController extends Controller {
  static classes = ["hidden", "toggled"]
  static targets = ["filterInput", "roomTile"]
  static values = { toggled: Boolean, filter: Array }

  // Stimulus defines more dynamic properties that we aren't using:
  // hasHiddenClass: boolean
  // hastargetNameTarget: boolean
  // thingToFilterTarget: HTMLElement
  hiddenClass: string
  toggledClass: string
  filterValues: string[]

  roomTileTargets: HTMLElement[]

  filterValuesChanged(): void {
    if (this.filterValues.length == 0) {
      return
    }

    this.roomTileTargets.forEach((roomTile) => {
      const tags = roomTile.querySelector(".could-use-tags") as HTMLElement

      let visible = false

      this.filterValues.forEach((filterValue) => {
        if (tags.innerText.search(filterValue) >= 0) {
          visible = true
        }
      })

      roomTile.classList.toggle(this.hiddenClass, !visible)
    })
  }

  toggle(event: CustomEvent): void {
    // Get the clicked button
    const currentTargetButton = event.currentTarget as HTMLElement
    // Toggle the class. toggle() returns a boolean indicating whether
    // token is in the list after the call.
    const toggled = currentTargetButton.classList.toggle(this.toggledClass)
    const toggleValue = currentTargetButton.innerText

    if (toggled) {
      this.filterValues = this.filterValues.concat(toggleValue)
    } else {
      this.filterValues = this.filterValues.filter((tag) => tag !== toggleValue)
    }
  }
}
