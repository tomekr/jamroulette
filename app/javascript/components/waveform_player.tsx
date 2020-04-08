import * as React from "react"
import * as WaveSurfer from 'wavesurfer.js'
import CursorPlugin from 'wavesurfer.js/dist/plugin/wavesurfer.cursor'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPlayCircle, faPauseCircle } from '@fortawesome/free-regular-svg-icons'
import { IconDefinition } from '@fortawesome/fontawesome-svg-core'

window.AudioContext = window.AudioContext || window['webkitAudioContext'] || null;
if (!window.AudioContext) {
  throw new Error(
    'Could not find AudioContext. This may be because your browser does not support Web Audio.');
}

interface WaveformPlayerProps {
  audioUrl: string
}

const WaveformPlayer = (props: WaveformPlayerProps) => {
  const [playing, setPlaying] = React.useState(false)

  const waveform = React.useRef<WaveSurfer | null>(null)
  const audioContext = React.useRef(new AudioContext())
  const waveformDivRef = React.useRef();

  React.useEffect(() => {
    if (waveformDivRef.current && audioContext.current) {
      waveform.current = WaveSurfer.create({
        audioContext: audioContext.current,
        container: waveformDivRef.current,
        waveColor: 'violet',
        progressColor: 'purple',
        responsive: true,
        barWidth: 4,
        normalize: true,
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

      waveform.current.on('finish', audioFinishedPlaying)
      waveform.current.load(props.audioUrl)
    }
  }, [props.audioUrl])

  function togglePlayPause(): void {
    if (audioContext.current.state === "suspended") {
      audioContext.current.resume()
    }

    waveform.current.playPause()
    setPlaying(!playing)
  }

  function audioFinishedPlaying(): void {
    setPlaying(false)
  }

  function stateButtonIcon(): IconDefinition {
    if (playing) {
      return faPauseCircle
    } else {
      return faPlayCircle
    }
  }

  return (
    <div className="columns is-vcentered">
      <div className="column is-narrow">
        <button id="waveformAudioControl" className="button is-large" onClick={togglePlayPause}>
          <FontAwesomeIcon icon={stateButtonIcon()} />
        </button>
      </div>

      <div className="column">
        <div ref={waveformDivRef} style={{ position: 'relative' }}>
        </div>
      </div>
    </div>
  )
}

export default WaveformPlayer