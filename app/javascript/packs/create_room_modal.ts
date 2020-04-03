class CreateRoomModal {
  modal: HTMLElement
  createButton: HTMLElement
  closeButtons: NodeListOf<HTMLElement>
  nameInput: HTMLInputElement
  roomForm: HTMLFormElement

  constructor(modal: HTMLElement) {
    this.modal = modal
    this.createButton = this.modal.querySelector("#room-create-create-btn")
    this.closeButtons = this.modal.querySelectorAll(".modal-close-btn")
    this.roomForm = this.modal.querySelector("#room-form")
    this.nameInput = this.modal.querySelector("#room_name")
  }

  initHandlers(): void {
    // show the modal
    this.modal.classList.add('is-active');

    // send focus to the name input field
    this.nameInput.focus()

    // set on click listeners
    this.onCloseButtonClick()
    this.onRoomFormSubmit()
    this.onEnterKeyPressed()
  }

  onEnterKeyPressed(): void {
    this.nameInput.addEventListener('keydown', (event) => {
      if (event.keyCode === 13) {
        event.preventDefault();
        this.roomForm.submit()
      }
    })
  }
  onRoomFormSubmit(): void {
    this.roomForm.addEventListener('submit', () => {
      this.closeModal()
    })
  }

  onCloseButtonClick(): void {
    this.closeButtons.forEach(closeElement => {
      closeElement.addEventListener("click", (event) => {
        event.preventDefault()
        this.closeModal()
      })
    })
  }

  closeModal(): void {
    this.modal.classList.remove('is-active')
  }
}

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".create-room-button").forEach(createRoomButton => {
    // Show modal when a "Create room" button is clicked
    createRoomButton.addEventListener('click', () => {
      const createRoomModal = document.querySelector('#create-room-modal') as HTMLElement
      new CreateRoomModal(createRoomModal).initHandlers()
    })
  })
})
