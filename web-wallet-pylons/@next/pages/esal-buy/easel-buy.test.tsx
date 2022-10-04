import { cleanup, CustomRender } from 'test-utils'
import { EaselBuy } from './easel-buy'
// const spyCloneDeepLodash = jest.spyOn(_, 'cloneDeep')

const props = {
  recipeDetails: {
    recipe: {
      cookbook_id: 'Easel_CookBook_auto_cookbook_2022_08_15_125107_377',
      id: 'Easel_Recipe_auto_recipe_2022_08_15_125349_604',
      node_version: '0',
      name: 'Talking to the Moon',
      description: 'Testing NFT for validation for Image',
      version: 'v0.1.0',
      coin_inputs: [
        {
          coins: [
            {
              denom: 'upylon',
              amount: '25000000'
            }
          ]
        }
      ],
      item_inputs: [],
      entries: {
        coin_outputs: [],
        item_outputs: [
          {
            id: 'Easel_NFT',
            doubles: [
              {
                key: 'Residual',
                weightRanges: [
                  {
                    lower: '0.150000000000000000',
                    upper: '0.150000000000000000',
                    weight: '1'
                  }
                ],
                program: ''
              }
            ],
            longs: [
              {
                key: 'Quantity',
                weightRanges: [
                  {
                    lower: '25',
                    upper: '25',
                    weight: '1'
                  }
                ],
                program: ''
              },
              {
                key: 'Width',
                weightRanges: [
                  {
                    lower: '1080',
                    upper: '1080',
                    weight: '1'
                  }
                ],
                program: ''
              },
              {
                key: 'Height',
                weightRanges: [
                  {
                    lower: '767',
                    upper: '767',
                    weight: '1'
                  }
                ],
                program: ''
              },
              {
                key: 'Duration',
                weightRanges: [
                  {
                    lower: '0',
                    upper: '0',
                    weight: '1'
                  }
                ],
                program: ''
              }
            ],
            strings: [
              {
                key: 'Name',
                value: 'Talking to the Moon',
                program: ''
              },
              {
                key: 'App_Type',
                value: 'Easel',
                program: ''
              },
              {
                key: 'Description',
                value: 'Testing NFT for validation for Image',
                program: ''
              },
              {
                key: 'Hashtags',
                value: 'imagenft',
                program: ''
              },
              {
                key: 'NFT_Format',
                value: 'Image',
                program: ''
              },
              {
                key: 'NFT_URL',
                value:
                  'https://ipfs.io/ipfs/bafkreiav5qtxplx65tmchzy37qkl2uzp4pbdscak2htibv3yiikl5pihd4',
                program: ''
              },
              {
                key: 'Thumbnail_URL',
                value: '',
                program: ''
              },
              {
                key: 'Creator',
                value: 'Neo',
                program: ''
              },
              {
                key: 'cid',
                value:
                  'bafkreiav5qtxplx65tmchzy37qkl2uzp4pbdscak2htibv3yiikl5pihd4',
                program: ''
              },
              {
                key: 'fileSize',
                value: '16.08KB',
                program: ''
              }
            ],
            mutable_strings: [],
            transfer_fee: [
              {
                denom: 'upylon',
                amount: '1'
              }
            ],
            trade_percentage: '0.150000000000000000',
            quantity: '25',
            amount_minted: '1',
            tradeable: true
          }
        ],
        item_modify_outputs: []
      },
      outputs: [
        {
          entry_ids: ['Easel_NFT'],
          weight: '1'
        }
      ],
      block_interval: '0',
      cost_per_block: {
        denom: 'upylon',
        amount: '0'
      },
      enabled: true,
      extra_info: 'extraInfo',
      created_at: '1660582428',
      updated_at: '1660582428'
    }
  }
}

afterEach(cleanup)
afterEach(() => {
  jest.restoreAllMocks()
})

jest.mock('lodash/cloneDeep', () => jest.fn())
jest.mock('axios')
jest.mock('next/router', () => ({
  useRouter() {
    return {
      route: '/',
      pathname: '/',
      query: {
        cookbook_id: 'Easel_CookBook_auto_cookbook_2022_08_15_125107_377',
        recipe_id: 'Easel_Recipe_auto_recipe_2022_08_15_125349_604'
      },
      asPath:
        '/?recipe_id=Easel_Recipe_auto_recipe_2022_08_15_125349_604&cookbook_id=Easel_CookBook_auto_cookbook_2022_08_15_125107_377&address=pylo17rp943h9e8kpw84mv2jp7q4hry0dspz26wgtnj',
      isReady: true
    }
  }
}))

const setup = async (): Promise<any> => {
  CustomRender(<EaselBuy {...props} />)
}

describe('<EaselBuy />', () => {
  it('Should Render EaselBuy', async () => {
    await setup()
  })
})
