import { StdFee } from "@cosmjs/launchpad";
import { OfflineSigner, EncodeObject } from "@cosmjs/proto-signing";
import { Api } from "./rest";
import { MsgCreateTrade } from "./types/pylons/tx";
import { MsgUpdateRecipe } from "./types/pylons/tx";
import { MsgCreateCookbook } from "./types/pylons/tx";
import { MsgCancelTrade } from "./types/pylons/tx";
import { MsgSendItems } from "./types/pylons/tx";
import { MsgFulfillTrade } from "./types/pylons/tx";
import { MsgUpdateAccount } from "./types/pylons/tx";
import { MsgGoogleInAppPurchaseGetCoins } from "./types/pylons/tx";
import { MsgTransferCookbook } from "./types/pylons/tx";
import { MsgUpdateCookbook } from "./types/pylons/tx";
import { MsgSetItemString } from "./types/pylons/tx";
import { MsgCreateAccount } from "./types/pylons/tx";
import { MsgCompleteExecutionEarly } from "./types/pylons/tx";
import { MsgCreateRecipe } from "./types/pylons/tx";
import { MsgExecuteRecipe } from "./types/pylons/tx";
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
    msgCreateTrade: (data: MsgCreateTrade) => EncodeObject;
    msgUpdateRecipe: (data: MsgUpdateRecipe) => EncodeObject;
    msgCreateCookbook: (data: MsgCreateCookbook) => EncodeObject;
    msgCancelTrade: (data: MsgCancelTrade) => EncodeObject;
    msgSendItems: (data: MsgSendItems) => EncodeObject;
    msgFulfillTrade: (data: MsgFulfillTrade) => EncodeObject;
    msgUpdateAccount: (data: MsgUpdateAccount) => EncodeObject;
    msgGoogleInAppPurchaseGetCoins: (data: MsgGoogleInAppPurchaseGetCoins) => EncodeObject;
    msgTransferCookbook: (data: MsgTransferCookbook) => EncodeObject;
    msgUpdateCookbook: (data: MsgUpdateCookbook) => EncodeObject;
    msgSetItemString: (data: MsgSetItemString) => EncodeObject;
    msgCreateAccount: (data: MsgCreateAccount) => EncodeObject;
    msgCompleteExecutionEarly: (data: MsgCompleteExecutionEarly) => EncodeObject;
    msgCreateRecipe: (data: MsgCreateRecipe) => EncodeObject;
    msgExecuteRecipe: (data: MsgExecuteRecipe) => EncodeObject;
}>;
interface QueryClientOptions {
    addr: string;
}
declare const queryClient: ({ addr: addr }?: QueryClientOptions) => Promise<Api<unknown>>;
export { txClient, queryClient, };
