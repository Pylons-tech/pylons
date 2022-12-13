/* eslint-disable @typescript-eslint/space-before-function-paren */
/**
 * @file Contains the auth slice of the app store state.
 * Here the slice is initialized.
 */

import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import { AuthSliceState, UserInfoType } from './auth.types'

export const authInitialState: AuthSliceState = {
  userInfo: null
}

const authSlice = createSlice({
  name: 'auth',
  initialState: authInitialState,
  reducers: {
    logout(state: AuthSliceState) {
      localStorage.clear()
      state.userInfo = null
    },
    setUserInfo(
      state: AuthSliceState,
      { payload }: PayloadAction<UserInfoType>
    ) {
      state.userInfo = payload
    }
  }
})

export const authActions = authSlice.actions
export const authReducer = authSlice.reducer
