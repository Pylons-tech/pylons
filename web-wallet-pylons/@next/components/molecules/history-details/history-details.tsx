import { Box } from '@mui/material'
import moment from 'moment'
import { FC } from 'react'

interface HistoryDetailsTypes {
  history: any[]
}

export const HistoryDetails: FC<HistoryDetailsTypes> = ({ history }) => {
  return (
    <Box
      sx={{
        minWidth: '300px'
      }}
    >
      <div className="tab-panel" data-testid="historyDetails-molecule">
        {history?.map((val, i) => (
          <div className="item" key={i}>
            <p>{moment(val.createdAt).format('DD/MM/YYYY hh:mm:ss')}</p>
            <p>{val.sender_name}</p>
          </div>
        ))}
      </div>
    </Box>
  )
}
