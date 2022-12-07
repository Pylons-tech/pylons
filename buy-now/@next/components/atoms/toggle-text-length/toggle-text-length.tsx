import { Typography } from '@mui/material'
import { FC } from 'react'

interface DescriptionPropTypes {
  text: string
  showText: boolean
  length: number
}

export const ToggleText: FC<DescriptionPropTypes> = ({
  text,
  showText,
  length
}) => {
  return (
    <Typography
      sx={{
        fontWeight: '600',
        fontSize: '25px'
      }}
      data-testid="toggleText-atom"
    >
      {showText || text.length < length ? text : text.substring(0, 47) + '...'}
    </Typography>
  )
}
