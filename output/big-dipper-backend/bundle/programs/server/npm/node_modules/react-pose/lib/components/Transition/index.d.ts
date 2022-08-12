import * as React from 'react';
import { Props, State } from './types';
declare class Transition extends React.Component<Props, State> {
    static defaultProps: {
        flipMove: boolean;
        enterAfterExit: boolean;
        preEnterPose: string;
        enterPose: string;
        exitPose: string;
    };
    static getDerivedStateFromProps: (props: Props, state: State) => Partial<State>;
    state: State;
    removeChild(key: string): void;
    shouldComponentUpdate(nextProps: Props, nextState: State): boolean;
    render(): React.ReactElement<any, string | ((props: any) => React.ReactElement<any, string | any | (new (props: any) => React.Component<any, any, any>)>) | (new (props: any) => React.Component<any, any, any>)>[];
}
export default Transition;
