import React, { useState } from 'react'
import { MainLoader } from '@molecules'
import { MUITheme } from '@styles'
import { ThemeProvider } from '@mui/material/styles'

export const MainLayout = ({
  children
}: {
  children: React.ReactNode
}): JSX.Element => {
  const [loading] = useState(false)

  if (loading) {
    return <MainLoader />
  }
  return <ThemeProvider theme={MUITheme}>{children}</ThemeProvider>
}
