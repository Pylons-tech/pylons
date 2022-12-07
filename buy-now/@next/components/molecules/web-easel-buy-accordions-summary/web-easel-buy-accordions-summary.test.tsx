import { cleanup, CustomRender, screen } from 'test-utils'
import { WebOwnershipAccordionSummary } from './web-easel-buy-accordions-summary'

const props = {
  expanded: 'accordionId',
  accordionId: 'accordionId',
  title: 'title',
  icon: 'icon'
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<WebOwnershipAccordionSummary {...props} />)
  const webOwnershipAccordionSummary = screen.getByTestId(
    'webOwnershipAccordionSummary-molecule'
  )
  return { webOwnershipAccordionSummary }
}

describe('<WebOwnershipAccordionSummary />', () => {
  it('Should Render WebOwnershipAccordionSummary', async () => {
    const { webOwnershipAccordionSummary } = setup()
    expect(webOwnershipAccordionSummary).toBeInTheDocument()
  })

  it('Should Have Text Title', async () => {
    const { webOwnershipAccordionSummary } = setup()
    expect(webOwnershipAccordionSummary).toHaveTextContent(/title/i)
  })
})
