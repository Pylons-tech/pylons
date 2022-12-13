import { Card, CardMedia, CardActionArea } from '@mui/material'
import { Props } from './tabs.types'

export const Tabs = ({
  type,
  src,
  title,
  height = '100%',
  width = '100%',
  maxWidth = 150
}: Props): JSX.Element => {
  return (
    <Card style={{ width: maxWidth }} data-testid="tabs-atom">
      <CardActionArea>
        {type === 'image' ? (
          <CardMedia
            component="img"
            image={src}
            height={height}
            width={width}
            title={title}
          />
        ) : (
          <CardMedia
            component="video"
            src={src}
            title={title}
            controls
            height={height}
            width={width}
          />
        )}
      </CardActionArea>
    </Card>
  )
}
