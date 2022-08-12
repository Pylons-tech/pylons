import { ForwardedRef } from 'react';
import { CompositionItem } from '../compositionItem';
export declare function useWidestCompositionForWidth(narrowToWideCompositionsProvider: () => IterableIterator<CompositionItem[]>, maxWidth: number): {
    items: CompositionItem[];
    ref: ForwardedRef<HTMLElement | null>;
    clearCache: () => void;
};
