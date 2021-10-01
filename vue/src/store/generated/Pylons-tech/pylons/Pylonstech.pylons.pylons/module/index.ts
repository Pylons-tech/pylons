// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.

import { StdFee } from "@cosmjs/launchpad";
import { SigningStargateClient } from "@cosmjs/stargate";
import { Registry, OfflineSigner, EncodeObject, DirectSecp256k1HdWallet } from "@cosmjs/proto-signing";
import { Api } from "./rest";
import { MsgCreateAccount } from "./types/pylons/tx";
import { MsgUpdateCookbook } from "./types/pylons/tx";
import { MsgUpdateAccount } from "./types/pylons/tx";
import { MsgCreateCookbook } from "./types/pylons/tx";
import { MsgCancelTrade } from "./types/pylons/tx";
import { MsgExecuteRecipe } from "./types/pylons/tx";
import { MsgCreateRecipe } from "./types/pylons/tx";
import { MsgGoogleInAppPurchaseGetCoins } from "./types/pylons/tx";
import { MsgUpdateRecipe } from "./types/pylons/tx";
import { MsgCompleteExecutionEarly } from "./types/pylons/tx";
import { MsgFulfillTrade } from "./types/pylons/tx";
import { MsgTransferCookbook } from "./types/pylons/tx";
import { MsgSendItems } from "./types/pylons/tx";
import { MsgCreateTrade } from "./types/pylons/tx";
import { MsgSetItemString } from "./types/pylons/tx";


const types = [
  ["/Pylonstech.pylons.pylons.MsgCreateAccount", MsgCreateAccount],
  ["/Pylonstech.pylons.pylons.MsgUpdateCookbook", MsgUpdateCookbook],
  ["/Pylonstech.pylons.pylons.MsgUpdateAccount", MsgUpdateAccount],
  ["/Pylonstech.pylons.pylons.MsgCreateCookbook", MsgCreateCookbook],
  ["/Pylonstech.pylons.pylons.MsgCancelTrade", MsgCancelTrade],
  ["/Pylonstech.pylons.pylons.MsgExecuteRecipe", MsgExecuteRecipe],
  ["/Pylonstech.pylons.pylons.MsgCreateRecipe", MsgCreateRecipe],
  ["/Pylonstech.pylons.pylons.MsgGoogleInAppPurchaseGetCoins", MsgGoogleInAppPurchaseGetCoins],
  ["/Pylonstech.pylons.pylons.MsgUpdateRecipe", MsgUpdateRecipe],
  ["/Pylonstech.pylons.pylons.MsgCompleteExecutionEarly", MsgCompleteExecutionEarly],
  ["/Pylonstech.pylons.pylons.MsgFulfillTrade", MsgFulfillTrade],
  ["/Pylonstech.pylons.pylons.MsgTransferCookbook", MsgTransferCookbook],
  ["/Pylonstech.pylons.pylons.MsgSendItems", MsgSendItems],
  ["/Pylonstech.pylons.pylons.MsgCreateTrade", MsgCreateTrade],
  ["/Pylonstech.pylons.pylons.MsgSetItemString", MsgSetItemString],
  
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
    msgCreateAccount: (data: MsgCreateAccount): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgCreateAccount", value: data }),
    msgUpdateCookbook: (data: MsgUpdateCookbook): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgUpdateCookbook", value: data }),
    msgUpdateAccount: (data: MsgUpdateAccount): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgUpdateAccount", value: data }),
    msgCreateCookbook: (data: MsgCreateCookbook): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgCreateCookbook", value: data }),
    msgCancelTrade: (data: MsgCancelTrade): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgCancelTrade", value: data }),
    msgExecuteRecipe: (data: MsgExecuteRecipe): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgExecuteRecipe", value: data }),
    msgCreateRecipe: (data: MsgCreateRecipe): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgCreateRecipe", value: data }),
    msgGoogleInAppPurchaseGetCoins: (data: MsgGoogleInAppPurchaseGetCoins): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgGoogleInAppPurchaseGetCoins", value: data }),
    msgUpdateRecipe: (data: MsgUpdateRecipe): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgUpdateRecipe", value: data }),
    msgCompleteExecutionEarly: (data: MsgCompleteExecutionEarly): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgCompleteExecutionEarly", value: data }),
    msgFulfillTrade: (data: MsgFulfillTrade): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgFulfillTrade", value: data }),
    msgTransferCookbook: (data: MsgTransferCookbook): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgTransferCookbook", value: data }),
    msgSendItems: (data: MsgSendItems): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgSendItems", value: data }),
    msgCreateTrade: (data: MsgCreateTrade): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgCreateTrade", value: data }),
    msgSetItemString: (data: MsgSetItemString): EncodeObject => ({ typeUrl: "/Pylonstech.pylons.pylons.MsgSetItemString", value: data }),
    
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
