import { ComponentType, HTMLProps } from 'react';
import { PoseElementProps } from './components/PoseElement/types';
import { DomPopmotionConfig } from 'popmotion-pose';
declare type DomPopmotionConfigFactory<T> = (props: PoseElementProps & T) => DomPopmotionConfig;
export declare type ComponentFactory<T> = (poseConfig?: DomPopmotionConfig | DomPopmotionConfigFactory<T>) => ComponentType<PoseElementProps & T>;
export declare type Posed = {
    <T>(component: ComponentType<T>): ComponentFactory<T>;
    [key: string]: ComponentFactory<HTMLProps<any>>;
};
declare const posed: Posed;
export default posed;
