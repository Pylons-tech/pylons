import { Box } from '@mui/material'
import { EaselBuy } from '../@next/pages'

interface EaselBuyMainPageTypes {
  recipeDetails: any
}

export default function EaselBuyMainPage({
  recipeDetails
}: EaselBuyMainPageTypes): JSX.Element {
  return (
    <Box>
      <EaselBuy recipeDetails={recipeDetails}></EaselBuy>
    </Box>
  )
}

export async function getServerSideProps({ res, query }: any): Promise<any> {
  const recipeId: string = query?.recipe_id ?? ''
  const cookbookId: string = query?.cookbook_id ?? ''
  const baseURL: string = process?.env?.NEXT_PUBLIC_API_KEY ?? ''
  try {
    const data = await fetch(
      `${baseURL}/pylons/recipe/${cookbookId}/${recipeId}`
    )
    const recipeDetails = await data.json()
    if (!recipeId || !cookbookId || !recipeDetails?.recipe) {
      return {
        redirect: {
          permanent: false,
          destination: '/404'
        }
      }
    }
    return {
      props: {
        recipeDetails
      }
    }
  } catch (error) {
    return {
      redirect: {
        permanent: false,
        destination: '/404'
      }
    }
  }
}
