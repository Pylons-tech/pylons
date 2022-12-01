import { AccordionSummary, Box, Typography } from '@mui/material'
import { FC } from 'react'
import Image from 'next/image'

interface MobOwnershipAccordionProps {
  expanded: string | false
  accordionId: string
  title: string
  icon: string
}

export const WebOwnershipAccordionSummary: FC<MobOwnershipAccordionProps> = ({
  expanded,
  title,
  icon,
  accordionId
}) => {
  return (
    <AccordionSummary
      expandIcon={
        expanded === accordionId ? (
          <Image
            alt="minimize"
            width={27}
            height={27}
            src="/images/minimize.svg"
          />
        ) : (
          <Image alt="expand" width={27} height={27} src="/images/expand.svg" />
        )
      }
      aria-controls="panel1a-content"
      id="panel1a-header"
      data-testid="webOwnershipAccordionSummary-molecule"
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
            minWidth: '200px',
            justifyContent: 'flex-start'
          }}
        >
          <Typography
            sx={{
              fontSize: '25px',
              color: '#fff',
              paddingRight: '25px',
              fontWeight: '500',
              width: '9.25rem'
            }}
          >
            {title}
          </Typography>
          <Image
            height={30}
            width={30}
            alt={icon}
            src={`/images/${icon}.svg`}
            style={{ display: 'block', margin: '0 3rem 0 0' }}
          />
        </Box>
        <Box
          sx={{
            position: 'absolute',
            bottom: '-15px',
            width: '100%'
          }}
        >
          <Image alt="line" width={208} height={24} src="/images/line.svg" />
        </Box>
      </Box>
    </AccordionSummary>
  )
}
