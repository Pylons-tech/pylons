// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.
import { SigningStargateClient } from "@cosmjs/stargate";
import { Registry } from "@cosmjs/proto-signing";
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
        msgFiatItem: (data) => ({ typeUrl: "/pylons.MsgFiatItem", value: data }),
        msgStripeCreateAccount: (data) => ({ typeUrl: "/pylons.MsgStripeCreateAccount", value: data }),
        msgFulfillTrade: (data) => ({ typeUrl: "/pylons.MsgFulfillTrade", value: data }),
        msgGoogleIAPGetPylons: (data) => ({ typeUrl: "/pylons.MsgGoogleIAPGetPylons", value: data }),
        msgStripeInfo: (data) => ({ typeUrl: "/pylons.MsgStripeInfo", value: data }),
        msgStripeCheckout: (data) => ({ typeUrl: "/pylons.MsgStripeCheckout", value: data }),
        msgEnableRecipe: (data) => ({ typeUrl: "/pylons.MsgEnableRecipe", value: data }),
        msgStripeCreateSku: (data) => ({ typeUrl: "/pylons.MsgStripeCreateSku", value: data }),
        msgSendCoins: (data) => ({ typeUrl: "/pylons.MsgSendCoins", value: data }),
        msgExecuteRecipe: (data) => ({ typeUrl: "/pylons.MsgExecuteRecipe", value: data }),
        msgStripeCreatePrice: (data) => ({ typeUrl: "/pylons.MsgStripeCreatePrice", value: data }),
        msgDisableTrade: (data) => ({ typeUrl: "/pylons.MsgDisableTrade", value: data }),
        msgCreateCookbook: (data) => ({ typeUrl: "/pylons.MsgCreateCookbook", value: data }),
        msgStripeCreateProductSku: (data) => ({ typeUrl: "/pylons.MsgStripeCreateProductSku", value: data }),
        msgEnableTrade: (data) => ({ typeUrl: "/pylons.MsgEnableTrade", value: data }),
        msgDisableRecipe: (data) => ({ typeUrl: "/pylons.MsgDisableRecipe", value: data }),
        msgStripeCreateProduct: (data) => ({ typeUrl: "/pylons.MsgStripeCreateProduct", value: data }),
        msgSendItems: (data) => ({ typeUrl: "/pylons.MsgSendItems", value: data }),
        msgStripeOauthToken: (data) => ({ typeUrl: "/pylons.MsgStripeOauthToken", value: data }),
        msgUpdateItemString: (data) => ({ typeUrl: "/pylons.MsgUpdateItemString", value: data }),
        msgCreateTrade: (data) => ({ typeUrl: "/pylons.MsgCreateTrade", value: data }),
        msgUpdateRecipe: (data) => ({ typeUrl: "/pylons.MsgUpdateRecipe", value: data }),
        msgStripeCreatePaymentIntent: (data) => ({ typeUrl: "/pylons.MsgStripeCreatePaymentIntent", value: data }),
        msgCheckExecution: (data) => ({ typeUrl: "/pylons.MsgCheckExecution", value: data }),
        msgGetPylons: (data) => ({ typeUrl: "/pylons.MsgGetPylons", value: data }),
        msgUpdateCookbook: (data) => ({ typeUrl: "/pylons.MsgUpdateCookbook", value: data }),
        msgCreateAccount: (data) => ({ typeUrl: "/pylons.MsgCreateAccount", value: data }),
        msgCreateRecipe: (data) => ({ typeUrl: "/pylons.MsgCreateRecipe", value: data }),
    };
};
const queryClient = async ({ addr: addr } = { addr: "http://localhost:1317" }) => {
    return new Api({ baseUrl: addr });
};
export { txClient, queryClient, };
