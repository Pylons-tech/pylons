import { createAsyncThunk } from '@reduxjs/toolkit'
import { requestUrl } from '@hooks'

export const authenticateQR = createAsyncThunk(
  'admin/AuthenticateQR',
  async (
    // eslint-disable-next-line @typescript-eslint/member-delimiter-style
    { authCode, token }: { authCode: string; token: string | undefined },
    { getState, extra }
  ) => {
    return await requestUrl
      .post(
        'your/auth/url',
        { authCode },
        {
          headers: {
            token: token ?? ''
          }
        }
      )
      .then(async (res) => await Promise.resolve(res.data))
      .catch(async (err) => await Promise.reject(err))
  }
)
