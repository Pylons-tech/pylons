import { StdFee } from "@cosmjs/launchpad";
import { OfflineSigner, EncodeObject } from "@cosmjs/proto-signing";
import { Api } from "./rest";
import { MsgUpdateCookbook } from "./types/pylons/tx";
import { MsgCreateAccount } from "./types/pylons/tx";
import { MsgUpdateAccount } from "./types/pylons/tx";
import { MsgCompleteExecutionEarly } from "./types/pylons/tx";
import { MsgGoogleInAppPurchaseGetCoins } from "./types/pylons/tx";
import { MsgCreateCookbook } from "./types/pylons/tx";
import { MsgExecuteRecipe } from "./types/pylons/tx";
import { MsgSendItems } from "./types/pylons/tx";
import { MsgTransferCookbook } from "./types/pylons/tx";
import { MsgCreateTrade } from "./types/pylons/tx";
import { MsgCancelTrade } from "./types/pylons/tx";
import { MsgCreateRecipe } from "./types/pylons/tx";
import { MsgUpdateRecipe } from "./types/pylons/tx";
import { MsgFulfillTrade } from "./types/pylons/tx";
import { MsgSetItemString } from "./types/pylons/tx";
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
    msgUpdateCookbook: (data: MsgUpdateCookbook) => EncodeObject;
    msgCreateAccount: (data: MsgCreateAccount) => EncodeObject;
    msgUpdateAccount: (data: MsgUpdateAccount) => EncodeObject;
    msgCompleteExecutionEarly: (data: MsgCompleteExecutionEarly) => EncodeObject;
    msgGoogleInAppPurchaseGetCoins: (data: MsgGoogleInAppPurchaseGetCoins) => EncodeObject;
    msgCreateCookbook: (data: MsgCreateCookbook) => EncodeObject;
    msgExecuteRecipe: (data: MsgExecuteRecipe) => EncodeObject;
    msgSendItems: (data: MsgSendItems) => EncodeObject;
    msgTransferCookbook: (data: MsgTransferCookbook) => EncodeObject;
    msgCreateTrade: (data: MsgCreateTrade) => EncodeObject;
    msgCancelTrade: (data: MsgCancelTrade) => EncodeObject;
    msgCreateRecipe: (data: MsgCreateRecipe) => EncodeObject;
    msgUpdateRecipe: (data: MsgUpdateRecipe) => EncodeObject;
    msgFulfillTrade: (data: MsgFulfillTrade) => EncodeObject;
    msgSetItemString: (data: MsgSetItemString) => EncodeObject;
}>;
interface QueryClientOptions {
    addr: string;
}
declare const queryClient: ({ addr: addr }?: QueryClientOptions) => Promise<Api<unknown>>;
export { txClient, queryClient, };
