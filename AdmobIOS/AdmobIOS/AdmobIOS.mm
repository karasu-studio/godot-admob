//
//  AdmobIOS.m
//  AdmobIOS
//
//  Created by Carlos Montes on 16/02/2024.
//

#import "AdmobIOS.h"
#import <Foundation/Foundation.h>
#import "platform/ios/app_delegate.h"
#import "platform/ios/view_controller.h"
#import "GoogleMobileAds/GoogleMobileAds.h"
#import "Ads/KarasuInterstitial.h"
#import "Ads/KarasuRewarded.h"
#import "Ads/KarasuRewardedInterstitial.h"
#import "Ads/SignalDeclarations.h"
#import "DataHelper.h"
#import "core/config/engine.h"


NSMutableDictionary *preloaded_ads;


AdmobIOS *AdmobIOS::instance = NULL;

void AdmobIOS::_bind_methods() {
    ClassDB::bind_method(D_METHOD("initialize"), &AdmobIOS::initialize);
    
    ClassDB::bind_method(D_METHOD("loadInterstitial", "adUnit"), &AdmobIOS::loadInterstitial);
    ClassDB::bind_method(D_METHOD("showInterstitial", "identifier"), &AdmobIOS::showInterstitial);
    
    ClassDB::bind_method(D_METHOD("loadRewarded", "adUnit"), &AdmobIOS::loadRewarded);
    ClassDB::bind_method(D_METHOD("showRewarded", "identifier"), &AdmobIOS::showRewarded);
    
    ClassDB::bind_method(D_METHOD("loadRewardedInterstitial", "adUnit"), &AdmobIOS::loadRewardedInterstitial);
    ClassDB::bind_method(D_METHOD("showRewardedInterstitial", "identifier"), &AdmobIOS::showRewardedInterstitial);
    
    ClassDB::bind_method(D_METHOD("removeAd", "identifier"), &AdmobIOS::removeAd);
    ClassDB::bind_method(D_METHOD("onDismissedAd", "result", "identifier"), &AdmobIOS::onDismissedAd);
    
    // Signals
    
    ADD_SIGNAL(MethodInfo(ON_INITIALIZED_SIGNAL_NAME, PropertyInfo(Variant::STRING, "result")));
    ADD_SIGNAL(MethodInfo(ON_LOADED_AD_SIGNAL_NAME, PropertyInfo(Variant::STRING, "result"), PropertyInfo(Variant::STRING, "identifier")));
    ADD_SIGNAL(MethodInfo(ON_SHOWED_AD_SIGNAL_NAME, PropertyInfo(Variant::STRING, "result"), PropertyInfo(Variant::STRING, "identifier")));
    ADD_SIGNAL(MethodInfo(ON_GRANTED_REWARD_SIGNAL_NAME, PropertyInfo(Variant::STRING, "result"), PropertyInfo(Variant::STRING, "identifier"), PropertyInfo(Variant::STRING, "parameters")));
    ADD_SIGNAL(MethodInfo(ON_DISMISSED_AD_SIGNAL_NAME, PropertyInfo(Variant::STRING, "result"), PropertyInfo(Variant::STRING, "identifier")));
    ADD_SIGNAL(MethodInfo(ON_AD_CLICKED_SIGNAL_NAME, PropertyInfo(Variant::STRING, "result"), PropertyInfo(Variant::STRING, "identifier")));
    ADD_SIGNAL(MethodInfo(ON_AD_IMPRESSION_SIGNAL_NAME, PropertyInfo(Variant::STRING, "result"), PropertyInfo(Variant::STRING, "identifier")));
}

AdmobIOS *AdmobIOS::get_singleton() {
    return instance;
}

void AdmobIOS::initialize() {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus *_Nonnull status)
     {
        preloaded_ads = [[NSMutableDictionary alloc] init];
        emit_signal(ON_INITIALIZED_SIGNAL_NAME, SUCCEED_STATE);
    }];
    
    connect(ON_DISMISSED_AD_SIGNAL_NAME, Callable(this, "onDismissedAd"));
}

void AdmobIOS::loadInterstitial(String adUnit, String identifier) {
    KarasuInterstitial *interstitial = [[KarasuInterstitial alloc] init];
    
    [interstitial load_ad:stringToNSString(adUnit) withIdentifier:stringToNSString(identifier)];
    [preloaded_ads setValue:interstitial forKey:stringToNSString(identifier)];
}

void AdmobIOS::showInterstitial(String identifier) {
    KarasuInterstitial *currentInterstitial = preloaded_ads[stringToNSString(identifier)];
    
    if (currentInterstitial != NULL) {
        [currentInterstitial show_ad];
    } else {
        emit_signal(ON_SHOWED_AD_SIGNAL_NAME, FAILED_STATE, identifier);
    }
}

void AdmobIOS::loadRewarded(String adUnit, String identifier) {
    KarasuRewarded *rewarded = [[KarasuRewarded alloc] init];
    [rewarded load_ad:stringToNSString(adUnit) withIdentifier:stringToNSString(identifier)];
    
    [preloaded_ads setValue:rewarded forKey:stringToNSString(identifier)];
}

void AdmobIOS::showRewarded(String identifier) {
    KarasuRewarded *currentReward = preloaded_ads[stringToNSString(identifier)];
    if (currentReward != NULL) {
        [currentReward show_ad];
    } else {
        emit_signal(ON_SHOWED_AD_SIGNAL_NAME, FAILED_STATE, identifier);
    }
}

void AdmobIOS::loadRewardedInterstitial(String adUnit, String identifier){
    KarasuRewardedInterstitial *rewardedInterstitial = [[KarasuRewardedInterstitial alloc] init];
    
    [rewardedInterstitial load_ad:stringToNSString(adUnit) withIdentifier:stringToNSString(identifier)];
    [preloaded_ads setValue:rewardedInterstitial forKey:stringToNSString(identifier)];
}

void AdmobIOS::showRewardedInterstitial(String identifier) {
    KarasuRewardedInterstitial *rewardedInterstitial = preloaded_ads[stringToNSString(identifier)];
    
    if (rewardedInterstitial != NULL) {
        [rewardedInterstitial show_ad];
    } else {
        emit_signal(ON_SHOWED_AD_SIGNAL_NAME, FAILED_STATE, identifier);
    }
}

void AdmobIOS::removeAd(String identifier) {
    [preloaded_ads removeObjectForKey:stringToNSString(identifier)];
}

void AdmobIOS::onDismissedAd(String result, String identifier) {
    NSLog(@"Dismissed ad will be removed!");
    removeAd(identifier);
}


AdmobIOS::AdmobIOS() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;
}

AdmobIOS::~AdmobIOS() {
    instance = NULL;
}
