import { Controller } from "stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
  static classes = ["active"]
  static targets = ["uploadModal", "uploadForm", "fileField", "fileName", "durationField", "bpmField"]

  activeClass: string
  uploadFormTarget: HTMLFormElement
  uploadModalTarget: HTMLElement
  fileFieldTarget: HTMLInputElement
  durationFieldTarget: HTMLInputElement
  fileNameTarget: HTMLSpanElement
  bpmFieldTarget: HTMLInputElement

  toggleModal(event: CustomEvent) {
    this.uploadModalTarget.classList.toggle(this.activeClass)
  }

  uploadFile(file: File): void {
    const url = this.fileFieldTarget.dataset.directUploadUrl
    const upload = new DirectUpload(file, url)
    upload.create((error, blob) => {
      if (error) {
        throw new Error('Direct Upload Error - ' + error);
      } else {
        // Add an appropriately-named hidden input to the form with a
        // value of blob.signed_id so that the blob ids will be
        // transmitted in the normal upload flow
        const hiddenField = document.createElement('input')
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("value", blob.signed_id);
        hiddenField.name = this.fileFieldTarget.name
        this.uploadFormTarget.appendChild(hiddenField)
      }
    })
  }

  upload() {
    this.uploadFormTarget.submit()
  }

  setFilename(name: string): void {
    this.fileNameTarget.textContent = name
  }

  setDuration(duration: number): void {
    this.durationFieldTarget.value = duration.toString()
  }

  isAudioWithDuration(file: File): boolean {
    return file.type.startsWith("audio/") && !(file.type === "audio/midi" || file.type === "audio/x-midi")
  }

  browserHasAudioContext(): boolean {
    const browserAudioContext = window.AudioContext || window["webkitAudioContext"] || null
    return !(browserAudioContext == null)
  }

  extractDurationFromAudioFile(file: File): void {
    const audioContext = new AudioContext()
    file.arrayBuffer().then(fileBuffer => {
      audioContext.decodeAudioData(fileBuffer)
        .then(decodedAudioData => {
          this.setDuration(decodedAudioData.duration)
        })
    })
  }

  fileSelected() {
    if (this.fileFieldTarget.files.length > 0) {
      // Display the filename in the file upload div
      const fileToUpload = this.fileFieldTarget.files[0]
      this.setFilename(fileToUpload.name)

      // Extract duration if file is audio
      if (this.isAudioWithDuration(fileToUpload) && this.browserHasAudioContext()) {
        this.extractDurationFromAudioFile(fileToUpload)
      }

      this.uploadFile(fileToUpload)

      // Send focus to bpm input
      this.bpmFieldTarget.focus()
    }
  }
}
