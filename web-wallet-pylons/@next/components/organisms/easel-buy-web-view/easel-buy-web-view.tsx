import Typography from '@mui/material/Typography'
import { Box } from '@mui/system'
import React, { FC, useState } from 'react'
import Accordion from '@mui/material/Accordion'
import AccordionDetails from '@mui/material/AccordionDetails'
import Grid from '@mui/material/Grid'
import Image from 'next/image'
import moment from 'moment'

import settings from '../../../../settings.json'

import {
  HistoryDetails,
  MediaSet,
  NftDetails,
  OwnershipDetails,
  WebOwnershipAccordionSummary
} from '@molecules'
import { ToggleText } from '@atoms'
import { BuyBtn, Container, MediaPart } from './easel-buy.styles'
import { getCryptoCurrencyIcon } from '@utils'

const descriptionLength = 50

const handleLoginConfirmed = (): void => {
  const { apn, ibi, isi, oflIOS, oflPlay } = settings?.public?.dynamicLink
  const isMacLike = /(Mac|iPhone|iPod|iPad)/i.test(navigator.platform)
  let ofl = oflPlay
  if (isMacLike) {
    ofl = oflIOS
  }
  ofl = encodeURIComponent(ofl)
  const baseURL = `https://pylons.page.link/?amv=1&apn=${apn}&ibi=${ibi}&imv=1&efr=1&isi=${isi}&`
  window.location.href = `${baseURL}ofl=${ofl}&link=${encodeURIComponent(
    window.location.href
  )}`
}
interface EaselWebMobViewTypes {
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
}
export const EaselBuyWebView: FC<EaselWebMobViewTypes> = ({
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
  src
}) => {
  // eslint-disable-next-line @typescript-eslint/naming-convention
  const [expanded, setExpanded] = useState<string | false>(false)
  const [showMore, setShowMore] = useState<boolean>(false)

  const handleChange =
    (panel: string) => (event: React.SyntheticEvent, isExpanded: boolean) => {
      setExpanded(isExpanded ? panel : false)
    }

  return (
    <Container>
      <Grid container data-testid="easelBuyWebView-molecule">
        <Grid item xl={6} lg={6} md={6} sm={12} xs={12}>
          <Box
            sx={{
              display: {
                xl: 'block',
                lg: 'block',
                md: 'block',
                sm: 'block',
                xs: 'none'
              }
            }}
          >
            <MediaPart>
              <Image
                src="/images/frame.png"
                width="400px"
                height="720px"
                alt="Frame"
                className="mob-frame"
              />
              {/* <div className="img-inner"> */}
              <MediaSet nftType={nftType} source={media} src={src} />
              {/* </div> */}
            </MediaPart>
          </Box>
        </Grid>
        <Grid item xl={6} lg={6} md={6} sm={12} xs={12}>
          <Box
            sx={{
              display: {
                xl: 'block',
                lg: 'block',
                md: 'block',
                sm: 'block',
                xs: 'none'
              }
            }}
          >
            <Typography
              sx={{
                fontWeight: '600',
                fontSize: '50px'
              }}
            >
              {name}
            </Typography>
            <Box
              sx={{
                display: 'flex',
                flexDirection: 'row',
                alignItems: 'center',
                margin: '0 0 1.5rem'
              }}
            >
              <Typography
                sx={{
                  fontSize: '25px',
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
                {createdBy}
              </Typography>
              <Image
                src="/images/check.svg"
                height="16px"
                width="16px"
                alt="check"
              />
            </Box>

            <Box
              sx={{
                margin: '5rem 0'
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
                display: 'flex',
                width: '350px',
                flexDirection: 'column'
              }}
            >
              <Accordion
                expanded={expanded === 'panel1'}
                onChange={handleChange('panel1')}
                data-testid="easelBuyWebViewAccordion1-organism"
                sx={{
                  background: 'transparent',
                  padding: '0px !important'
                }}
              >
                <WebOwnershipAccordionSummary
                  expanded={expanded}
                  accordionId="panel1"
                  title="Ownership"
                  icon="trophy"
                />
                <AccordionDetails>
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
                        ? moment.unix(+createdAt).format('MM/DD/YYYY hh:mm:ss')
                        : ''
                    }
                  />
                </AccordionDetails>
              </Accordion>

              <Accordion
                expanded={expanded === 'panel2'}
                onChange={handleChange('panel2')}
                data-testid="easelBuyWebViewAccordion2-organism"
                sx={{
                  background: 'transparent'
                }}
              >
                <WebOwnershipAccordionSummary
                  expanded={expanded}
                  accordionId="panel2"
                  title="NFT Detail"
                  icon="detail"
                />
                <AccordionDetails>
                  <NftDetails recipeId={recipeId} />
                </AccordionDetails>
              </Accordion>

              <Accordion
                expanded={expanded === 'panel3'}
                onChange={handleChange('panel3')}
                data-testid="easelBuyWebViewAccordion3-organism"
                sx={{
                  background: 'transparent'
                }}
              >
                <WebOwnershipAccordionSummary
                  accordionId="panel3"
                  expanded={expanded}
                  title="History"
                  icon="history"
                />
                <AccordionDetails>
                  <HistoryDetails history={history} />
                </AccordionDetails>
              </Accordion>
            </Box>

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
                      width="30px"
                      height="29px"
                    />
                  ) : null}
                </div>
                <div
                  className="value-icon"
                  onClick={handleLoginConfirmed}
                  data-testid="easelBuyWebViewButtonBuy-organism"
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
        </Grid>
      </Grid>
    </Container>
  )
}
