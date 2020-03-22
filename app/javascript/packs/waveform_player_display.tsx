import * as React from "react"
import * as ReactDOM from "react-dom"
import WaveformPlayer from "../components/waveform_player"

document.addEventListener("turbolinks:load", () => {
  if (document.getElementById("main-waveform-react-element")) {
    ReactDOM.render(
      <WaveformPlayer audioUrl={"/amber.mp3"} id={0} />,
      document.getElementById("main-waveform-react-element")
    )
  }
})