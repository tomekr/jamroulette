import * as React from "react"
import * as WaveSurfer from 'wavesurfer.js'
import CursorPlugin from 'wavesurfer.js/dist/plugin/wavesurfer.cursor'

interface WaveformPlayerProps {
  audioUrl: string
  id: number
}

const WaveformPlayer = (props: WaveformPlayerProps) => {
  let wavesurfer: WaveSurfer;

  React.useEffect(() => {
    wavesurfer = WaveSurfer.create({
      container: `#${waveformId()}`,
      waveColor: 'violet',
      progressColor: 'purple',
      plugins: [
        CursorPlugin.create({
          showTime: true,
          opacity: 1,
          customShowTimeStyle: {
            'background-color': '#000',
            color: '#fff',
            padding: '2px',
            'font-size': '10px'
          }
        })
      ]
    });
    wavesurfer.load(props.audioUrl)
  }, [])

  function waveformId(): string {
    return `waveform-${props.id}`
  }

  function togglePlay(event): void {
    if (wavesurfer) {
      if (wavesurfer.isPlaying()) {
        wavesurfer.pause();
      } else {
        wavesurfer.play();
      }

      // Get icon inside of the button that was clicked
      const audioControllerIcon = event.currentTarget.querySelector("#waveformAudioControlIcon");
      // toggle relevant play/pause font awesome classes
      audioControllerIcon.classList.toggle("fa-play-circle");
      audioControllerIcon.classList.toggle("fa-pause-circle");
    }
  }

  return (
    <div>
      <button id="waveformAudioControl" className="button is-large" onClick={togglePlay}>
        <i id="waveformAudioControlIcon" className="far fa-play-circle"></i>
      </button>

      <div id={waveformId()}></div>
    </div>
  )
}

export default WaveformPlayer