import { string, object } from 'yup'
import getConfig from 'next/config'
const { publicRuntimeConfig } = getConfig()
/**
 * contains all the validated environment variables.
 *
 * Reason:
 * This help prevents the application to start without environment variables. If not used you may still find the
 * error but a bit late.
 */
export const environment = object()
  .shape({
    apiKey: string()
  })
  .validateSync({
    apiKey: publicRuntimeConfig.apiKey
  })
