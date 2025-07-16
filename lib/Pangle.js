import { NativeModules, NativeEventEmitter } from 'react-native';
const { PangleModule } = NativeModules;
const emitter = new NativeEventEmitter(PangleModule);
const eventListeners = {
    onAdShow: [],
    onAdClick: [],
    onAdClose: [],
    onReward: [],
};
emitter.addListener('PangleAdEvent', (event) => {
    const callbacks = eventListeners[event.type] || [];
    callbacks.forEach((cb) => cb());
});
function on(eventType, callback) {
    if (eventListeners[eventType]) {
        eventListeners[eventType].push(callback);
    }
}
function off(eventType, callback) {
    if (eventListeners[eventType]) {
        eventListeners[eventType] = eventListeners[eventType].filter(cb => cb !== callback);
    }
}
const Pangle = {
    init(appId) {
        return PangleModule.initPangleSDK(appId);
    },
    async showRewardAd(slotId) {
        await PangleModule.loadRewardAd(slotId);
        PangleModule.showRewardAd();
    },
    async showInterstitialAd(slotId) {
        await PangleModule.loadInterstitialAd(slotId);
        PangleModule.showInterstitialAd();
    },
    showBannerAd(slotId, position = { x: 0, y: 0, width: 320, height: 50 }) {
        const { x, y, width, height } = position;
        PangleModule.showBannerAd(slotId, x, y, width, height);
    },
    hideBannerAd() {
        PangleModule.hideBannerAd();
    },
    showSplashAd(slotId) {
        PangleModule.showSplashAd(slotId);
    },
    on,
    off,
};
export default Pangle;
