import { cleanup, CustomRender, screen } from 'test-utils'
import { Tabs } from './tabs'

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
  CustomRender(<Tabs {...props} />)
  const tabsAtom = screen.getByTestId('tabs-atom')
  return { tabsAtom }
}

describe('<Tabs />', () => {
  it('Should Render Tabs', async () => {
    const { tabsAtom } = setup()
    expect(tabsAtom).toBeInTheDocument()
  })
})
