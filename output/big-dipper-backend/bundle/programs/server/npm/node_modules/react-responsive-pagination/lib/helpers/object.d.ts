export declare function objectUnzip<K extends string, V>(object: {
    [key in K]: V;
}): [K[], V[]];
export declare function objectZip<K extends string, V>(keys: K[], values: V[]): {
    [key in K]: V;
};
