import { cleanup, CustomRender, screen, fireEvent } from 'test-utils'
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
  src: 'src',
  handleLoginConfirmed: () => {}
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<EaselBuyWebView {...props} />)
  const easelBuyWebView = screen.getByTestId('easelBuyWebView-molecule')
  const easelBuyWebViewButtonBuy = screen.getByTestId(
    'easelBuyWebViewButtonBuy-organism'
  )
  const easelBuyWebViewAccordion1 = screen.getByTestId(
    'easelBuyWebViewAccordion1-organism'
  )
  return {
    easelBuyWebView,
    easelBuyWebViewButtonBuy,
    easelBuyWebViewAccordion1
  }
}

describe('<EaselBuyWebView />', () => {
  it('Should Render EaselBuyWebView', async () => {
    const { easelBuyWebView } = setup()
    expect(easelBuyWebView).toBeInTheDocument()
  })

  it('Should Click on Buy Button', async () => {
    const { easelBuyWebViewButtonBuy } = setup()
    fireEvent.click(easelBuyWebViewButtonBuy)
  })

  it('Should Click on View more ownership Button', async () => {
    const { easelBuyWebViewAccordion1 } = setup()
    fireEvent.click(easelBuyWebViewAccordion1)
  })
})
