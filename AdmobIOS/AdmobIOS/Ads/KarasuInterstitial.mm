

#import "platform/ios/view_controller.h"
#import "platform/ios/app_delegate.h"

#include "KarasuInterstitial.h"
#import "core/config/engine.h"
#import "SignalDeclarations.h"
#import "../DataHelper.h"

@import GoogleMobileAds;


@implementation KarasuInterstitial

-(void) load_ad: (NSString *)adUnit withIdentifier:(NSString *)identifier {
    
    GADRequest *request = [GADRequest request];
    self.identifier = identifier;
    
    [GADInterstitialAd loadWithAdUnitID:adUnit
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_LOADED_AD_SIGNAL_NAME, FAILED_STATE, nsStringToString(identifier));
            return;
        }
        
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
        Engine::get_singleton()->get_singleton_object("AdmobIOS")->emit_signal(ON_LOADED_AD_SIGNAL_NAME, SUCCEED_STATE, nsStringToString(identifier));
    }];
}

- (void)show_ad {
    if (self.interstitial != NULL) {
        [self.interstitial presentFromRootViewController:[AppDelegate viewController]];
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
