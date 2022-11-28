import { cleanup, CustomRender, screen } from 'test-utils'
import { ToggleText } from './toggle-text-length'

const props = {
  text: 'Test Text',
  showText: true,
  length: 5
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<ToggleText {...props} />)
  const toggleText = screen.getByTestId('toggleText-atom')
  return { toggleText }
}

describe('<ToggleText />', () => {
  it('Should Render ToggleText', async () => {
    const { toggleText } = setup()
    expect(toggleText).toBeInTheDocument()
  })

  it('Should Have Text Content', async () => {
    const { toggleText } = setup()
    expect(toggleText).toHaveTextContent(/Test/i)
  })
})
