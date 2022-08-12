import * as React from 'react';
declare type TransitionChild<T> = React.ReactElement<T> | false | void;
declare type TransitionChildren<T> = TransitionChild<T> | Array<TransitionChild<T>>;
export declare type Props = {
    children: TransitionChildren<any>;
    flipMove?: boolean;
    preEnterPose?: string;
    enterPose?: string;
    exitPose?: string;
    animateOnMount?: boolean;
    enterAfterExit?: boolean;
    onRest?: () => void;
    [key: string]: any;
};
export declare type State = {
    displayedChildren: Array<React.ReactElement<any>>;
    finishedLeaving: {
        [key: string]: boolean;
    };
    hasInitialized: boolean;
    indexedChildren: {
        [key: string]: React.ReactElement<any>;
    };
    scheduleChildRemoval: (key: string) => void;
};
export {};
