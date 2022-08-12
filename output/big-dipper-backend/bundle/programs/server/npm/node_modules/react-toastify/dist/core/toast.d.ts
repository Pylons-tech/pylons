import { OnChangeCallback } from './eventManager';
import { ToastContent, ToastOptions, Id, UpdateOptions, ClearWaitingQueueParams, TypeOptions } from '../types';
declare function toast(content: ToastContent, options?: ToastOptions): Id;
declare namespace toast {
    var loading: (content: ToastContent<unknown>, options?: ToastOptions<{}> | undefined) => Id;
    var promise: typeof handlePromise;
    var success: (content: ToastContent<unknown>, options?: ToastOptions<{}> | undefined) => Id;
    var info: (content: ToastContent<unknown>, options?: ToastOptions<{}> | undefined) => Id;
    var error: (content: ToastContent<unknown>, options?: ToastOptions<{}> | undefined) => Id;
    var warning: (content: ToastContent<unknown>, options?: ToastOptions<{}> | undefined) => Id;
    var warn: (content: ToastContent<unknown>, options?: ToastOptions<{}> | undefined) => Id;
    var dark: (content: ToastContent<unknown>, options?: ToastOptions<{}> | undefined) => Id;
    var dismiss: (id?: Id | undefined) => void;
    var clearWaitingQueue: (params?: ClearWaitingQueueParams) => void;
    var isActive: (id: Id) => boolean;
    var update: (toastId: Id, options?: UpdateOptions<unknown>) => void;
    var done: (id: Id) => void;
    var onChange: (callback: OnChangeCallback) => () => void;
    var POSITION: {
        TOP_LEFT: import("../types").ToastPosition;
        TOP_RIGHT: import("../types").ToastPosition;
        TOP_CENTER: import("../types").ToastPosition;
        BOTTOM_LEFT: import("../types").ToastPosition;
        BOTTOM_RIGHT: import("../types").ToastPosition;
        BOTTOM_CENTER: import("../types").ToastPosition;
    };
    var TYPE: {
        INFO: TypeOptions;
        SUCCESS: TypeOptions;
        WARNING: TypeOptions;
        ERROR: TypeOptions;
        DEFAULT: TypeOptions;
    };
}
export interface ToastPromiseParams<T = unknown> {
    pending?: string | UpdateOptions<void>;
    success?: string | UpdateOptions<T>;
    error?: string | UpdateOptions<any>;
}
declare function handlePromise<T = unknown>(promise: Promise<T> | (() => Promise<T>), { pending, error, success }: ToastPromiseParams<T>, options?: ToastOptions): Promise<T>;
export { toast };
