// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.

import { StdFee } from "@cosmjs/launchpad";
import { SigningStargateClient } from "@cosmjs/stargate";
import { Registry, OfflineSigner, EncodeObject, DirectSecp256k1HdWallet } from "@cosmjs/proto-signing";
import { Api } from "./rest";
import { MsgFiatItem } from "./types/pylons/tx";
import { MsgStripeCreateAccount } from "./types/pylons/tx";
import { MsgFulfillTrade } from "./types/pylons/tx";
import { MsgGoogleIAPGetPylons } from "./types/pylons/tx";
import { MsgStripeInfo } from "./types/pylons/tx";
import { MsgStripeCheckout } from "./types/pylons/tx";
import { MsgEnableRecipe } from "./types/pylons/tx";
import { MsgStripeCreateSku } from "./types/pylons/tx";
import { MsgSendCoins } from "./types/pylons/tx";
import { MsgExecuteRecipe } from "./types/pylons/tx";
import { MsgStripeCreatePrice } from "./types/pylons/tx";
import { MsgDisableTrade } from "./types/pylons/tx";
import { MsgCreateCookbook } from "./types/pylons/tx";
import { MsgStripeCreateProductSku } from "./types/pylons/tx";
import { MsgEnableTrade } from "./types/pylons/tx";
import { MsgDisableRecipe } from "./types/pylons/tx";
import { MsgStripeCreateProduct } from "./types/pylons/tx";
import { MsgSendItems } from "./types/pylons/tx";
import { MsgStripeOauthToken } from "./types/pylons/tx";
import { MsgUpdateItemString } from "./types/pylons/tx";
import { MsgCreateTrade } from "./types/pylons/tx";
import { MsgUpdateRecipe } from "./types/pylons/tx";
import { MsgStripeCreatePaymentIntent } from "./types/pylons/tx";
import { MsgCheckExecution } from "./types/pylons/tx";
import { MsgGetPylons } from "./types/pylons/tx";
import { MsgUpdateCookbook } from "./types/pylons/tx";
import { MsgCreateAccount } from "./types/pylons/tx";
import { MsgCreateRecipe } from "./types/pylons/tx";


const types = [
  ["/pylons.MsgFiatItem", MsgFiatItem],
  ["/pylons.MsgStripeCreateAccount", MsgStripeCreateAccount],
  ["/pylons.MsgFulfillTrade", MsgFulfillTrade],
  ["/pylons.MsgGoogleIAPGetPylons", MsgGoogleIAPGetPylons],
  ["/pylons.MsgStripeInfo", MsgStripeInfo],
  ["/pylons.MsgStripeCheckout", MsgStripeCheckout],
  ["/pylons.MsgEnableRecipe", MsgEnableRecipe],
  ["/pylons.MsgStripeCreateSku", MsgStripeCreateSku],
  ["/pylons.MsgSendCoins", MsgSendCoins],
  ["/pylons.MsgExecuteRecipe", MsgExecuteRecipe],
  ["/pylons.MsgStripeCreatePrice", MsgStripeCreatePrice],
  ["/pylons.MsgDisableTrade", MsgDisableTrade],
  ["/pylons.MsgCreateCookbook", MsgCreateCookbook],
  ["/pylons.MsgStripeCreateProductSku", MsgStripeCreateProductSku],
  ["/pylons.MsgEnableTrade", MsgEnableTrade],
  ["/pylons.MsgDisableRecipe", MsgDisableRecipe],
  ["/pylons.MsgStripeCreateProduct", MsgStripeCreateProduct],
  ["/pylons.MsgSendItems", MsgSendItems],
  ["/pylons.MsgStripeOauthToken", MsgStripeOauthToken],
  ["/pylons.MsgUpdateItemString", MsgUpdateItemString],
  ["/pylons.MsgCreateTrade", MsgCreateTrade],
  ["/pylons.MsgUpdateRecipe", MsgUpdateRecipe],
  ["/pylons.MsgStripeCreatePaymentIntent", MsgStripeCreatePaymentIntent],
  ["/pylons.MsgCheckExecution", MsgCheckExecution],
  ["/pylons.MsgGetPylons", MsgGetPylons],
  ["/pylons.MsgUpdateCookbook", MsgUpdateCookbook],
  ["/pylons.MsgCreateAccount", MsgCreateAccount],
  ["/pylons.MsgCreateRecipe", MsgCreateRecipe],
  
];
export const MissingWalletError = new Error("wallet is required");

const registry = new Registry(<any>types);

const defaultFee = {
  amount: [],
  gas: "200000",
};

interface TxClientOptions {
  addr: string
}

interface SignAndBroadcastOptions {
  fee: StdFee,
  memo?: string
}

