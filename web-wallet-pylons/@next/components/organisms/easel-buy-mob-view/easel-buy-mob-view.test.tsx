import { cleanup, CustomRender, screen, fireEvent } from 'test-utils'
import { EaselBuyMobView } from './easel-buy-mob-view'

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
  CustomRender(<EaselBuyMobView {...props} />)
  const easelBuyMobView = screen.getByTestId('easelBuyMobView-molecule')
  const easelBuyMobViewButton2 = screen.getByTestId(
    'easelBuyMobViewButton2-molecule'
  )
  const easelBuyMobViewButtonBuy = screen.getByTestId(
    'easelBuyMobViewButtonBuy-organism'
  )
  return { easelBuyMobView, easelBuyMobViewButton2, easelBuyMobViewButtonBuy }
}

describe('<EaselBuyMobView />', () => {
  it('Should Render EaselBuyMobView', async () => {
    const { easelBuyMobView } = setup()
    expect(easelBuyMobView).toBeInTheDocument()
  })

  it('Should Click on view more Button', async () => {
    const { easelBuyMobViewButton2 } = setup()
    fireEvent.click(easelBuyMobViewButton2)
  })

  it('Should Click on Buy Button', async () => {
    const { easelBuyMobViewButtonBuy } = setup()
    fireEvent.click(easelBuyMobViewButtonBuy)
  })
})
