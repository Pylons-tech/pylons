import { requestUrl } from '@hooks'
import { AxiosResponse } from 'axios'

export const getRecipeHistory = async (
  cookbookId: string,
  recipeId: string
): Promise<AxiosResponse<unknown, any>> => {
  return await requestUrl.get(
    `/pylons/get_recipe_history/${cookbookId}/${recipeId}`
  )
}

export const getRecipeDetails = async (
  cookbookId: string,
  recipeId: string
): Promise<AxiosResponse<unknown, any>> => {
  return await requestUrl.get(`/pylons/recipe/${cookbookId}/${recipeId}`)
}
