import '../styles/global.css'
import type { AppProps } from 'next/app'
import { FC } from 'react'

import { PersistGate } from 'redux-persist/integration/react'
import { createStore } from '@store'
import { Provider } from 'react-redux'
import { persistStore } from 'redux-persist'

import type { Page } from '@types'

import { MainLayout } from '@layouts'

type Props = AppProps & {
  Component: Page
}
const store = createStore
const persistor = persistStore(store)

const MyApp: FC<Props> = ({ Component, pageProps }) => {
  const getLayout = Component.getLayout ?? ((page) => page)
  return (
    <Provider {...{ store }}>
      <PersistGate loading={null} persistor={persistor}>
        {() => (
          <MainLayout>{getLayout(<Component {...pageProps} />)}</MainLayout>
        )}
      </PersistGate>
    </Provider>
  )
}
export default MyApp
