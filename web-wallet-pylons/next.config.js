/** @type {import('next').NextConfig} */
const nextConfig = {
  compiler: {
    emotion: true,
    styledComponents: true
  },
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['ipfs.io']
  }
}

module.exports = nextConfig
