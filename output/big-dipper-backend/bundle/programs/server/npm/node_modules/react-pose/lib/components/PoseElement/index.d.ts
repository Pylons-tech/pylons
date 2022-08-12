import React, { PureComponent } from 'react';
import { DomPopmotionPoser, DomPopmotionConfig } from 'popmotion-pose';
import { ChildRegistration, CurrentPose, PoseElementInternalProps, PopStyle } from './types';
declare const PoseParentConsumer: React.ExoticComponent<React.ConsumerProps<{}>>;
export { PoseParentConsumer };
declare class PoseElement extends PureComponent<PoseElementInternalProps> {
    props: PoseElementInternalProps;
    poser: DomPopmotionPoser;
    poseConfig: DomPopmotionConfig;
    ref: Element;
    styleProps: {
        [key: string]: any;
    };
    shouldForwardProp: (key: string) => boolean;
    children: Set<ChildRegistration>;
    popStyle?: PopStyle;
    private childrenHandlers;
    constructor(props: PoseElementInternalProps);
    getInitialPose(): CurrentPose | void;
    getFirstPose(): CurrentPose | void;
    getSetProps(): {
        [key: string]: any;
        children?: any;
        withParent?: boolean;
    };
    setRef: (ref: Element) => void;
    componentDidMount(): void;
    getSnapshotBeforeUpdate(): null;
    componentDidUpdate(prevProps: PoseElementInternalProps): void;
    componentWillUnmount(): void;
    initPoser(poser: DomPopmotionPoser): void;
    setPose(pose: CurrentPose): void;
    flushChildren(): void;
    render(): JSX.Element;
}
export { PoseElement };