const txClient = async (wallet: OfflineSigner, { addr: addr }: TxClientOptions = { addr: "http://localhost:26657" }) => {
  if (!wallet) throw MissingWalletError;

  const client = await SigningStargateClient.connectWithSigner(addr, wallet, { registry });
  const { address } = (await wallet.getAccounts())[0];

  return {
    signAndBroadcast: (msgs: EncodeObject[], { fee, memo }: SignAndBroadcastOptions = {fee: defaultFee, memo: ""}) => client.signAndBroadcast(address, msgs, fee,memo),
    msgFiatItem: (data: MsgFiatItem): EncodeObject => ({ typeUrl: "/pylons.MsgFiatItem", value: data }),
    msgStripeCreateAccount: (data: MsgStripeCreateAccount): EncodeObject => ({ typeUrl: "/pylons.MsgStripeCreateAccount", value: data }),
    msgFulfillTrade: (data: MsgFulfillTrade): EncodeObject => ({ typeUrl: "/pylons.MsgFulfillTrade", value: data }),
    msgGoogleIAPGetPylons: (data: MsgGoogleIAPGetPylons): EncodeObject => ({ typeUrl: "/pylons.MsgGoogleIAPGetPylons", value: data }),
    msgStripeInfo: (data: MsgStripeInfo): EncodeObject => ({ typeUrl: "/pylons.MsgStripeInfo", value: data }),
    msgStripeCheckout: (data: MsgStripeCheckout): EncodeObject => ({ typeUrl: "/pylons.MsgStripeCheckout", value: data }),
    msgEnableRecipe: (data: MsgEnableRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgEnableRecipe", value: data }),
    msgStripeCreateSku: (data: MsgStripeCreateSku): EncodeObject => ({ typeUrl: "/pylons.MsgStripeCreateSku", value: data }),
    msgSendCoins: (data: MsgSendCoins): EncodeObject => ({ typeUrl: "/pylons.MsgSendCoins", value: data }),
    msgExecuteRecipe: (data: MsgExecuteRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgExecuteRecipe", value: data }),
    msgStripeCreatePrice: (data: MsgStripeCreatePrice): EncodeObject => ({ typeUrl: "/pylons.MsgStripeCreatePrice", value: data }),
    msgDisableTrade: (data: MsgDisableTrade): EncodeObject => ({ typeUrl: "/pylons.MsgDisableTrade", value: data }),
    msgCreateCookbook: (data: MsgCreateCookbook): EncodeObject => ({ typeUrl: "/pylons.MsgCreateCookbook", value: data }),
    msgStripeCreateProductSku: (data: MsgStripeCreateProductSku): EncodeObject => ({ typeUrl: "/pylons.MsgStripeCreateProductSku", value: data }),
    msgEnableTrade: (data: MsgEnableTrade): EncodeObject => ({ typeUrl: "/pylons.MsgEnableTrade", value: data }),
    msgDisableRecipe: (data: MsgDisableRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgDisableRecipe", value: data }),
    msgStripeCreateProduct: (data: MsgStripeCreateProduct): EncodeObject => ({ typeUrl: "/pylons.MsgStripeCreateProduct", value: data }),
    msgSendItems: (data: MsgSendItems): EncodeObject => ({ typeUrl: "/pylons.MsgSendItems", value: data }),
    msgStripeOauthToken: (data: MsgStripeOauthToken): EncodeObject => ({ typeUrl: "/pylons.MsgStripeOauthToken", value: data }),
    msgUpdateItemString: (data: MsgUpdateItemString): EncodeObject => ({ typeUrl: "/pylons.MsgUpdateItemString", value: data }),
    msgCreateTrade: (data: MsgCreateTrade): EncodeObject => ({ typeUrl: "/pylons.MsgCreateTrade", value: data }),
    msgUpdateRecipe: (data: MsgUpdateRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgUpdateRecipe", value: data }),
    msgStripeCreatePaymentIntent: (data: MsgStripeCreatePaymentIntent): EncodeObject => ({ typeUrl: "/pylons.MsgStripeCreatePaymentIntent", value: data }),
    msgCheckExecution: (data: MsgCheckExecution): EncodeObject => ({ typeUrl: "/pylons.MsgCheckExecution", value: data }),
    msgGetPylons: (data: MsgGetPylons): EncodeObject => ({ typeUrl: "/pylons.MsgGetPylons", value: data }),
    msgUpdateCookbook: (data: MsgUpdateCookbook): EncodeObject => ({ typeUrl: "/pylons.MsgUpdateCookbook", value: data }),
    msgCreateAccount: (data: MsgCreateAccount): EncodeObject => ({ typeUrl: "/pylons.MsgCreateAccount", value: data }),
    msgCreateRecipe: (data: MsgCreateRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgCreateRecipe", value: data }),
    
  };
};

interface QueryClientOptions {
  addr: string
}

const queryClient = async ({ addr: addr }: QueryClientOptions = { addr: "http://localhost:1317" }) => {
  return new Api({ baseUrl: addr });
};

export {
  txClient,
  queryClient,
};
