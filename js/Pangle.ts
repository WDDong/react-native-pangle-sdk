import { NativeModules, NativeEventEmitter } from 'react-native';

type AdEventType = 'onAdShow' | 'onAdClick' | 'onAdClose' | 'onReward';

type Position = {
  x: number;
  y: number;
  width: number;
  height: number;
};

type Listener = () => void;

const { PangleModule } = NativeModules;
const emitter = new NativeEventEmitter(PangleModule);

const eventListeners: Record<AdEventType, Listener[]> = {
  onAdShow: [],
  onAdClick: [],
  onAdClose: [],
  onReward: [],
};

emitter.addListener('PangleAdEvent', (event: { type: AdEventType }) => {
  const callbacks = eventListeners[event.type] || [];
  callbacks.forEach((cb) => cb());
});

function on(eventType: AdEventType, callback: Listener) {
  if (eventListeners[eventType]) {
    eventListeners[eventType].push(callback);
  }
}

function off(eventType: AdEventType, callback: Listener) {
  if (eventListeners[eventType]) {
    eventListeners[eventType] = eventListeners[eventType].filter(cb => cb !== callback);
  }
}

const Pangle = {
  init(appId: string): Promise<boolean> {
    return PangleModule.initPangleSDK(appId);
  },

  async showRewardAd(slotId: string): Promise<void> {
    await PangleModule.loadRewardAd(slotId);
    PangleModule.showRewardAd();
  },

  async showInterstitialAd(slotId: string): Promise<void> {
    await PangleModule.loadInterstitialAd(slotId);
    PangleModule.showInterstitialAd();
  },

  showBannerAd(slotId: string, position: Position = { x: 0, y: 0, width: 320, height: 50 }) {
    const { x, y, width, height } = position;
    PangleModule.showBannerAd(slotId, x, y, width, height);
  },

  hideBannerAd() {
    PangleModule.hideBannerAd();
  },

  showSplashAd(slotId: string) {
    PangleModule.showSplashAd(slotId);
  },

  on,
  off,
};

export default Pangle;
