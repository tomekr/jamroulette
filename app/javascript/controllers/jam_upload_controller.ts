import { Controller } from "stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
  static classes = ["active", "progressLoading", "progressDone"]
  static targets = ["uploadModal", "uploadForm", "fileField", "fileName", "durationField", "bpmField", "progressBar"]

  // Classes
  activeClass: string
  progressLoadingClass: string
  progressDoneClass: string

  // Targets
  uploadFormTarget: HTMLFormElement
  uploadModalTarget: HTMLElement
  fileFieldTarget: HTMLInputElement
  durationFieldTarget: HTMLInputElement
  fileNameTarget: HTMLSpanElement
  bpmFieldTarget: HTMLInputElement
  progressBarTarget: HTMLProgressElement

  toggleModal(event: CustomEvent) {
    this.uploadModalTarget.classList.toggle(this.activeClass)
  }

  uploadFile(file: File): void {
    const url = this.fileFieldTarget.dataset.directUploadUrl
    const upload = new DirectUpload(file, url)
    upload.create((error, blob) => {
      if (error) {
        throw new Error('Direct Upload Error - ' + error)
      } else {
        // Add an appropriately-named hidden input to the form with a
        // value of blob.signed_id so that the blob ids will be
        // transmitted in the normal upload flow
        const hiddenField = document.createElement('input')
        hiddenField.setAttribute("type", "hidden")
        hiddenField.setAttribute("value", blob.signed_id)
        hiddenField.name = this.fileFieldTarget.name
        this.uploadFormTarget.appendChild(hiddenField)
      }
    })
  }

  submitForm() {
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

      const directUploadController = new DirectUploadController(this, fileToUpload)
      directUploadController.start()

      // Send focus to bpm input
      this.bpmFieldTarget.focus()
    }
  }
}

class DirectUploadController {
  directUpload: DirectUpload
  source: Controller
  file: File
  xhr: XMLHttpRequest
  hiddenInput: HTMLInputElement
  progressBar: HTMLProgressElement

  constructor(source: Controller, file: File) {
    this.directUpload = new DirectUpload(file, source.fileFieldTarget.dataset.directUploadUrl, this)
    this.source = source
    this.progressBar = this.source.progressBarTarget
    this.file = file
  }

  public start(): void {
    this.hiddenInput = this.createHiddenInput()
    this.uploadRequestStarted()
    this.directUpload.create((error, blob) => {
      if (error) {
        this.removeElement(this.hiddenInput)
      } else {
        this.hiddenInput.value = blob.signed_id
        this.hiddenInput.name = this.source.fileFieldTarget.name
      }
    })
  }

  public directUploadWillStoreFileWithXHR(xhr): void {
    this.bindProgressEvent(xhr)
  }

  private bindProgressEvent(xhr: XMLHttpRequest): void {
    this.xhr = xhr
    this.xhr.upload.addEventListener("progress", event =>
      this.uploadRequestDidProgress(event)
    )

    this.xhr.addEventListener("load", () => {
      this.uploadRequestFinished()
    })
  }

  private uploadRequestStarted(): void {
    this.progressBar.classList.remove(this.source.progressDoneClass)
    this.progressBar.classList.add(this.source.progressLoadingClass)
  }
  private uploadRequestFinished(): void {
    this.progressBar.classList.remove(this.source.progressLoadingClass)
    this.progressBar.classList.add(this.source.progressDoneClass)
  }

  private uploadRequestDidProgress(event): void {
    const progress = (event.loaded / event.total) * 100
    this.progressBar.value = progress
  }

  private createHiddenInput(): HTMLInputElement {
    const hiddenField = document.createElement('input')
    hiddenField.setAttribute("type", "hidden")
    this.source.uploadFormTarget.appendChild(hiddenField)
    return hiddenField
  }

  private removeElement(element: HTMLElement): void {
    if (element && element.parentNode) {
      element.parentNode.removeChild(element)
    }
  }
}