/* eslint-disable @next/next/no-img-element */
import { ModelViewerElement } from '@google/model-viewer'
import Image from 'next/image'
import { FC } from 'react'
interface PropsTypes {
  nftType: string
  source: string
  src?: string
}

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace JSX {
    interface IntrinsicElements {
      'model-viewer': ModelViewerElement | any
    }
  }
}
export const MediaSet: FC<PropsTypes> = ({ nftType, source, src }) => {
  const handleClick = (e: any): void => {
    if (e.type === 'click') {
    } else if (e.type === 'contextmenu') {
      e.preventDefault()
    }
  }
  const getMedia = (): any => {
    if (!nftType) return null
    else if (nftType.toLowerCase() === 'image') {
      return (
        <div className="img-inner">
          <Image
            data-testid="mediaSetImage-molecule"
            alt="views"
            src={source}
            onClick={handleClick}
            onContextMenu={handleClick}
            width={380}
            height={380}
          />
        </div>
      )
    } else if (nftType.toLowerCase() === 'audio') {
      return (
        <div className="img-audio">
          <Image
            data-testid="mediaSetAudio-molecule"
            alt="views"
            src={source}
            onClick={handleClick}
            onContextMenu={handleClick}
            width={380}
            height={380}
          />

          <audio
            controls
            onClick={handleClick}
            onContextMenu={handleClick}
            controlsList="nodownload"
            className="desktop-view "
            style={{
              marginTop: '25px',
              height: '50px'
            }}
          >
            <source src={src} type="audio/ogg" />
            <source src={src} type="audio/mpeg" />
            Your browser does not support the audio element.
          </audio>
        </div>
      )
    } else if (nftType.toLowerCase() === 'pdf') {
      return (
        <div className="img-inner">
          <Image
            data-testid="mediaSetPdf-molecule"
            alt="views"
            src={source}
            onClick={handleClick}
            onContextMenu={handleClick}
            width={380}
            height={380}
          />
        </div>
      )
    } else if (nftType.toLowerCase() === '3d') {
      return (
        <model-viewer
          data-testid="mediaSet3d-molecule"
          onClick={handleClick}
          onContextMenu={handleClick}
          alt="3D NFT"
          src={source}
          ar
          ar-modes="webxr scene-viewer quick-look"
          seamless-poster
          shadow-intensity="1"
          camera-controls
          enable-pan
          className="model-viewer"
        ></model-viewer>
      )
    } else {
      return (
        <div className="va-inner">
          <video
            width="100%"
            height="50%"
            controls
            autoPlay
            controlsList="nodownload"
            onClick={handleClick}
            onContextMenu={handleClick}
          >
            <source src={source} type="video/mp4" />
            <source src={source} type="video/ogg" />
            Your browser does not support the video tag.
          </video>
        </div>
      )
    }
  }

  return getMedia()
}
