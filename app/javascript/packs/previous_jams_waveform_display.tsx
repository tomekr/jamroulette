import * as React from "react"
import * as ReactDOM from "react-dom"
import WaveformPlayer from "../components/waveform_player"

document.addEventListener("turbolinks:load", () => {
  if (document.getElementById("previous-jams-react-element")) {
    ReactDOM.render(
      <div>
        <WaveformPlayer audioUrl={"/amber.mp3"} id={1} />
        <WaveformPlayer audioUrl={"/amber.mp3"} id={2} />
        <WaveformPlayer audioUrl={"/amber.mp3"} id={3} />
      </div>,
      document.getElementById("previous-jams-react-element")
    )
  }
})