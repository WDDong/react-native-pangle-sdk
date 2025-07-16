# my-pangle-sdk

React Native wrapper for the Pangle (穿山甲) iOS SDK with full TypeScript support.

## Features

- Initialize Pangle SDK
- Rewarded Video Ads
- Interstitial Ads
- Banner Ads
- Splash Ads
- Events support (show, click, close, reward)

## Installation

```bash
npm install my-pangle-sdk
```

## Usage

```tsx
import { Pangle } from 'my-pangle-sdk';

async function initSdk() {
  await Pangle.init('your-app-id');
  await Pangle.showRewardAd('your-reward-slot-id');
}

useEffect(() => {
  const onShow = () => console.log('Ad shown');
  const onReward = () => console.log('Reward received');

  Pangle.on('onAdShow', onShow);
  Pangle.on('onReward', onReward);

  return () => {
    Pangle.off('onAdShow', onShow);
    Pangle.off('onReward', onReward);
  };
}, []);
```

## iOS Setup

Make sure to add the `ios` folder as a native dependency via CocoaPods.

## License

MIT
