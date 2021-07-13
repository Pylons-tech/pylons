import { Writer, Reader } from 'protobufjs/minimal';
import { Coin } from '../cosmos/base/v1beta1/coin';
export declare const protobufPackage = "pylons";
/** EntriesList is a struct to keep list of items and coins */
export interface EntriesList {
    CoinOutputs: CoinOutput[];
    ItemOutputs: ItemOutput[];
    ItemModifyOutputs: ItemModifyOutput[];
}
export interface CoinInput {
    Coin: string;
    Count: number;
}
export interface CoinOutput {
    ID: string;
    Coin: string;
    Count: string;
}
/** DoubleInputParam describes the bounds on an item input/output parameter of type float64 */
export interface DoubleInputParam {
    Key: string;
    /** The minimum legal value of this parameter. */
    MinValue: string;
    /** The maximum legal value of this parameter. */
    MaxValue: string;
}
/** DoubleWeightRange describes weight range that produce double value */
export interface DoubleWeightRange {
    /** This is added due to amino.Marshal does not support float variable */
    Lower: string;
    Upper: string;
    Weight: number;
}
/** LongParam describes the bounds on an item input/output parameter of type int64 */
export interface LongParam {
    Key: string;
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    Rate: string;
    WeightRanges: IntWeightRange[];
    /** When program is not empty, WeightRanges is ignored */
    Program: string;
}
/** IntWeightRange describes weight range that produce int value */
export interface IntWeightRange {
    Lower: number;
    Upper: number;
    Weight: number;
}
/** StringInputParam describes the bounds on an item input/output parameter of type string */
export interface StringInputParam {
    Key: string;
    /** The value of the parameter */
    Value: string;
}
export interface FeeInputParam {
    MinValue: number;
    MaxValue: number;
}
/** LongInputParam describes the bounds on an item input/output parameter of type int64 */
export interface LongInputParam {
    Key: string;
    MinValue: number;
    MaxValue: number;
}
/** ConditionList is a struct for describing  ItemInput expression conditions */
export interface ConditionList {
    Doubles: DoubleInputParam[];
    Longs: LongInputParam[];
    Strings: StringInputParam[];
}
/** ItemInput is a wrapper struct for Item for recipes */
export interface ItemInput {
    ID: string;
    Doubles: DoubleInputParam[];
    Longs: LongInputParam[];
    Strings: StringInputParam[];
    TransferFee: FeeInputParam | undefined;
    Conditions: ConditionList | undefined;
}
/** WeightedOutputs is to make structs which is using weight to be based on */
export interface WeightedOutputs {
    EntryIDs: string[];
    Weight: string;
}
/** StringParam describes an item input/output parameter of type string */
export interface StringParam {
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    Rate: string;
    Key: string;
    Value: string;
    /** When program is not empty, Value is ignored */
    Program: string;
}
/** DoubleParam describes the bounds on an item input/output parameter of type float64 */
export interface DoubleParam {
    /** The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive). */
    Rate: string;
    Key: string;
    WeightRanges: DoubleWeightRange[];
    /** When program is not empty, WeightRanges is ignored */
    Program: string;
}
/** ItemOutput models the continuum of valid outcomes for item generation in recipes */
export interface ItemOutput {
    ID: string;
    Doubles: DoubleParam[];
    Longs: LongParam[];
    Strings: StringParam[];
    TransferFee: number;
}
/** ItemModifyOutput describes what is modified from item input */
export interface ItemModifyOutput {
    ID: string;
    ItemInputRef: string;
    Doubles: DoubleParam[];
    Longs: LongParam[];
    Strings: StringParam[];
    TransferFee: number;
}
/** ItemModifyParams describes the fields that needs to be modified */
export interface ItemModifyParams {
    Doubles: DoubleParam[];
    Longs: LongParam[];
    Strings: StringParam[];
    TransferFee: number;
}
/** Item is a tradable asset */
export interface Item {
    NodeVersion: string;
    ID: string;
    Doubles: DoubleKeyValue[];
    Longs: LongKeyValue[];
    Strings: StringKeyValue[];
    CookbookID: string;
    Sender: string;
    OwnerRecipeID: string;
    OwnerTradeID: string;
    Tradable: boolean;
    LastUpdate: number;
    TransferFee: number;
}
/** DoubleKeyValue describes double key/value set */
export interface DoubleKeyValue {
    Key: string;
    Value: string;
}
/** LongKeyValue describes long key/value set */
export interface LongKeyValue {
    Key: string;
    Value: number;
}
/** StringKeyValue describes string key/value set */
export interface StringKeyValue {
    Key: string;
    Value: string;
}
/** TradeItemInput is a wrapper struct for Item for trades */
export interface TradeItemInput {
    ItemInput: ItemInput | undefined;
    CookbookID: string;
}
/** LockedCoinDescribe describes the locked coin struct */
export interface LockedCoinDescribe {
    ID: string;
    Amount: Coin[];
}
/** ShortenRecipe is a struct to manage shorten recipes */
export interface ShortenRecipe {
    ID: string;
    CookbookID: string;
    Name: string;
    Description: string;
    Sender: string;
}
export interface Execution {
    NodeVersion: string;
    ID: string;
    RecipeID: string;
    CookbookID: string;
    CoinInputs: Coin[];
    ItemInputs: Item[];
    BlockHeight: number;
    Sender: string;
    Completed: boolean;
}
export interface Cookbook {
    NodeVersion: string;
    ID: string;
    Name: string;
    Description: string;
    Version: string;
    Developer: string;
    Level: number;
    SupportEmail: string;
    CostPerBlock: number;
    Sender: string;
}
export interface Recipe {
    NodeVersion: string;
    ID: string;
    CookbookID: string;
    Name: string;
    CoinInputs: CoinInput[];
    ItemInputs: ItemInput[];
    Entries: EntriesList | undefined;
    Outputs: WeightedOutputs[];
    Description: string;
    BlockInterval: number;
    Sender: string;
    Disabled: boolean;
    ExtraInfo: string;
}
export interface Trade {
    NodeVersion: string;
    ID: string;
    CoinInputs: CoinInput[];
    ItemInputs: TradeItemInput[];
    CoinOutputs: Coin[];
    ItemOutputs: Item[];
    ExtraInfo: string;
    Sender: string;
    FulFiller: string;
    Disabled: boolean;
    Completed: boolean;
}
export interface StripePrice {
    Amount: number;
    Currency: string;
    Description: string;
    Images: string[];
    Name: string;
    /** string TaxRates = 7; */
    Quantity: number;
}
export interface StripeInventory {
    Quantity: number;
    Type: string;
    Value: string;
}
export declare const EntriesList: {
    encode(message: EntriesList, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): EntriesList;
    fromJSON(object: any): EntriesList;
    toJSON(message: EntriesList): unknown;
    fromPartial(object: DeepPartial<EntriesList>): EntriesList;
};
export declare const CoinInput: {
    encode(message: CoinInput, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): CoinInput;
    fromJSON(object: any): CoinInput;
    toJSON(message: CoinInput): unknown;
    fromPartial(object: DeepPartial<CoinInput>): CoinInput;
};
export declare const CoinOutput: {
    encode(message: CoinOutput, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): CoinOutput;
    fromJSON(object: any): CoinOutput;
    toJSON(message: CoinOutput): unknown;
    fromPartial(object: DeepPartial<CoinOutput>): CoinOutput;
};
export declare const DoubleInputParam: {
    encode(message: DoubleInputParam, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): DoubleInputParam;
    fromJSON(object: any): DoubleInputParam;
    toJSON(message: DoubleInputParam): unknown;
    fromPartial(object: DeepPartial<DoubleInputParam>): DoubleInputParam;
};
export declare const DoubleWeightRange: {
    encode(message: DoubleWeightRange, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): DoubleWeightRange;
    fromJSON(object: any): DoubleWeightRange;
    toJSON(message: DoubleWeightRange): unknown;
    fromPartial(object: DeepPartial<DoubleWeightRange>): DoubleWeightRange;
};
export declare const LongParam: {
    encode(message: LongParam, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): LongParam;
    fromJSON(object: any): LongParam;
    toJSON(message: LongParam): unknown;
    fromPartial(object: DeepPartial<LongParam>): LongParam;
};
export declare const IntWeightRange: {
    encode(message: IntWeightRange, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): IntWeightRange;
    fromJSON(object: any): IntWeightRange;
    toJSON(message: IntWeightRange): unknown;
    fromPartial(object: DeepPartial<IntWeightRange>): IntWeightRange;
};
export declare const StringInputParam: {
    encode(message: StringInputParam, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): StringInputParam;
    fromJSON(object: any): StringInputParam;
    toJSON(message: StringInputParam): unknown;
    fromPartial(object: DeepPartial<StringInputParam>): StringInputParam;
};
export declare const FeeInputParam: {
    encode(message: FeeInputParam, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): FeeInputParam;
    fromJSON(object: any): FeeInputParam;
    toJSON(message: FeeInputParam): unknown;
    fromPartial(object: DeepPartial<FeeInputParam>): FeeInputParam;
};
export declare const LongInputParam: {
    encode(message: LongInputParam, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): LongInputParam;
    fromJSON(object: any): LongInputParam;
    toJSON(message: LongInputParam): unknown;
    fromPartial(object: DeepPartial<LongInputParam>): LongInputParam;
};
export declare const ConditionList: {
    encode(message: ConditionList, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ConditionList;
    fromJSON(object: any): ConditionList;
    toJSON(message: ConditionList): unknown;
    fromPartial(object: DeepPartial<ConditionList>): ConditionList;
};
export declare const ItemInput: {
    encode(message: ItemInput, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemInput;
    fromJSON(object: any): ItemInput;
    toJSON(message: ItemInput): unknown;
    fromPartial(object: DeepPartial<ItemInput>): ItemInput;
};
export declare const WeightedOutputs: {
    encode(message: WeightedOutputs, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): WeightedOutputs;
    fromJSON(object: any): WeightedOutputs;
    toJSON(message: WeightedOutputs): unknown;
    fromPartial(object: DeepPartial<WeightedOutputs>): WeightedOutputs;
};
export declare const StringParam: {
    encode(message: StringParam, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): StringParam;
    fromJSON(object: any): StringParam;
    toJSON(message: StringParam): unknown;
    fromPartial(object: DeepPartial<StringParam>): StringParam;
};
export declare const DoubleParam: {
    encode(message: DoubleParam, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): DoubleParam;
    fromJSON(object: any): DoubleParam;
    toJSON(message: DoubleParam): unknown;
    fromPartial(object: DeepPartial<DoubleParam>): DoubleParam;
};
export declare const ItemOutput: {
    encode(message: ItemOutput, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemOutput;
    fromJSON(object: any): ItemOutput;
    toJSON(message: ItemOutput): unknown;
    fromPartial(object: DeepPartial<ItemOutput>): ItemOutput;
};
export declare const ItemModifyOutput: {
    encode(message: ItemModifyOutput, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemModifyOutput;
    fromJSON(object: any): ItemModifyOutput;
    toJSON(message: ItemModifyOutput): unknown;
    fromPartial(object: DeepPartial<ItemModifyOutput>): ItemModifyOutput;
};
export declare const ItemModifyParams: {
    encode(message: ItemModifyParams, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ItemModifyParams;
    fromJSON(object: any): ItemModifyParams;
    toJSON(message: ItemModifyParams): unknown;
    fromPartial(object: DeepPartial<ItemModifyParams>): ItemModifyParams;
};
export declare const Item: {
    encode(message: Item, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Item;
    fromJSON(object: any): Item;
    toJSON(message: Item): unknown;
    fromPartial(object: DeepPartial<Item>): Item;
};
export declare const DoubleKeyValue: {
    encode(message: DoubleKeyValue, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): DoubleKeyValue;
    fromJSON(object: any): DoubleKeyValue;
    toJSON(message: DoubleKeyValue): unknown;
    fromPartial(object: DeepPartial<DoubleKeyValue>): DoubleKeyValue;
};
export declare const LongKeyValue: {
    encode(message: LongKeyValue, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): LongKeyValue;
    fromJSON(object: any): LongKeyValue;
    toJSON(message: LongKeyValue): unknown;
    fromPartial(object: DeepPartial<LongKeyValue>): LongKeyValue;
};
export declare const StringKeyValue: {
    encode(message: StringKeyValue, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): StringKeyValue;
    fromJSON(object: any): StringKeyValue;
    toJSON(message: StringKeyValue): unknown;
    fromPartial(object: DeepPartial<StringKeyValue>): StringKeyValue;
};
export declare const TradeItemInput: {
    encode(message: TradeItemInput, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): TradeItemInput;
    fromJSON(object: any): TradeItemInput;
    toJSON(message: TradeItemInput): unknown;
    fromPartial(object: DeepPartial<TradeItemInput>): TradeItemInput;
};
export declare const LockedCoinDescribe: {
    encode(message: LockedCoinDescribe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): LockedCoinDescribe;
    fromJSON(object: any): LockedCoinDescribe;
    toJSON(message: LockedCoinDescribe): unknown;
    fromPartial(object: DeepPartial<LockedCoinDescribe>): LockedCoinDescribe;
};
export declare const ShortenRecipe: {
    encode(message: ShortenRecipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): ShortenRecipe;
    fromJSON(object: any): ShortenRecipe;
    toJSON(message: ShortenRecipe): unknown;
    fromPartial(object: DeepPartial<ShortenRecipe>): ShortenRecipe;
};
export declare const Execution: {
    encode(message: Execution, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Execution;
    fromJSON(object: any): Execution;
    toJSON(message: Execution): unknown;
    fromPartial(object: DeepPartial<Execution>): Execution;
};
export declare const Cookbook: {
    encode(message: Cookbook, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Cookbook;
    fromJSON(object: any): Cookbook;
    toJSON(message: Cookbook): unknown;
    fromPartial(object: DeepPartial<Cookbook>): Cookbook;
};
export declare const Recipe: {
    encode(message: Recipe, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Recipe;
    fromJSON(object: any): Recipe;
    toJSON(message: Recipe): unknown;
    fromPartial(object: DeepPartial<Recipe>): Recipe;
};
export declare const Trade: {
    encode(message: Trade, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): Trade;
    fromJSON(object: any): Trade;
    toJSON(message: Trade): unknown;
    fromPartial(object: DeepPartial<Trade>): Trade;
};
export declare const StripePrice: {
    encode(message: StripePrice, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): StripePrice;
    fromJSON(object: any): StripePrice;
    toJSON(message: StripePrice): unknown;
    fromPartial(object: DeepPartial<StripePrice>): StripePrice;
};
export declare const StripeInventory: {
    encode(message: StripeInventory, writer?: Writer): Writer;
    decode(input: Reader | Uint8Array, length?: number): StripeInventory;
    fromJSON(object: any): StripeInventory;
    toJSON(message: StripeInventory): unknown;
    fromPartial(object: DeepPartial<StripeInventory>): StripeInventory;
};
declare type Builtin = Date | Function | Uint8Array | string | number | undefined;
export declare type DeepPartial<T> = T extends Builtin ? T : T extends Array<infer U> ? Array<DeepPartial<U>> : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>> : T extends {} ? {
    [K in keyof T]?: DeepPartial<T[K]>;
} : Partial<T>;
export {};
