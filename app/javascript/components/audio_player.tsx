import * as React from "react"
import ReactHowler from "react-howler"
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPlayCircle, faPauseCircle } from '@fortawesome/free-regular-svg-icons'
import { IconDefinition } from '@fortawesome/fontawesome-svg-core'

interface AudioPlayerProps {
  audioUrl: string
}

const AudioPlayer = (props: AudioPlayerProps) => {
  const [playing, setPlaying] = React.useState(false)

  function playPause(): void {
    setPlaying(!playing)
  }

  function stateButtonIcon(): IconDefinition {
    if (playing) {
      return faPauseCircle
    } else {
      return faPlayCircle
    }
  }

  return (
    <div>
      <ReactHowler
        src={props.audioUrl}
        playing={playing}
        preload={false}
      />
      <button className="button is-outlined is-primary is-large is-fullwidth" onClick={playPause}>
        <FontAwesomeIcon icon={stateButtonIcon()} />
      </button>
    </div>
  )
}

export default AudioPlayer
