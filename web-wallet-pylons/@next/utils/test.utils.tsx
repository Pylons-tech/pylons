import {
  render,
  queries,
  RenderOptions,
  RenderResult
} from '@testing-library/react'
import { ReactElement } from 'react'
import { Provider } from 'react-redux'
import { ThemeProvider } from '@mui/material/styles'
import { createStore } from '@store'
import { MUITheme } from '@styles'
/**
 * customRender
 *
 * Features:
 * - extends the render function to add common providers.
 *
 */
const CustomRender = (
  ui: ReactElement & { getLayout?: (page: JSX.Element) => JSX.Element },
  options?: Omit<RenderOptions, 'queries'> & {
    /**
     * Adds the user to the store before rendering the component
     */
    withUser?: boolean
    /**
     * whether to connect with the socket or not.
     */
    connectWithSocket?: boolean
  }
): RenderResult & { store: ReturnType<any> } => {
  const store = createStore

  // For example testing the user panel the user must be loggedIn. Hence this option will let us add the user beforehand.

  const getLayout = ui.getLayout ?? ((page) => page)
  const renderResult = render(
    <Provider {...{ store }}>
      <ThemeProvider theme={MUITheme}>{getLayout(ui)}</ThemeProvider>
    </Provider>,
    {
      queries: { ...queries },
      ...options
    }
  )
  return { ...renderResult, store }
}

export * from '@testing-library/react'
export { CustomRender }
