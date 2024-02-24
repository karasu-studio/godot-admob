//
//  KarasuRewardedInterstitial.m
//  AdmobIOS
//
//  Created by Carlos Montes on 24/02/2024.
//

#import "platform/ios/view_controller.h"
#import "platform/ios/app_delegate.h"

#include "KarasuRewardedInterstitial.h"
#import "core/config/engine.h"
#import "SignalDeclarations.h"
#import "../DataHelper.h"

@import GoogleMobileAds;

@implementation KarasuRewardedInterstitial

- (void)load_ad:(NSString *)adUnit withIdentifier:(NSString *)identifier {
    GADRequest *request = [GADRequest request];
    self.identifier = identifier;
    
    [GADRewardedInterstitialAd
     loadWithAdUnitID:adUnit
     request:request
     completionHandler:^(GADRewardedInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Rewarded Interstitial ad failed to load with error: %@", [error localizedDescription]);
            Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_LOADED_AD_SIGNAL_NAME, FAILED_STATE, nsStringToString(identifier));
            return;
        }
        self.rewardedInterstitial = ad;
        self.rewardedInterstitial.fullScreenContentDelegate = self;
        Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_LOADED_AD_SIGNAL_NAME, SUCCEED_STATE, nsStringToString(identifier));
    }];
}

- (void)show_ad {
    if (self.rewardedInterstitial != NULL) {
        [self.rewardedInterstitial presentFromRootViewController:[AppDelegate viewController]
                            userDidEarnRewardHandler:^{
            GADAdReward *reward = self.rewardedInterstitial.adReward;
            String rewardParams = nsStringToString([NSString stringWithFormat:@"type=%@&amount=%@", reward.type, reward.amount]);
            
            Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_GRANTED_REWARD_SIGNAL_NAME, SUCCEED_STATE, nsStringToString(self.identifier), rewardParams);
        }];
    }
}

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_AD_IMPRESSION_SIGNAL_NAME, SUCCEED_STATE, nsStringToString(self.identifier));
}

/// Tells the delegate that a click has been recorded for the ad.
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad {
    Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_AD_CLICKED_SIGNAL_NAME, SUCCEED_STATE, nsStringToString(self.identifier));
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_SHOWED_AD_SIGNAL_NAME, FAILED_STATE, nsStringToString(self.identifier));
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_SHOWED_AD_SIGNAL_NAME, SUCCEED_STATE, nsStringToString(self.identifier));
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_DISMISSED_AD_SIGNAL_NAME, SUCCEED_STATE, nsStringToString(self.identifier));
}

@end
