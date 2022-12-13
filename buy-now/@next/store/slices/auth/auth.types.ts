export interface UserInfoType {
  department: string
  email: string
  fullName: string
  phone: string
  profileImage: string
  role: string
}
export interface AuthSliceState {
  userInfo: UserInfoType | null
}
