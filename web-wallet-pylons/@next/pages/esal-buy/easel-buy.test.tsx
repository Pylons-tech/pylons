import { cleanup, CustomRender, screen } from 'test-utils'
import { EaselBuy } from './easel-buy'
import * as _ from 'lodash'
// const spyCloneDeepLodash = jest.spyOn(_, 'cloneDeep')

afterEach(cleanup)

beforeEach(() => {
  jest.clearAllMocks()
})

jest.mock('next/router', () => ({
  useRouter() {
    return {
      route: '/',
      pathname: '',
      query: { cookbook_id: '', recipe_id: '' },
      asPath: '',
      isReady: true
    }
  }
}))

const setup = (): any => {
  CustomRender(<EaselBuy />)
}

describe('<EaselBuy />', () => {
  it('Should Render EaselBuy', async () => {
    setup()
  })

  // it('Check orderBy method from lodash', () => {
  //   expect(spyCloneDeepLodash).toHaveBeenCalledWith()
  // })
})
