// THIS FILE IS GENERATED AUTOMATICALLY. DO NOT MODIFY.

import { StdFee } from "@cosmjs/launchpad";
import { SigningStargateClient } from "@cosmjs/stargate";
import { Registry, OfflineSigner, EncodeObject, DirectSecp256k1HdWallet } from "@cosmjs/proto-signing";
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
    msgFulfillTrade: (data: MsgFulfillTrade): EncodeObject => ({ typeUrl: "/pylons.MsgFulfillTrade", value: data }),
    msgSendItems: (data: MsgSendItems): EncodeObject => ({ typeUrl: "/pylons.MsgSendItems", value: data }),
    msgEnableRecipe: (data: MsgEnableRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgEnableRecipe", value: data }),
    msgFiatItem: (data: MsgFiatItem): EncodeObject => ({ typeUrl: "/pylons.MsgFiatItem", value: data }),
    msgCreateAccount: (data: MsgCreateAccount): EncodeObject => ({ typeUrl: "/pylons.MsgCreateAccount", value: data }),
    msgSendCoins: (data: MsgSendCoins): EncodeObject => ({ typeUrl: "/pylons.MsgSendCoins", value: data }),
    msgCreateTrade: (data: MsgCreateTrade): EncodeObject => ({ typeUrl: "/pylons.MsgCreateTrade", value: data }),
    msgUpdateRecipe: (data: MsgUpdateRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgUpdateRecipe", value: data }),
    msgCreateCookbook: (data: MsgCreateCookbook): EncodeObject => ({ typeUrl: "/pylons.MsgCreateCookbook", value: data }),
    msgEnableTrade: (data: MsgEnableTrade): EncodeObject => ({ typeUrl: "/pylons.MsgEnableTrade", value: data }),
    msgCreateRecipe: (data: MsgCreateRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgCreateRecipe", value: data }),
    msgGetPylons: (data: MsgGetPylons): EncodeObject => ({ typeUrl: "/pylons.MsgGetPylons", value: data }),
    msgUpdateItemString: (data: MsgUpdateItemString): EncodeObject => ({ typeUrl: "/pylons.MsgUpdateItemString", value: data }),
    msgGoogleIAPGetPylons: (data: MsgGoogleIAPGetPylons): EncodeObject => ({ typeUrl: "/pylons.MsgGoogleIAPGetPylons", value: data }),
    msgUpdateCookbook: (data: MsgUpdateCookbook): EncodeObject => ({ typeUrl: "/pylons.MsgUpdateCookbook", value: data }),
    msgExecuteRecipe: (data: MsgExecuteRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgExecuteRecipe", value: data }),
    msgCheckExecution: (data: MsgCheckExecution): EncodeObject => ({ typeUrl: "/pylons.MsgCheckExecution", value: data }),
    msgDisableRecipe: (data: MsgDisableRecipe): EncodeObject => ({ typeUrl: "/pylons.MsgDisableRecipe", value: data }),
    msgDisableTrade: (data: MsgDisableTrade): EncodeObject => ({ typeUrl: "/pylons.MsgDisableTrade", value: data }),
    
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
