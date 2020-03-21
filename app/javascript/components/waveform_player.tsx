import * as React from "react"

interface WaveformPlayerProps {
  audioUrl: string
}

const WaveformPlayer = (props: WaveformPlayerProps) => {
  return (
    <div id="waveform"></div>
  )
}

export default WaveformPlayer