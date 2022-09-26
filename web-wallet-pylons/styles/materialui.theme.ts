/* eslint-disable no-unused-vars */
import { createTheme } from '@mui/material/styles'

// Create a theme instance.
declare module '@mui/material/styles' {
  // allow configuration using `createTheme`
  interface ThemeOptions {
    status?: {
      danger?: string
    }
  }

  interface BreakpointOverrides {
    xs: true
    sm: true
    md: true
    lg: true
    xl: true
    mdCustom: true
  }
}

declare module '@mui/material/styles/createPalette' {
  interface CommonColors {
    darkBlack: string
    orange: string
    darkBlue: string
    lightOrange: string
    darkOrange: string
    oceanBlue: string
    purple: string
    red: string
    green: string
    black: string
    white: string
    icon: string
    lightBlue: string
    gradient: string
    dottedBorder: string
    searchFieldColor: string
    assetStatusRed: string
    lightBlack: string
    label: String
  }
}
declare module '@mui/material/styles/createTheme' {
  interface Theme {
    shape: {
      borderRadius: number
    }
  }
  interface ThemeOptions {
    shape?: {
      borderRadius?: number
    }
  }
}
export const MUITheme = createTheme({
  breakpoints: {
    values: {
      xs: 0,
      sm: 600,
      md: 900,
      lg: 1200,
      xl: 1536,
      mdCustom: 968
    }
  },

  palette: {
    primary: {
      main: '#0292CC',
      // light: `#0667EB`,
      dark: '#0292CC'
    },
    common: {
      lightBlue: '#F6F9FA',
      darkBlack: '#000',
      orange: '#FAB817',
      darkBlue: '#3E519E',
      lightOrange: '#FFEBB9',
      oceanBlue: '#00D1FF',
      darkOrange: '#F18621',
      purple: '#8674F5',
      red: '#FF4950',
      green: '#17D85C',
      black: '#181C25',
      white: '#FFF',
      icon: '#979797',
      dottedBorder: '#E4ECF7',
      searchFieldColor: '#EDF2F7',
      assetStatusRed: '#D1373F',
      lightBlack: '#425466',
      label: '#898A8D'
    },
    success: {
      main: '#17D85C'
    },
    error: {
      main: '#FF4444'
    },
    secondary: {
      main: '#FFFFFF'
    },
    grey: {
      900: '#181C25',
      800: '#949494',
      700: '#B5B5B5',
      600: '#D7D7D7',
      500: '#F2F2F2',
      400: '#F9F9F9',
      300: '#8992A9'
    },
    text: {
      primary: '#000',
      secondary: '#8492A6'
    },
    action: {
      disabled: '#fff',
      disabledBackground: '#ABE7FF'
    }
  },
  shadows: [
    'none',
    '0px 1px 3px rgba(0, 0, 0, 0.1)',
    createTheme({}).shadows[2],
    createTheme({}).shadows[3],
    createTheme({}).shadows[4],
    createTheme({}).shadows[5],
    createTheme({}).shadows[6],
    createTheme({}).shadows[7],
    createTheme({}).shadows[8],
    createTheme({}).shadows[9],
    createTheme({}).shadows[10],
    createTheme({}).shadows[11],
    createTheme({}).shadows[12],
    createTheme({}).shadows[13],
    createTheme({}).shadows[14],
    createTheme({}).shadows[15],
    createTheme({}).shadows[16],
    createTheme({}).shadows[17],
    createTheme({}).shadows[18],
    createTheme({}).shadows[19],
    createTheme({}).shadows[20],
    createTheme({}).shadows[21],
    createTheme({}).shadows[22],
    createTheme({}).shadows[23],
    createTheme({}).shadows[24]
  ],
  shape: {
    borderRadius: 6
  },
  typography: {
    fontFamily: 'Inter',
    h1: {
      fontWeight: 700,
      fontSize: '1.625rem' // 26px
    },
    h2: {
      fontWeight: 500,
      fontSize: '1.5rem' // 24px
    },
    h3: {
      fontWeight: 600,
      fontSize: '1.25rem' // 20px
    },
    h4: {
      fontWeight: 500,
      fontSize: '0.938rem' // 14px
    },
    h5: {
      fontWeight: 600,
      fontSize: '0.875rem' // 14px
    },
    h6: {
      fontWeight: 600,
      fontSize: '14px' // 16px
    },
    subtitle1: {
      fontWeight: 700,
      fontSize: '0.75rem' // 12px
    },
    subtitle2: {
      fontWeight: 400,
      fontSize: '0.938rem' // 14px
    },
    caption: {
      fontWeight: 400,
      fontSize: '0.813rem' // 13px
    },
    button: {
      textTransform: 'none',
      fontWeight: 600,
      fontSize: '0.875rem' // 14 px
    }
  }
})
