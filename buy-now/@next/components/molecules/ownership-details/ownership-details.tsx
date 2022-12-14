import { Box } from '@mui/material'
import { FC } from 'react'

interface OwnershipDetailsPropTypes {
  owner: string
  edition: string
  royalty: string
  dimensions: string
  createdAt: string
}

export const OwnershipDetails: FC<OwnershipDetailsPropTypes> = ({
  owner,
  edition,
  royalty,
  dimensions,
  createdAt
}) => {
  return (
    <Box
      sx={{
        width: '100%'
      }}
      data-testid="ownerShipDetails-molecule"
    >
      <div className="tab-panel">
        <div className="item">
          <p>Owned by</p>
          <p>{owner}</p>
        </div>
        <div className="item">
          <p>Edition</p>
          <p>{edition}</p>
        </div>
        <div className="item">
          <p>Royalty</p>
          <p>{royalty}</p>
        </div>
        <div className="item">
          <p>Size</p>
          <p>{dimensions}</p>
        </div>
        <div className="item">
          <p>Creation Date</p>
          <p>{createdAt}</p>
        </div>
      </div>
    </Box>
  )
}
