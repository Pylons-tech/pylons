import { cleanup, CustomRender, screen } from 'test-utils'
import { HistoryDetails } from './history-details'

const props = {
  history: ['item 1', 'item 2', 'item 3']
}

afterEach(cleanup)

const setup = (): any => {
  CustomRender(<HistoryDetails {...props} />)
  const historyDetails = screen.getByTestId('historyDetails-molecule')
  return { historyDetails }
}

describe('<HistoryDetails />', () => {
  it('Should Render HistoryDetails', async () => {
    const { historyDetails } = setup()
    expect(historyDetails).toBeInTheDocument()
  })
})
