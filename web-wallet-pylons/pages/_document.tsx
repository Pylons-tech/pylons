import { FC } from 'react'
import { Html, Head, Main, NextScript } from 'next/document'
import Script from 'next/script'

interface Props {
  __NEXT_DATA__: any
}
const Document: FC<Props> = () => {
  return (
    <Html>
      <Head>
        <Script
          type="module"
          src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"
        ></Script>
      </Head>
      <body>
        <Main />
        <NextScript />
      </body>
    </Html>
  )
}

export default Document
