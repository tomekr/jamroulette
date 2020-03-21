import * as React from "react"
import * as ReactDOM from "react-dom"
import WaveformPlayer from "../components/waveform_player"

document.addEventListener("turbolinks:load", () => {
  if (document.getElementById("react-element")) {
    ReactDOM.render(
      <WaveformPlayer audioUrl={"https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3"} />,
      document.getElementById("react-element")
    )
  }
})