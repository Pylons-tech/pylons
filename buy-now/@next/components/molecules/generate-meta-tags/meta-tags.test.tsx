import { cleanup, CustomRender, screen } from 'test-utils'
import { MetaTags } from './meta-tags'

const props = {
  history: ['history1', 'history2'],
  createdBy: 'createdBy',
  name: 'name',
  description: 'description',
  price: 'price',
  denom: 'denom',
  nftType: 'nftType',
  dimensions: 'dimensions',
  royalty: 'royalty',
  edition: 'edition',
  media: 'media',
  createdAt: 'createdAt',
  recipeId: 'recipeId',
  src: 'src',
  thumbnail: 'thumbnail'
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<MetaTags {...props} />)
  const metaTags = screen.getByTestId('metaTags-molecule')
  return { metaTags }
}

describe('<MetaTags />', () => {
  it('Should Render MetaTags', async () => {
    const { metaTags } = setup()
    expect(metaTags).toBeInTheDocument()
  })
})
