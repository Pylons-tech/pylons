import { MetaTags } from '@molecules'
import { Box } from '@mui/material'
import { FC, useEffect, useState } from 'react'
import useMediaQuery from '@mui/material/useMediaQuery'
import _ from 'lodash'

import { EaselBuyWebView, EaselBuyMobView } from '@organisms'
import settings from './../../../settings.json'
import { getRecipeHistory } from '@ApiReq'
import { useRouter } from 'next/router'
import { AUDIO, getNFTDimensions, NFTURL, PDF, THUMBNAILURL } from '@utils'

interface ObjectGenericType {
  [key: string]: any
}

export const EaselBuy: FC<any> = ({ recipeDetails }) => {
  const matches = useMediaQuery('(min-width:600px)')
  const router: any = useRouter()

  // eslint-disable-next-line @typescript-eslint/naming-convention
  const { cookbook_id, recipe_id } = router?.query
  const [history, setHistory] = useState<any[]>([])
  const [createdBy, setCreatedBy] = useState<string>('')
  const [thumbnail, setThumbnail] = useState<string>('')
  const [name, setName] = useState<string>('')
  const [description, setDescription] = useState<string>('')
  const [price, setPrice] = useState<string>('')
  const [denom, setDenom] = useState<string>('')
  const [nftType, setNftType] = useState<string>('')
  const [dimensions, setDimensions] = useState<string>('')
  const [royalty, setRoyalty] = useState<string>('')
  const [edition, setEdition] = useState<string>('')
  const [media, setMedia] = useState<string>('')
  const [createdAt, setCreatedAt] = useState<string>('')
  const [recipeId, setRecipeId] = useState<string>('')
  const [src, setSrc] = useState<string>('')
  useEffect(() => {
    if (router.isReady) {
      handleFetchhistory()
    }
  }, [router.isReady, cookbook_id, recipe_id])
  useEffect(() => {
    handleFetchData()
  }, [recipeDetails])

  const handleFetchData = (): void => {
    let media
    let coin: any
    let price
    let denom
    let src
    let thumbnailNFT
    const tradePercent = 100
    const res = _.cloneDeep(recipeDetails)
    const selectedRecipe = _.cloneDeep(res?.recipe)
    const itemOutputs = _.cloneDeep(selectedRecipe?.entries?.item_outputs[0])
    const strings = _.cloneDeep(itemOutputs?.strings)
    const coinInputs = [...selectedRecipe?.coin_inputs]

    /* istanbul ignore next */
    if (coinInputs?.length > 0) {
      const resCoins: any = coinInputs[0]?.coins[0]
      denom = resCoins.denom
      if (resCoins?.denom === 'USD') {
        price = `${Math.floor(resCoins.amount / 100)}.${
          resCoins.amount % 100
        } USD`
      } else {
        const coins: any[] = settings.public.coins
        coin = coins.length
          ? coins.find(
              (coin) =>
                coin?.denom?.toLowerCase() === resCoins?.denom?.toLowerCase()
            )
          : null
        if (coin) {
          const displayName: string = coin?.displayName ?? ''
          price = `${resCoins.amount / coin.fraction} ${displayName}`
        } else {
          const amount: string = resCoins?.amount
          const denom: string = resCoins?.denom
          price = `${amount} ${denom}`
        }
      }
    }

    /* istanbul ignore next */
    const entries = _.cloneDeep(selectedRecipe.entries)
    /* istanbul ignore next */
    const nftType = strings.find(
      (val: ObjectGenericType) => val?.key.toLowerCase() === 'nft_format'
    )?.value
    /* istanbul ignore next */
    if (entries != null) {
      // eslint-disable-next-line @typescript-eslint/no-unused-expressions
      thumbnailNFT = strings.find(
        (val: ObjectGenericType) => val?.key === THUMBNAILURL
      ).value
      if (nftType.toLowerCase() === AUDIO) {
        const mediaUrl = strings.find(
          (val: ObjectGenericType) => val?.key === THUMBNAILURL
        )
        media = mediaUrl ? mediaUrl?.value : ''
        const srcUrl = strings.find(
          (val: ObjectGenericType) => val?.key === NFTURL
        )
        src = srcUrl ? srcUrl.value : ''
        setSrc(src)
      } else if (nftType.toLowerCase() === PDF) {
        const mediaUrl = strings.find(
          (val: ObjectGenericType) => val?.key === THUMBNAILURL
        )
        media = mediaUrl ? mediaUrl?.value : ''
      } else {
        const mediaUrl = strings.find(
          (val: ObjectGenericType) => val?.key === NFTURL
        )
        media = mediaUrl ? mediaUrl?.value : ''
      }
    }

    /* istanbul ignore next */
    const creator = strings.find(
      (val: any) => val?.key.toLowerCase() === 'creator'
    )?.value

    /* istanbul ignore next */
    const dimentions = getNFTDimensions(nftType, itemOutputs)
    /* istanbul ignore next */
    const amountMinted: string = itemOutputs?.amount_minted
    /* istanbul ignore next */
    const quantity: string = itemOutputs?.Quantity
    /* istanbul ignore next */
    const edition = `${amountMinted} of ${quantity}`
    /* istanbul ignore next */
    if (thumbnailNFT) {
      setThumbnail(thumbnailNFT)
    } else {
      setThumbnail(media)
    }
    /* istanbul ignore next */
    setCreatedBy(creator)
    /* istanbul ignore next */
    setName(selectedRecipe?.name)
    /* istanbul ignore next */
    setDescription(selectedRecipe?.description)
    /* istanbul ignore next */
    setPrice(price ?? '')
    /* istanbul ignore next */
    setDenom(denom)
    /* istanbul ignore next */
    setNftType(nftType)
    /* istanbul ignore next */
    setDimensions(dimentions)
    // setDisplayName(coin?.displayName)
    /* istanbul ignore next */
    setRoyalty((+itemOutputs?.trade_percentage * tradePercent)?.toString())
    /* istanbul ignore next */
    setEdition(edition)
    /* istanbul ignore next */
    setMedia(media)
    /* istanbul ignore next */
    setCreatedAt(selectedRecipe?.created_at)
    /* istanbul ignore next */
    setRecipeId(selectedRecipe?.id)
    /* istanbul ignore next */
    setSrc(src)
  }
  const handleFetchhistory = (): void => {
    void getRecipeHistory(cookbook_id, recipe_id).then((res: any) => {
      setHistory(res?.data?.history)
    })
  }
  const data = {
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
  }
  return (
    <Box data-testid="easelBuy-page">
      <MetaTags {...data} thumbnail={thumbnail} />
      <Box
        sx={{
          backgroundImage: {
            xl: 'url("/images/buybg.png")',
            lg: 'url("/images/buybg.png")',
            md: 'url("/images/buybg.png")',
            sm: 'url("/images/buybg.png")',
            xs: 'none'
          },
          backgroundColor: {
            xl: '#000',
            lg: '#000',
            md: '#000',
            sm: '#000',
            xs: '#000'
          },
          backgroundSize: '230px 230px',
          backgroundPosition: 'left',
          width: '100%',
          color: 'white',
          minHeight: {
            xl: '100vh',
            lg: '100vh',
            md: '100vh',
            sm: '100vh',
            xs: '100%'
          },
          padding: {
            xl: '5rem 0',
            lg: '5rem 0',
            md: '5rem 0',
            sm: '5rem 0',
            xs: '0'
          }
        }}
      >
        {matches ? (
          <EaselBuyWebView {...data} />
        ) : (
          <EaselBuyMobView {...data} />
        )}
      </Box>
    </Box>
  )
}
