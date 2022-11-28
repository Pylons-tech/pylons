module.exports = {
  i18n: {
    defaultLocale: 'en',
    locales: ['de', 'en'],
    localeDetection: false
  },
  reloadOnPrerender: process.env.NODE_ENV === 'development'
}
