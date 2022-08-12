import * as React from 'react';
import { Props } from './types';
export default class PoseGroup extends React.Component<Props> {
    static defaultProps: {
        flipMove: boolean;
    };
    render(): JSX.Element;
}
