import { StdFee } from "@cosmjs/launchpad";
import { OfflineSigner, EncodeObject } from "@cosmjs/proto-signing";
import { Api } from "./rest";
import { MsgCreateCookbook } from "./types/pylons/tx";
import { MsgUpdateCookbook } from "./types/pylons/tx";
import { MsgSetItemString } from "./types/pylons/tx";
import { MsgExecuteRecipe } from "./types/pylons/tx";
import { MsgCreateAccount } from "./types/pylons/tx";
import { MsgSendItems } from "./types/pylons/tx";
import { MsgUpdateRecipe } from "./types/pylons/tx";
import { MsgCreateRecipe } from "./types/pylons/tx";
import { MsgTransferCookbook } from "./types/pylons/tx";
import { MsgGoogleInAppPurchaseGetPylons } from "./types/pylons/tx";
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
    msgCreateCookbook: (data: MsgCreateCookbook) => EncodeObject;
    msgUpdateCookbook: (data: MsgUpdateCookbook) => EncodeObject;
    msgSetItemString: (data: MsgSetItemString) => EncodeObject;
    msgExecuteRecipe: (data: MsgExecuteRecipe) => EncodeObject;
    msgCreateAccount: (data: MsgCreateAccount) => EncodeObject;
    msgSendItems: (data: MsgSendItems) => EncodeObject;
    msgUpdateRecipe: (data: MsgUpdateRecipe) => EncodeObject;
    msgCreateRecipe: (data: MsgCreateRecipe) => EncodeObject;
    msgTransferCookbook: (data: MsgTransferCookbook) => EncodeObject;
    msgGoogleInAppPurchaseGetPylons: (data: MsgGoogleInAppPurchaseGetPylons) => EncodeObject;
}>;
interface QueryClientOptions {
    addr: string;
}
declare const queryClient: ({ addr: addr }?: QueryClientOptions) => Promise<Api<unknown>>;
export { txClient, queryClient, };
