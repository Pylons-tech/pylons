import { StdFee } from "@cosmjs/launchpad";
import { OfflineSigner, EncodeObject } from "@cosmjs/proto-signing";
import { Api } from "./rest";
import { MsgFulfillTrade } from "./types/pylons/tx";
import { MsgSendItems } from "./types/pylons/tx";
import { MsgEnableRecipe } from "./types/pylons/tx";
import { MsgFiatItem } from "./types/pylons/tx";
import { MsgCreateAccount } from "./types/pylons/tx";
import { MsgSendCoins } from "./types/pylons/tx";
import { MsgCreateTrade } from "./types/pylons/tx";
import { MsgUpdateRecipe } from "./types/pylons/tx";
import { MsgCreateCookbook } from "./types/pylons/tx";
import { MsgEnableTrade } from "./types/pylons/tx";
import { MsgCreateRecipe } from "./types/pylons/tx";
import { MsgGetPylons } from "./types/pylons/tx";
import { MsgUpdateItemString } from "./types/pylons/tx";
import { MsgGoogleIAPGetPylons } from "./types/pylons/tx";
import { MsgUpdateCookbook } from "./types/pylons/tx";
import { MsgExecuteRecipe } from "./types/pylons/tx";
import { MsgCheckExecution } from "./types/pylons/tx";
import { MsgDisableRecipe } from "./types/pylons/tx";
import { MsgDisableTrade } from "./types/pylons/tx";
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
    msgFulfillTrade: (data: MsgFulfillTrade) => EncodeObject;
    msgSendItems: (data: MsgSendItems) => EncodeObject;
    msgEnableRecipe: (data: MsgEnableRecipe) => EncodeObject;
    msgFiatItem: (data: MsgFiatItem) => EncodeObject;
    msgCreateAccount: (data: MsgCreateAccount) => EncodeObject;
    msgSendCoins: (data: MsgSendCoins) => EncodeObject;
    msgCreateTrade: (data: MsgCreateTrade) => EncodeObject;
    msgUpdateRecipe: (data: MsgUpdateRecipe) => EncodeObject;
    msgCreateCookbook: (data: MsgCreateCookbook) => EncodeObject;
    msgEnableTrade: (data: MsgEnableTrade) => EncodeObject;
    msgCreateRecipe: (data: MsgCreateRecipe) => EncodeObject;
    msgGetPylons: (data: MsgGetPylons) => EncodeObject;
    msgUpdateItemString: (data: MsgUpdateItemString) => EncodeObject;
    msgGoogleIAPGetPylons: (data: MsgGoogleIAPGetPylons) => EncodeObject;
    msgUpdateCookbook: (data: MsgUpdateCookbook) => EncodeObject;
    msgExecuteRecipe: (data: MsgExecuteRecipe) => EncodeObject;
    msgCheckExecution: (data: MsgCheckExecution) => EncodeObject;
    msgDisableRecipe: (data: MsgDisableRecipe) => EncodeObject;
    msgDisableTrade: (data: MsgDisableTrade) => EncodeObject;
}>;
interface QueryClientOptions {
    addr: string;
}
declare const queryClient: ({ addr: addr }?: QueryClientOptions) => Promise<Api<unknown>>;
export { txClient, queryClient, };
