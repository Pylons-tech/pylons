/**
 * Copyright 2017-present Palantir Technologies
 * @license MIT
 */
export declare class CanvasBuffer {
    screenWidth: number;
    screenHeight: number;
    devicePixelRatio: number;
    /**
     * Resizes the canvas' internal pixel buffer to match the devicePixelRatio
     */
    static sizePixels(ctx: CanvasRenderingContext2D, screenWidth: number, screenHeight: number, devicePixelRatio: number): void;
    canvas: HTMLCanvasElement;
    ctx: CanvasRenderingContext2D;
    pixelWidth: number;
    pixelHeight: number;
    constructor(screenWidth: number, screenHeight: number, devicePixelRatio?: number);
    blit(ctx: CanvasRenderingContext2D, x?: number, y?: number): void;
    blitCenter(ctx: CanvasRenderingContext2D, x?: number, y?: number): void;
    /**
     * Changes the size of the underlying canvas in screen space, respecting the
     * current devicePixelRatio.
     *
     * @param center - optionally enable a translate transformation moving the
     *                 origin to the center of the canvas.
     */
    resize(screenWidth: number, screenHeight: number, center?: boolean): this;
    /**
     * Temporarily resets the current context transformation and fills the
     * entire canvas with the provided color. If no color is provided, the
     * canvas is cleared instead.
     */
    clear(color?: string): this;
    getImageData(): ImageData;
}
