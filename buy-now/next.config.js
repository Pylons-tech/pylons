/** @type {import('next').NextConfig} */

const settings =
  typeof process.env.NEXT_PUBLIC_SETTINGS === 'string'
    ? JSON.parse(process.env.NEXT_PUBLIC_SETTINGS)
    : {}
const nextConfig = {
  compiler: {
    emotion: true,
    styledComponents: true
  },
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['ipfs.io']
  },
  publicRuntimeConfig: {
    // Will be available on both server and client
    apiKey: process.env.NEXT_PUBLIC_API_KEY,
    settings
  }
}

module.exports = nextConfig
