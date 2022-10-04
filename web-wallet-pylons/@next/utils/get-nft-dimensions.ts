import { AUDIO, IMAGE, PDF, THREED, VIDEO } from './constants'

const milliSecondsToMinute = 60000
const milliValue = 1000
const singleDigit = 10

interface ObjectGenericType {
  [key: string]: any
}

export const getNFTDimensions = (
  nftType: ObjectGenericType,
  data: ObjectGenericType
): any => {
  if (nftType?.toLowerCase() === IMAGE) {
    const lower1: string = data.longs[1].weightRanges[0].lower ?? ''
    const lower2: string = data.longs[2].weightRanges[0].lower ?? ''
    return `${lower1} x ${lower2}`
  } else if (
    nftType?.toLowerCase() === AUDIO ||
    nftType?.toLowerCase() === VIDEO
  ) {
    const millisecondsDuration = data.longs[3].weightRanges[0].lower
    const minutes = Math.floor(millisecondsDuration / milliSecondsToMinute)
    const seconds = (
      (millisecondsDuration % milliSecondsToMinute) /
      milliValue
    ).toFixed(0)
    return `${minutes}:${(+seconds < +singleDigit ? '0' : '') + seconds}min`
  } else if (
    nftType?.toLowerCase() === THREED ||
    nftType?.toLowerCase() === PDF
  ) {
    return data.strings.find((val: { key: string }) => val.key === 'fileSize')
      ?.value
  }
}
