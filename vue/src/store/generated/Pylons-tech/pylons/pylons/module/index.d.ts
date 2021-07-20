import { StdFee } from "@cosmjs/launchpad";
import { OfflineSigner, EncodeObject } from "@cosmjs/proto-signing";
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
export declare const MissingWalletError: Error;
interface TxClientOptions {
    addr: string;
}
interface SignAndBroadcastOptions {
    fee: StdFee;
    memo?: string;
}
declare const txClient: (wallet: OfflineSigner, { addr: addr }?: TxClientOptions) => Promise<{
    signAndBroadcast: (msgs: EncodeObject[], { fee, memo }?: SignAndBroadcastOptions) => Promise<import("@cosmjs/stargate").BroadcastTxResponse>;
    msgFiatItem: (data: MsgFiatItem) => EncodeObject;
    msgStripeCreateAccount: (data: MsgStripeCreateAccount) => EncodeObject;
    msgFulfillTrade: (data: MsgFulfillTrade) => EncodeObject;
    msgGoogleIAPGetPylons: (data: MsgGoogleIAPGetPylons) => EncodeObject;
    msgStripeInfo: (data: MsgStripeInfo) => EncodeObject;
    msgStripeCheckout: (data: MsgStripeCheckout) => EncodeObject;
    msgEnableRecipe: (data: MsgEnableRecipe) => EncodeObject;
    msgStripeCreateSku: (data: MsgStripeCreateSku) => EncodeObject;
    msgSendCoins: (data: MsgSendCoins) => EncodeObject;
    msgExecuteRecipe: (data: MsgExecuteRecipe) => EncodeObject;
    msgStripeCreatePrice: (data: MsgStripeCreatePrice) => EncodeObject;
    msgDisableTrade: (data: MsgDisableTrade) => EncodeObject;
    msgCreateCookbook: (data: MsgCreateCookbook) => EncodeObject;
    msgStripeCreateProductSku: (data: MsgStripeCreateProductSku) => EncodeObject;
    msgEnableTrade: (data: MsgEnableTrade) => EncodeObject;
    msgDisableRecipe: (data: MsgDisableRecipe) => EncodeObject;
    msgStripeCreateProduct: (data: MsgStripeCreateProduct) => EncodeObject;
    msgSendItems: (data: MsgSendItems) => EncodeObject;
    msgStripeOauthToken: (data: MsgStripeOauthToken) => EncodeObject;
    msgUpdateItemString: (data: MsgUpdateItemString) => EncodeObject;
    msgCreateTrade: (data: MsgCreateTrade) => EncodeObject;
    msgUpdateRecipe: (data: MsgUpdateRecipe) => EncodeObject;
    msgStripeCreatePaymentIntent: (data: MsgStripeCreatePaymentIntent) => EncodeObject;
    msgCheckExecution: (data: MsgCheckExecution) => EncodeObject;
    msgGetPylons: (data: MsgGetPylons) => EncodeObject;
    msgUpdateCookbook: (data: MsgUpdateCookbook) => EncodeObject;
    msgCreateAccount: (data: MsgCreateAccount) => EncodeObject;
    msgCreateRecipe: (data: MsgCreateRecipe) => EncodeObject;
}>;
interface QueryClientOptions {
    addr: string;
}
declare const queryClient: ({ addr: addr }?: QueryClientOptions) => Promise<Api<unknown>>;
export { txClient, queryClient, };
