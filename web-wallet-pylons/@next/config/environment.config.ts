import { string, object } from 'yup'

/**
 * contains all the validated environment variables.
 *
 * Reason:
 * This help prevents the application to start without environment variables. If not used you may still find the
 * error but a bit late.
 */
export const environment = object()
  .shape({
    apiKey: string().required(),
    allowApiMocking: string()
  })
  .validateSync({
    apiKey: process.env.NEXT_PUBLIC_API_KEY,
    allowApiMocking: process.env.NEXT_PUBLIC_ALLOW_API_MOCKING
  })
