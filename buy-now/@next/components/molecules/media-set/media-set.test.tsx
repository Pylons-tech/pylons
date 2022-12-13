import { cleanup, CustomRender, screen, fireEvent } from 'test-utils'
import { MediaSet } from './media-set'

const props = {
  nftType: 'image',
  source: '/images/source',
  src: '/src'
}

const props2 = {
  nftType: 'audio',
  source: '/images/source',
  src: '/src'
}

const props3 = {
  nftType: 'pdf',
  source: '/images/source',
  src: '/src'
}

const props4 = {
  nftType: '3d',
  source: '/images/source',
  src: '/src'
}

const props5 = {
  nftType: '',
  source: '/images/source',
  src: '/src'
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<MediaSet {...props} />)
  const mediaSetImage = screen.getByTestId('mediaSetImage-molecule')
  return { mediaSetImage }
}

const setup2 = (): any => {
  CustomRender(<MediaSet {...props2} />)
  const mediaSetAudio = screen.getByTestId('mediaSetAudio-molecule')
  return { mediaSetAudio }
}

const setup3 = (): any => {
  CustomRender(<MediaSet {...props3} />)
  const mediaSetPdf = screen.getByTestId('mediaSetPdf-molecule')
  return { mediaSetPdf }
}

const setup4 = (): any => {
  CustomRender(<MediaSet {...props4} />)
  const mediaSet3d = screen.getByTestId('mediaSet3d-molecule')
  return { mediaSet3d }
}

const setup5 = (): any => {
  CustomRender(<MediaSet {...props5} />)
}

describe('<MediaSet />', () => {
  it('Should Render MediaSetImage', async () => {
    const { mediaSetImage } = setup()
    expect(mediaSetImage).toBeInTheDocument()
  })
  it('After Click on Image', async () => {
    const { mediaSetImage } = setup()
    fireEvent.click(mediaSetImage)
  })

  it('Should Render MediaSetImage', async () => {
    const { mediaSetAudio } = setup2()
    expect(mediaSetAudio).toBeInTheDocument()
  })
  it('After Click on Image', async () => {
    const { mediaSetAudio } = setup2()
    fireEvent.click(mediaSetAudio)
  })

  it('Should Render MediaSetImage', async () => {
    const { mediaSetPdf } = setup3()
    expect(mediaSetPdf).toBeInTheDocument()
  })
  it('After Click on Image', async () => {
    const { mediaSetPdf } = setup3()
    fireEvent.click(mediaSetPdf)
  })

  it('Should Render MediaSetImage', async () => {
    const { mediaSet3d } = setup4()
    expect(mediaSet3d).toBeInTheDocument()
  })
  it('After Click on Image', async () => {
    const { mediaSet3d } = setup4()
    fireEvent.click(mediaSet3d)
  })

  it('Should Render MediaSetImage', async () => {
    setup5()
  })
})
