//
//  KarasuRewardedInterstitial.h
//  AdmobIOS
//
//  Created by Carlos Montes on 24/02/2024.
//

#ifndef KarasuRewardedInterstitial_h
#define KarasuRewardedInterstitial_h

@import GoogleMobileAds;

@interface KarasuRewardedInterstitial : NSObject<GADFullScreenContentDelegate>

@property(nonatomic, strong) GADRewardedInterstitialAd *rewardedInterstitial;
@property(nonatomic, strong) NSString *identifier;

-(void) load_ad: (NSString *)adUnit withIdentifier:(NSString *)identifier;
-(void) show_ad;
@end

#endif /* KarasuRewardedInterstitial_h */
