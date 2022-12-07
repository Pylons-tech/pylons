import { cleanup, CustomRender, screen } from 'test-utils'
import { MediaCard } from './media'

const props = {
  type: 'image',
  src: 'images/src.png',
  title: 'Media Title',
  height: '100%',
  width: '100%',
  maxWidth: 150
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<MediaCard {...props} />)
  const mediaCard = screen.getByTestId('mediaCard-atom')
  return { mediaCard }
}

describe('<MediaCard />', () => {
  it('Should Render MediaCard', async () => {
    const { mediaCard } = setup()
    expect(mediaCard).toBeInTheDocument()
  })
})
