import { cleanup, CustomRender, screen } from 'test-utils'
import { MobOwnershipAccordionSummary } from './mob-accordion-summary'

const props = {
  expanded: 'id',
  accordionId: 'id',
  title: 'Title',
  icon: 'icon'
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<MobOwnershipAccordionSummary {...props} />)
  const mobOwnershipAccordionSummary = screen.getByTestId(
    'mobOwnershipAccordionSummary-molecule'
  )
  return { mobOwnershipAccordionSummary }
}

describe('<MobOwnershipAccordionSummary />', () => {
  it('Should Render MobOwnershipAccordionSummary', async () => {
    const { mobOwnershipAccordionSummary } = setup()
    expect(mobOwnershipAccordionSummary).toBeInTheDocument()
  })
})
