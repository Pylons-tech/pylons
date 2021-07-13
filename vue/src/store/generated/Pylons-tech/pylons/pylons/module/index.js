// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.
import { SigningStargateClient } from "@cosmjs/stargate";
import { Registry } from "@cosmjs/proto-signing";
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
const types = [
    ["/pylons.MsgFulfillTrade", MsgFulfillTrade],
    ["/pylons.MsgSendItems", MsgSendItems],
    ["/pylons.MsgEnableRecipe", MsgEnableRecipe],
    ["/pylons.MsgFiatItem", MsgFiatItem],
    ["/pylons.MsgCreateAccount", MsgCreateAccount],
    ["/pylons.MsgSendCoins", MsgSendCoins],
    ["/pylons.MsgCreateTrade", MsgCreateTrade],
    ["/pylons.MsgUpdateRecipe", MsgUpdateRecipe],
    ["/pylons.MsgCreateCookbook", MsgCreateCookbook],
    ["/pylons.MsgEnableTrade", MsgEnableTrade],
    ["/pylons.MsgCreateRecipe", MsgCreateRecipe],
    ["/pylons.MsgGetPylons", MsgGetPylons],
    ["/pylons.MsgUpdateItemString", MsgUpdateItemString],
    ["/pylons.MsgGoogleIAPGetPylons", MsgGoogleIAPGetPylons],
    ["/pylons.MsgUpdateCookbook", MsgUpdateCookbook],
    ["/pylons.MsgExecuteRecipe", MsgExecuteRecipe],
    ["/pylons.MsgCheckExecution", MsgCheckExecution],
    ["/pylons.MsgDisableRecipe", MsgDisableRecipe],
    ["/pylons.MsgDisableTrade", MsgDisableTrade],
];
export const MissingWalletError = new Error("wallet is required");
const registry = new Registry(types);
const defaultFee = {
    amount: [],
    gas: "200000",
};
const txClient = async (wallet, { addr: addr } = { addr: "http://localhost:26657" }) => {
    if (!wallet)
        throw MissingWalletError;
    const client = await SigningStargateClient.connectWithSigner(addr, wallet, { registry });
    const { address } = (await wallet.getAccounts())[0];
    return {
        signAndBroadcast: (msgs, { fee, memo } = { fee: defaultFee, memo: "" }) => client.signAndBroadcast(address, msgs, fee, memo),
        msgFulfillTrade: (data) => ({ typeUrl: "/pylons.MsgFulfillTrade", value: data }),
        msgSendItems: (data) => ({ typeUrl: "/pylons.MsgSendItems", value: data }),
        msgEnableRecipe: (data) => ({ typeUrl: "/pylons.MsgEnableRecipe", value: data }),
        msgFiatItem: (data) => ({ typeUrl: "/pylons.MsgFiatItem", value: data }),
        msgCreateAccount: (data) => ({ typeUrl: "/pylons.MsgCreateAccount", value: data }),
        msgSendCoins: (data) => ({ typeUrl: "/pylons.MsgSendCoins", value: data }),
        msgCreateTrade: (data) => ({ typeUrl: "/pylons.MsgCreateTrade", value: data }),
        msgUpdateRecipe: (data) => ({ typeUrl: "/pylons.MsgUpdateRecipe", value: data }),
        msgCreateCookbook: (data) => ({ typeUrl: "/pylons.MsgCreateCookbook", value: data }),
        msgEnableTrade: (data) => ({ typeUrl: "/pylons.MsgEnableTrade", value: data }),
        msgCreateRecipe: (data) => ({ typeUrl: "/pylons.MsgCreateRecipe", value: data }),
        msgGetPylons: (data) => ({ typeUrl: "/pylons.MsgGetPylons", value: data }),
        msgUpdateItemString: (data) => ({ typeUrl: "/pylons.MsgUpdateItemString", value: data }),
        msgGoogleIAPGetPylons: (data) => ({ typeUrl: "/pylons.MsgGoogleIAPGetPylons", value: data }),
        msgUpdateCookbook: (data) => ({ typeUrl: "/pylons.MsgUpdateCookbook", value: data }),
        msgExecuteRecipe: (data) => ({ typeUrl: "/pylons.MsgExecuteRecipe", value: data }),
        msgCheckExecution: (data) => ({ typeUrl: "/pylons.MsgCheckExecution", value: data }),
        msgDisableRecipe: (data) => ({ typeUrl: "/pylons.MsgDisableRecipe", value: data }),
        msgDisableTrade: (data) => ({ typeUrl: "/pylons.MsgDisableTrade", value: data }),
    };
};
const queryClient = async ({ addr: addr } = { addr: "http://localhost:1317" }) => {
    return new Api({ baseUrl: addr });
};
export { txClient, queryClient, };
