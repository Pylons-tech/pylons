/* eslint-disable max-len */
/* eslint-disable no-unused-vars */
/* eslint-disable no-unused-expressions */
/* eslint-disable indent */
import { useState } from 'react'
import { authActions } from '@store'
import { useAppDispatch } from '@hooks'
import { useRouter } from 'next/router'
import { AxiosResponse } from 'axios'

type SetSnackbarProps = (
  message: string,
  show: boolean,
  type: 'success' | 'error' | 'warning' | 'info' | undefined
) => void

type fetchDataProps = (
  url: (...props: any) => Promise<AxiosResponse<unknown, any>>,
  handleErrorResponse?: () => void,
  shouldHandleError?: boolean
) => any
export const useAxiosFetch = (setSnackbarProps?: SetSnackbarProps): any => {
  const [isLoading, setIsLoading] = useState(false)
  const [fetchError, setFetchError] = useState<any>(null)
  const [data, setData] = useState<any>()
  const dispatch = useAppDispatch()
  const router = useRouter()

  const fetchData: fetchDataProps = async (
    url,
    handleErrorResponse,
    shouldHandleError = true
  ) => {
    setIsLoading(true)
    setFetchError(null)
    setData(null)
    try {
      const res: any = await url()
      const statusCode = res?.data?.code
      if (!shouldHandleError) return setData(res.data)
      switch (statusCode) {
        case 1000:
        case 2876:
          setData(res.data)
          setFetchError(null)
          break
        case 1003:
        case 1002:
          dispatch(authActions.logout())
          void router.push('/')
          break
        case 1001:
          if (setSnackbarProps) {
            setSnackbarProps('Invalid input', true, 'warning')
          }
          break
        default:
          setData(null)
          setFetchError(res?.data)
          if (handleErrorResponse) {
            handleErrorResponse()
          }
          break
      }
    } catch (err: any) {
      setFetchError(err.message)
      setData(null)
      if (err?.response.status === 400) {
        if (setSnackbarProps) {
          setSnackbarProps('Invalid input', true, 'warning')
        }
      }
    } finally {
      setIsLoading(false)
    }
  }

  return { data, fetchError, isLoading, fetchData }
}
