//
//  KarasuRewarded.h
//  AdmobIOS
//
//  Created by Carlos Montes on 24/02/2024.
//

#ifndef KarasuRewarded_h
#define KarasuRewarded_h

@import GoogleMobileAds;

@interface KarasuRewarded : NSObject<GADFullScreenContentDelegate>

@property(nonatomic, strong) GADRewardedAd *rewarded;
@property(nonatomic, strong) NSString *identifier;

-(void) load_ad: (NSString *)adUnit withIdentifier:(NSString *)identifier;
-(void) show_ad;
@end

#endif /* KarasuRewarded_h */
