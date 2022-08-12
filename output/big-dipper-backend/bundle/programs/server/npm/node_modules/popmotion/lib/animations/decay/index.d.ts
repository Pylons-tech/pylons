import { Action } from '../../action';
import { ActionFactory } from '../../action/vector';
import { DecayProps } from './types';
declare const decay: (props?: DecayProps) => Action;
declare const vectorDecay: ActionFactory;
export default vectorDecay;
export { decay as decaySole };
