import Typography from '@mui/material/Typography'
import { Box } from '@mui/system'
import Link from 'next/link'
import React, { FC, useState } from 'react'
import Accordion from '@mui/material/Accordion'
import AccordionDetails from '@mui/material/AccordionDetails'
import ExpandLessIcon from '@mui/icons-material/ExpandLess'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'

import {
  BuyBtn,
  CollapseBtn,
  MediaPart,
  MobileContainer
} from './easel-buy.styles'
import Image from 'next/image'
import { Button } from '@mui/material'
import {
  HistoryDetails,
  MediaSet,
  MobOwnershipAccordionSummary,
  NftDetails,
  OwnershipDetails
} from '@molecules'
import moment from 'moment'
import { ToggleText } from '@atoms'
import { getCryptoCurrencyIcon } from '@utils'

interface EaselBuyMobViewTypes {
  history: any[]
  createdBy: string
  name: string
  description: string
  price: string
  denom: string
  nftType: string
  dimensions: string
  royalty: string
  edition: string
  media: string
  createdAt: string
  recipeId: string
  src: string
  handleLoginConfirmed: () => void
}

const descriptionLength = 50

export const EaselBuyMobView: FC<EaselBuyMobViewTypes> = ({
  history,
  createdBy,
  name,
  description,
  price,
  denom,
  nftType,
  dimensions,
  royalty,
  edition,
  media,
  createdAt,
  recipeId,
  src,
  handleLoginConfirmed
}) => {
  const [collapse, setCollapse] = useState(false)
  const [showMore, setShowMore] = useState<boolean>(false)
  const handleChange =
    (panel: string) => (event: React.SyntheticEvent, isExpanded: boolean) => {
      setExpanded(isExpanded ? panel : false)
    }

  const collapseExpand = (): void => {
    setCollapse(!collapse)
  }

  const [expanded, setExpanded] = useState<string | false>(false)

  return (
    <Box
      sx={{
        display: {
          xl: 'none',
          lg: 'none',
          md: 'none',
          sm: 'none',
          xs: 'block'
        }
      }}
      data-testid="easelBuyMobView-molecule"
    >
      <MobileContainer>
        <MediaPart>
          <MediaSet nftType={nftType} source={media} src={src} />
        </MediaPart>
        <Box
          sx={{
            alignItems: 'flex-end',
            backgroundColor: '#000',
            bottom: '0',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'flex-end',
            padding: '1.5rem 0.5rem 0.5rem',
            position: 'absolute',
            width: '100%'
          }}
          className={collapse ? 'bg2' : 'bg'}
        >
          <Box
            sx={{
              alignItems: 'flex-start',
              display: 'flex',
              flexDirection: 'column',
              position: 'relative',
              width: '100%'
            }}
          >
            <CollapseBtn>
              {collapse ? (
                <Button
                  onClick={collapseExpand}
                  className="collapsebg"
                  data-testid="easelBuyMobViewButton1-molecule"
                >
                  <ExpandMoreIcon />
                </Button>
              ) : (
                <Button
                  onClick={collapseExpand}
                  className="simple"
                  data-testid="easelBuyMobViewButton2-molecule"
                >
                  <ExpandLessIcon />
                </Button>
              )}
            </CollapseBtn>
            <Typography
              sx={{
                fontWeight: '600',
                fontSize: '25px'
              }}
            >
              {name}
            </Typography>
            <Box
              sx={{
                display: 'flex',
                flexDirection: 'row',
                alignItems: 'center',
                margin: '0 0 0.5rem'
              }}
            >
              <Typography
                sx={{
                  fontSize: '20px',
                  paddingRight: '10px'
                }}
              >
                Created by
              </Typography>
              <Typography
                sx={{
                  fontSize: '25px',
                  color: 'common.lightPurple',
                  paddingRight: '5px'
                }}
              >
                <Link href="google.com">{createdBy}</Link>
              </Typography>
              <Image
                src="/images/check.svg"
                height={16}
                width={16}
                alt="check"
              />
            </Box>
          </Box>
          {collapse ? (
            <Box
              sx={{
                alignItems: 'flex-start',
                display: 'flex',
                width: '100%',
                flexDirection: 'column',
                zIndex: '1'
              }}
            >
              <Box
                sx={{
                  margin: '0'
                }}
              >
                <ToggleText
                  text={description}
                  showText={showMore}
                  length={descriptionLength}
                />
                {description.length > descriptionLength ? (
                  <Typography
                    sx={{
                      fontSize: '25px',
                      color: 'common.lightPurple',
                      paddingRight: '5px'
                    }}
                    onClick={() => setShowMore((val) => !val)}
                  >
                    {!showMore && description.length > descriptionLength
                      ? 'read more'
                      : 'show less'}
                  </Typography>
                ) : null}
              </Box>
              <Box
                sx={{
                  maxHeight: '40vh',
                  overflowY: 'auto',
                  width: '100%'
                }}
              >
                <Accordion
                  expanded={expanded === 'panel1'}
                  onChange={handleChange('panel1')}
                  sx={{
                    background: 'transparent',
                    boxShadow: 'none',
                    padding: '0px !important',
                    width: '18rem'
                  }}
                >
                  <MobOwnershipAccordionSummary
                    expanded={expanded}
                    accordionId="panel1"
                    title="Ownership"
                    icon="trophy"
                  />
                  <AccordionDetails
                    sx={{
                      padding: '0 !important'
                    }}
                  >
                    <OwnershipDetails
                      owner={
                        history?.length
                          ? history[history.length - 1].sender_name
                          : createdBy
                      }
                      edition={edition}
                      royalty={royalty}
                      dimensions={dimensions}
                      createdAt={
                        createdAt
                          ? moment
                              .unix(+createdAt)
                              .format('MM/DD/YYYY hh:mm:ss')
                          : ''
                      }
                    />
                  </AccordionDetails>
                </Accordion>
                <Accordion
                  expanded={expanded === 'panel2'}
                  onChange={handleChange('panel2')}
                  sx={{
                    background: 'transparent',
                    boxShadow: 'none',
                    width: '18rem'
                  }}
                >
                  <MobOwnershipAccordionSummary
                    expanded={expanded}
                    accordionId="panel2"
                    title="NFT Detail"
                    icon="detail"
                  />
                  <AccordionDetails
                    sx={{
                      padding: '0 !important'
                    }}
                  >
                    <NftDetails recipeId={recipeId} />
                  </AccordionDetails>
                </Accordion>
                <Accordion
                  expanded={expanded === 'panel3'}
                  onChange={handleChange('panel3')}
                  sx={{
                    background: 'transparent',
                    boxShadow: 'none',
                    width: '18rem'
                  }}
                >
                  <MobOwnershipAccordionSummary
                    expanded={expanded}
                    accordionId="panel3"
                    title="History"
                    icon="history"
                  />
                  <AccordionDetails
                    sx={{
                      padding: '0 !important'
                    }}
                  >
                    <HistoryDetails history={history} />
                  </AccordionDetails>
                </Accordion>
              </Box>
            </Box>
          ) : null}
          <BuyBtn>
            <button>
              <Image
                layout="fill"
                alt="bg"
                src="/images/btnbg.png"
                className="btnbg"
              />
              <div className="icon">
                {getCryptoCurrencyIcon(denom) ? (
                  <Image
                    alt="coin"
                    src={getCryptoCurrencyIcon(denom)}
                    width={30}
                    height={29}
                  />
                ) : null}
              </div>
              <div
                className="value-icon"
                onClick={handleLoginConfirmed}
                data-testid="easelBuyMobViewButtonBuy-organism"
              >
                <div className="values">
                  <p>
                    Buy for{' '}
                    {price === undefined || price === 'undefined undefined'
                      ? 'Free'
                      : price}
                  </p>
                </div>
              </div>
            </button>
          </BuyBtn>
        </Box>
      </MobileContainer>
    </Box>
  )
}
