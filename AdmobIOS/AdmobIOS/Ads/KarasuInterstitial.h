//
//  KarasuInterstitial.h
//  AdmobIOS
//
//  Created by Carlos Montes on 23/02/2024.
//

#ifndef KarasuInterstitial_h
#define KarasuInterstitial_h

@import GoogleMobileAds;

@interface KarasuInterstitial : NSObject<GADFullScreenContentDelegate>
@property(nonatomic, strong) GADInterstitialAd *interstitial;
@property(nonatomic, strong) NSString *identifier;

-(void) load_ad: (NSString *)adUnit withIdentifier:(NSString *)identifier;
-(void) show_ad;
@end

#endif /* KarasuInterstitial_h */
