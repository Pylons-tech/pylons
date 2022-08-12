import { Action } from '../../action';
import { ActionFactory } from '../../action/vector';
import { SpringProps } from './types';
declare const spring: (props?: SpringProps) => Action;
declare const vectorSpring: ActionFactory;
export default vectorSpring;
export { spring as springSole };
