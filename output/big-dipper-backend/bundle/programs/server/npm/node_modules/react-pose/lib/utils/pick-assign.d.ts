declare type TestString = (key: string) => boolean;
declare type Props = {
    [key: string]: any;
};
export declare const pickAssign: (shouldPick: TestString, sources: Props[]) => Props;
export {};
