import { CompositionItem } from '../compositionItem';
export declare function useWidestComposition(narrowToWideCompositionsProvider: () => IterableIterator<CompositionItem[]>, maxWidth?: number): {
    items: CompositionItem[];
    ref: (element: HTMLElement | null) => void;
    clearCache: () => void;
};
