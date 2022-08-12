import { DomPopmotionPoser, DomPopmotionConfig } from 'popmotion-pose';
export declare type ChildRegistration = {
    element: Element;
    poseConfig: DomPopmotionConfig;
    onRegistered: (poser: DomPopmotionPoser) => void;
};
export declare type CurrentPose = string | string[];
export interface PoseContextProps {
    registerChild?: (props: ChildRegistration) => void;
    onUnmount?: (child: DomPopmotionPoser) => any;
    getInitialPoseFromParent?: () => CurrentPose | void;
    getParentPoseConfig?: () => DomPopmotionConfig;
}
declare type RefFunc = (el: Element) => any;
export declare type PoseElementProps = {
    children?: any;
    pose?: CurrentPose;
    _pose?: CurrentPose;
    initialPose?: CurrentPose;
    withParent?: boolean;
    onPoseComplete?: (pose: CurrentPose) => any;
    onValueChange?: {
        [key: string]: (v: any) => any;
    };
    innerRef?: {
        current: any;
    } | RefFunc;
    [key: string]: any;
} & PoseContextProps;
export declare type ConfigFactory = (props: PoseElementProps) => DomPopmotionConfig;
export declare type PoseElementInternalProps = PoseElementProps & {
    elementType: any;
    poseConfig: DomPopmotionConfig | ConfigFactory;
};
export declare type PopStyle = {
    position: 'absolute';
    top: number;
    left: number;
    width: number;
    height: number;
};
export {};
