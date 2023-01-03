import { cleanup, CustomRender, screen } from 'test-utils'
import { NftDetails } from './nft-details'

const props = {
  recipeId: 'recipeId'
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<NftDetails {...props} />)
  const nftDetails = screen.getByTestId('nftDetails-molecule')
  return { nftDetails }
}

describe('<NftDetails />', () => {
  it('Should Render NftDetails', async () => {
    const { nftDetails } = setup()
    expect(nftDetails).toBeInTheDocument()
  })

  it('Should Have Text Content', async () => {
    const { nftDetails } = setup()
    expect(nftDetails).toHaveTextContent(/recipeId/i)
  })
})
