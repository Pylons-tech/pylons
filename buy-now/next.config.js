/** @type {import('next').NextConfig} */
const defaultSettings  = require("./settings.json")
const settings =
  process.env.NEXT_PUBLIC_SETTINGS 
    ? JSON.parse(process.env.NEXT_PUBLIC_SETTINGS)
    : defaultSettings
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
    apiKey: process.env.NEXT_PUBLIC_API_KEY ?? defaultSettings?.remote?.api,
    settings
  }
}

module.exports = nextConfig
