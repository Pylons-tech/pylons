import { cleanup, CustomRender } from 'test-utils'
import { MainLayout } from './main-layout'

const props = {
  children: <></>
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<MainLayout {...props} />)
}

describe('<MainLayout />', () => {
  it('Should Render MainLayout', async () => {
    setup()
  })
})
