import { Box, Typography } from '@mui/material'
import { FC } from 'react'

interface NftDetailsPropTypes {
  recipeId: string
}

export const NftDetails: FC<NftDetailsPropTypes> = ({ recipeId }) => {
  return (
    <Box
      sx={{
        width: '100%'
      }}
      data-testid="nftDetails-molecule"
    >
      <div className="tab-panel">
        <div className="item">
          <p>Recipe Id</p>
          <Typography color="#ef4727" style={{ color: '#ef4727 !important' }}>
            {recipeId}
          </Typography>
        </div>
        <div className="item">
          <p>Blockchain</p>
          <p>Pylons</p>
        </div>
        <div className="item">
          <p>Permission</p>
          <p>Exclusive</p>
        </div>
      </div>
    </Box>
  )
}
