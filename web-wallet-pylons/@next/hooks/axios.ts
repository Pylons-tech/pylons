import axios from 'axios'
import { environment } from '@config'

export const url: string = environment.apiKey

export const requestUrl = axios.create({
  baseURL: url
})
