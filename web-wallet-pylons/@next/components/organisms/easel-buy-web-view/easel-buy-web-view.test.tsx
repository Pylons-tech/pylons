import { cleanup, CustomRender, screen } from 'test-utils'
import { EaselBuyWebView } from './easel-buy-web-view'

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
  src: 'src'
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<EaselBuyWebView {...props} />)
  const easelBuyWebView = screen.getByTestId('easelBuyWebView-molecule')
  return { easelBuyWebView }
}

describe('<EaselBuyWebView />', () => {
  it('Should Render EaselBuyWebView', async () => {
    const { easelBuyWebView } = setup()
    expect(easelBuyWebView).toBeInTheDocument()
  })
})
