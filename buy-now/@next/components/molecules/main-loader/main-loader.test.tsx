import { cleanup, CustomRender, screen } from 'test-utils'
import { MainLoader } from './main-loader-molecule'

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<MainLoader />)
  const mainLoader = screen.getByTestId('mainLoader-molecule')
  return { mainLoader }
}

describe('<MainLoader />', () => {
  it('Should Render MainLoader', async () => {
    const { mainLoader } = setup()
    expect(mainLoader).toBeInTheDocument()
  })
})
