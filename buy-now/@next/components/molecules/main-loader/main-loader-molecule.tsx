import { Box, CircularProgress } from '@mui/material'
export const MainLoader = (): JSX.Element => {
  return (
    <Box
      sx={{
        display: 'flex',
        width: '100%',
        height: '100vh',
        bgcolor: '#fff',
        justifyContent: 'center',
        alignItems: 'center'
      }}
      data-testid="mainLoader-molecule"
    >
      <CircularProgress />
    </Box>
  )
}
