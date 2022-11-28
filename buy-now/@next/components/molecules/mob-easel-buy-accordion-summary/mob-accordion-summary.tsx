import { AccordionSummary, Box, Typography } from '@mui/material'
import { FC } from 'react'
import Image from 'next/image'

interface MobOwnershipAccordionProps {
  expanded: string | false
  accordionId: string
  title: string
  icon: string
}

export const MobOwnershipAccordionSummary: FC<MobOwnershipAccordionProps> = ({
  expanded,
  accordionId,
  title,
  icon
}) => {
  return (
    <AccordionSummary
      expandIcon={
        expanded === accordionId ? (
          <Image src="/images/minimize.svg" width="20px" height="20px" />
        ) : (
          <Image src="/images/expand.svg" width="20px" height="20px" />
        )
      }
      aria-controls="panel1a-content"
      id="panel1a-header"
      sx={{
        background: 'transparent',
        padding: '0px !important'
      }}
      data-testid="mobOwnershipAccordionSummary-molecule"
    >
      <Box
        sx={{
          position: 'relative',
          display: 'flex',
          flexDirection: 'column',
          paddingTop: '10px'
        }}
      >
        <Box
          sx={{
            display: 'flex',
            minWidth: '150px',
            justifyContent: 'flex-start'
          }}
        >
          <Typography
            sx={{
              fontSize: '16px',
              color: '#fff',
              paddingRight: '35px',
              fontWeight: '400',
              width: '7.25rem'
            }}
          >
            {title}
          </Typography>
          <Image
            height={20}
            width={20}
            src={`/images/${icon}.svg`}
            style={{
              margin: '0 3rem 0 0'
            }}
          />
        </Box>
        <Box
          sx={{
            position: 'absolute',
            bottom: '-15px',
            width: '100%'
          }}
        >
          <Image src="/images/line.svg" height="24px" width="176px" />
        </Box>
      </Box>
    </AccordionSummary>
  )
}
