import { cleanup, CustomRender, screen } from 'test-utils'
import { OwnershipDetails } from './ownership-details'

const props = {
  owner: 'owner',
  edition: 'edition',
  royalty: 'royalty',
  dimensions: 'dimensions',
  createdAt: 'createdAt'
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<OwnershipDetails {...props} />)
  const ownerShipDetails = screen.getByTestId('ownerShipDetails-molecule')
  return { ownerShipDetails }
}

describe('<OwnershipDetails />', () => {
  it('Should Render OwnershipDetails', async () => {
    const { ownerShipDetails } = setup()
    expect(ownerShipDetails).toBeInTheDocument()
  })

  it('Should Have Text Content', async () => {
    const { ownerShipDetails } = setup()
    expect(ownerShipDetails).toHaveTextContent(/owner/i)
  })
})
