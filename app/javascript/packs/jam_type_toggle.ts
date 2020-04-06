class JamTypeToggle {
  jamTypeField: HTMLElement
  jamTypeButtons: NodeListOf<HTMLButtonElement>
  jamTypeHiddenInput: HTMLInputElement

  selectedButton: HTMLButtonElement

  constructor(jamTypeField: HTMLElement) {
    this.jamTypeField = jamTypeField
    this.selectedButton = this.jamTypeField.querySelector(".is-primary")
    this.jamTypeButtons = this.jamTypeField.querySelectorAll(".jam-type-btn")
    this.jamTypeHiddenInput = this.jamTypeField.querySelector("#jam_jam_type_list")
  }

  initHandlers(): void {
    this.onJamTypeButtonClick()
  }

  onJamTypeButtonClick(): void {
    this.jamTypeButtons.forEach(jamTypeButton => {
      jamTypeButton.addEventListener("click", (event) => {
        // Prevent button from submitting form
        event.preventDefault()
        this.selectedButton.classList.remove('is-primary')
        jamTypeButton.classList.add('is-primary')
        this.selectedButton = jamTypeButton
        this.jamTypeHiddenInput.value = this.selectedButton.dataset["jamType"]
      })
    });
  }
}

document.addEventListener("DOMContentLoaded", () => {
  new JamTypeToggle(document.querySelector("#jam-type-buttons")).initHandlers()
})
