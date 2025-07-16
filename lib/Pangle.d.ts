type AdEventType = 'onAdShow' | 'onAdClick' | 'onAdClose' | 'onReward';
type Position = {
    x: number;
    y: number;
    width: number;
    height: number;
};
type Listener = () => void;
declare function on(eventType: AdEventType, callback: Listener): void;
declare function off(eventType: AdEventType, callback: Listener): void;
declare const Pangle: {
    init(appId: string): Promise<boolean>;
    showRewardAd(slotId: string): Promise<void>;
    showInterstitialAd(slotId: string): Promise<void>;
    showBannerAd(slotId: string, position?: Position): void;
    hideBannerAd(): void;
    showSplashAd(slotId: string): void;
    on: typeof on;
    off: typeof off;
};
export default Pangle;
