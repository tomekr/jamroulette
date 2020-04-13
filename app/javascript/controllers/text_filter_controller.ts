import { Controller } from "stimulus"

export default class extends Controller {
  static classes = ["hidden"]
  static targets = ["filterInput", "roomTile"]

  hiddenClass: string
  roomTileTargets: HTMLElement[]
  filterInputTarget: HTMLInputElement

  get filterValue(): string {
    return this.filterInputTarget.value.toLowerCase()
  }

  filter() {
    this.roomTileTargets.forEach(roomTile => {
      const couldUseTags = roomTile.querySelector(".could-use-tags") as HTMLElement
      const visible =
        couldUseTags.innerText.toLowerCase().search(this.filterValue) >= 0
      roomTile.classList.toggle(this.hiddenClass, !visible)
    })
  }
}
