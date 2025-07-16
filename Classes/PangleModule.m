#import "PangleModule.h"
#import <PAGAdSDK/PAGAdSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface PangleModule () <PAGRewardedAdDelegate, PAGInterstitialAdDelegate, PAGBannerAdDelegate, PAGSplashAdDelegate>
@property (nonatomic, strong) PAGRewardedAd *rewardAd;
@property (nonatomic, strong) PAGInterstitialAd *interstitialAd;
@property (nonatomic, strong) PAGBannerAd *bannerAd;
@property (nonatomic, strong) UIView *bannerContainer;
@property (nonatomic, strong) PAGSplashAd *splashAd;
@end

@implementation PangleModule

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
  return @[@"PangleAdEvent"];
}

RCT_EXPORT_METHOD(initPangleSDK:(NSString *)appId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
      PAGConfig *config = [PAGConfig shareConfig];
      config.appID = appId;
      config.logLevel = PAGLogLevelDebug;

      [PAGAdSDK startWithConfig:config completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
          resolve(@(YES));
        } else {
          reject(@"init_failed", @"初始化失败", error);
        }
      }];
    }];
  });
}

#pragma mark - Reward Ad

RCT_EXPORT_METHOD(loadRewardAd:(NSString *)slotId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  PAGRewardedRequest *request = [[PAGRewardedRequest alloc] init];
  [PAGRewardedAd loadAdWithSlotID:slotId request:request completionHandler:^(PAGRewardedAd * _Nullable rewardedAd, NSError * _Nullable error) {
    if (error) {
      reject(@"load_failed", @"加载激励视频失败", error);
      return;
    }
    self.rewardAd = rewardedAd;
    self.rewardAd.delegate = self;
    resolve(@(YES));
  }];
}

RCT_EXPORT_METHOD(showRewardAd)
{
  UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
  [self.rewardAd presentFromRootViewController:rootVC];
}

#pragma mark - Interstitial Ad

RCT_EXPORT_METHOD(loadInterstitialAd:(NSString *)slotId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  PAGInterstitialRequest *request = [[PAGInterstitialRequest alloc] init];
  [PAGInterstitialAd loadAdWithSlotID:slotId request:request completionHandler:^(PAGInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
    if (error) {
      reject(@"load_failed", @"加载插屏广告失败", error);
      return;
    }
    self.interstitialAd = interstitialAd;
    self.interstitialAd.delegate = self;
    resolve(@(YES));
  }];
}

RCT_EXPORT_METHOD(showInterstitialAd)
{
  UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
  [self.interstitialAd presentFromRootViewController:rootVC];
}

#pragma mark - Banner Ad

RCT_EXPORT_METHOD(showBannerAd:(NSString *)slotId
                  x:(nonnull NSNumber *)x
                  y:(nonnull NSNumber *)y
                  width:(nonnull NSNumber *)width
                  height:(nonnull NSNumber *)height)
{
  PAGBannerRequest *request = [[PAGBannerRequest alloc] init];
  request.adSize = CGSizeMake([width floatValue], [height floatValue]);

  [PAGBannerAd loadAdWithSlotID:slotId request:request completionHandler:^(PAGBannerAd * _Nullable bannerAd, NSError * _Nullable error) {
    if (error) return;

    self.bannerAd = bannerAd;
    self.bannerAd.delegate = self;

    dispatch_async(dispatch_get_main_queue(), ^{
      UIView *container = [[UIView alloc] initWithFrame:CGRectMake([x floatValue], [y floatValue], [width floatValue], [height floatValue])];
      [container addSubview:bannerAd.bannerView];
      self.bannerContainer = container;

      UIWindow *window = [UIApplication sharedApplication].delegate.window;
      [window addSubview:container];
    });
  }];
}

RCT_EXPORT_METHOD(hideBannerAd)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.bannerContainer removeFromSuperview];
    self.bannerContainer = nil;
  });
}

#pragma mark - Splash Ad

RCT_EXPORT_METHOD(showSplashAd:(NSString *)slotId)
{
  PAGSplashRequest *request = [[PAGSplashRequest alloc] init];
  [PAGSplashAd loadAdWithSlotID:slotId request:request completionHandler:^(PAGSplashAd * _Nullable splashAd, NSError * _Nullable error) {
    if (error) return;

    self.splashAd = splashAd;
    self.splashAd.delegate = self;

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [splashAd presentFromRootViewController:window.rootViewController];
  }];
}

#pragma mark - Delegate Events

- (void)adDidShow:(PAGAd *)ad {
  [self sendEventWithName:@"PangleAdEvent" body:@{@"type": @"onAdShow"}];
}

- (void)adDidClick:(PAGAd *)ad {
  [self sendEventWithName:@"PangleAdEvent" body:@{@"type": @"onAdClick"}];
}

- (void)adDidDismiss:(PAGAd *)ad {
  [self sendEventWithName:@"PangleAdEvent" body:@{@"type": @"onAdClose"}];
}

- (void)adDidRewardEffective:(PAGAd *)ad {
  [self sendEventWithName:@"PangleAdEvent" body:@{@"type": @"onReward"}];
}

@end
