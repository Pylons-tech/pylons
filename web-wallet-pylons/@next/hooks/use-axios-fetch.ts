/* eslint-disable max-len */
/* eslint-disable no-unused-vars */
/* eslint-disable no-unused-expressions */
/* eslint-disable indent */
import { useState } from 'react'
import {} from '@store'
import { authActions } from '@store'
import { useAppSelector, useAppDispatch } from '@hooks'
import { useRouter } from 'next/router'
import { AxiosResponse } from 'axios'

interface mainProps {
  (
    setSnackbarProps?: (
      message: string,
      show: boolean,
      type: 'success' | 'error' | 'warning' | 'info' | undefined
    ) => void
  ): any
}
interface fetchDataProps {
  (
    url: (...props: any) => Promise<AxiosResponse<unknown, any>>,
    handleErrorResponse?: () => void,
    shouldHandleError?: boolean
  ): any | void
}
let tokenId: any

export const useAxiosFetch: mainProps = (setSnackbarProps) => {
  const [isLoading, setIsLoading] = useState(false)
  const [fetchError, setFetchError] = useState<any>(null)
  const [data, setData] = useState<any>()
  const dispatch = useAppDispatch()
  const router = useRouter()
  // eslint-disable-next-line consistent-return
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
          router.push('/')
          break
        case 1001:
          setSnackbarProps
            ? setSnackbarProps('Invalid input', true, 'warning')
            : null
        default:
          setData(null)
          setFetchError(res?.data)
          handleErrorResponse ? handleErrorResponse() : null
          //   setSnackbarProps
          //     ? setSnackbarProps(getErrorMessages(statusCode), true, "warning")
          //     : null;
          break
      }
    } catch (err: any) {
      setFetchError(err.message)
      setData(null)
      if (err?.response.status == 400) {
        setSnackbarProps
          ? setSnackbarProps('Invalid input', true, 'warning')
          : null
      }
      // dispatch(authActions.setNetworkError(true))
    } finally {
      setIsLoading(false)
    }
  }

  return { data, fetchError, isLoading, fetchData }
}
