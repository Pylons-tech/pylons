export const getCryptoCurrencyIcon = (crypto: string): string => {
  switch (crypto?.toLowerCase()) {
    case 'uatom':
      return '/images/crypto_icons/uatom.svg'
    case 'ustripeusd':
      return '/images/crypto_icons/ustripeusd.svg'
    case 'upylons':
    case 'upylon':
      return '/images/crypto_icons/pylon_logo.svg'

    case 'urun':
      return '/images/crypto_icons/urun.svg'

    case 'eeur':
      return '/images/crypto_icons/eeur.svg'
    case 'weth-wei':
      return '/images/crypto_icons/eth.svg'
    case 'uusd':
    case 'ubedrock':
    case 'umuon':
    case 'ujunox':
      return ''
    default:
      return ''
  }
}
