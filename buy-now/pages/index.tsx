import { MetaTags } from "@molecules";
import { Box } from "@mui/material";
import _ from "lodash";
import getConfig from "next/config";
import { EaselBuy } from "../@next/pages";
import { HOMEPAGE_URL } from "../constants";
import { AUDIO, getNFTDimensions, NFTURL, PDF, THUMBNAILURL } from "@utils";
const { publicRuntimeConfig } = getConfig();
interface EaselBuyMainPageTypes {
  recipeDetails: any;
}

interface ObjectGenericType {
  [key: string]: any;
}

export default function EaselBuyMainPage({
  recipeDetails,
}: EaselBuyMainPageTypes): JSX.Element {
  const { settings } = publicRuntimeConfig;

  let media;
  let coin: any;
  let price;
  let denom;
  let src;
  let thumbnailNFT;
  const tradePercent = 100;
  const res = _.cloneDeep(recipeDetails);
  const selectedRecipe = _.cloneDeep(res?.recipe);
  const itemOutputs = _.cloneDeep(selectedRecipe?.entries?.item_outputs[0]);
  const strings = _.cloneDeep(itemOutputs?.strings);
  const coinInputs = [...selectedRecipe?.coin_inputs];

  /* istanbul ignore next */
  if (coinInputs?.length > 0) {
    const resCoins: any = coinInputs[0]?.coins[0];
    denom = resCoins.denom;
    if (resCoins?.denom === "USD") {
      price = `${Math.floor(resCoins.amount / 100)}.${resCoins.amount % 100
        } USD`;
    } else {
      const coins: any[] = settings?.public?.coins;
      coin = coins?.length
        ? coins.find(
          (coin) =>
            coin?.denom?.toLowerCase() === resCoins?.denom?.toLowerCase()
        )
        : null;
      if (coin) {
        const displayName: string = coin?.displayName ?? "";
        price = `${resCoins.amount / coin.fraction} ${displayName}`;
      } else {
        const amount: string = resCoins?.amount;
        const denom: string = resCoins?.denom;
        price = `${amount} ${denom}`;
      }
    }
  }

  /* istanbul ignore next */
  const entries = _.cloneDeep(selectedRecipe.entries);
  /* istanbul ignore next */
  const nftType = strings.find(
    (val: ObjectGenericType) => val?.key.toLowerCase() === "nft_format"
  )?.value;
  /* istanbul ignore next */
  if (entries != null) {
    // eslint-disable-next-line @typescript-eslint/no-unused-expressions
    thumbnailNFT = strings.find(
      (val: ObjectGenericType) => val?.key === THUMBNAILURL
    ).value;
    if (nftType.toLowerCase() === AUDIO) {
      const mediaUrl = strings.find(
        (val: ObjectGenericType) => val?.key === THUMBNAILURL
      );
      media = mediaUrl ? mediaUrl?.value : "";
      const srcUrl = strings.find(
        (val: ObjectGenericType) => val?.key === NFTURL
      );
      src = srcUrl ? srcUrl.value : "";
    } else if (nftType.toLowerCase() === PDF) {
      const mediaUrl = strings.find(
        (val: ObjectGenericType) => val?.key === THUMBNAILURL
      );
      media = mediaUrl ? mediaUrl?.value : "";
    } else {
      const mediaUrl = strings.find(
        (val: ObjectGenericType) => val?.key === NFTURL
      );
      media = mediaUrl ? mediaUrl?.value : "";
    }
  }

  /* istanbul ignore next */
  const creator = strings.find(
    (val: any) => val?.key.toLowerCase() === "creator"
  )?.value;

  /* istanbul ignore next */
  const dimensions = getNFTDimensions(nftType, itemOutputs);
  /* istanbul ignore next */
  const amountMinted: string = itemOutputs?.amount_minted;
  /* istanbul ignore next */
  const quantity: string = itemOutputs?.Quantity;
  /* istanbul ignore next */
  const edition = `${amountMinted} of ${quantity}`;
  /* istanbul ignore next */

  return (
    <Box>
      <MetaTags
        name={selectedRecipe?.name}
        description={selectedRecipe?.description}
        price={price ?? ""}
        media={media}
        thumbnail={thumbnailNFT || media}
      />
      <EaselBuy
        createdBy={creator}
        name={selectedRecipe?.name}
        description={selectedRecipe?.description}
        price={price}
        denom={denom}
        nftType={nftType}
        dimensions={dimensions}
        royalty={(+itemOutputs?.trade_percentage * tradePercent)?.toString()}
        edition={edition}
        media={media}
        createdAt={creator}
        recipeId={selectedRecipe?.id}
        src={src}
      ></EaselBuy>
    </Box>
  );
}

export async function getServerSideProps({ res, query }: any): Promise<any> {
  const recipeId: string = query?.recipe_id ?? "";
  const cookbookId: string = query?.cookbook_id ?? "";
  const baseURL: string = process?.env?.NEXT_PUBLIC_API_KEY ?? "";
  if (!recipeId || !cookbookId) {
    return {
      redirect: {
        permanent: true,
        destination: HOMEPAGE_URL,
      },
    };
  }
  try {
    const data = await fetch(
      `${baseURL}/pylons/recipe/${cookbookId}/${recipeId}`
    );
    const recipeDetails = await data.json();
    if (!recipeDetails?.recipe) {
      return {
        redirect: {
          permanent: false,
          destination: "/404",
        },
      };
    }
    return {
      props: {
        recipeDetails,
      },
    };
  } catch (error) {
    throw (error);
  }
}