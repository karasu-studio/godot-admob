//
//  AdmobIOS.h
//  AdmobIOS
//
//  Created by Carlos Montes on 16/02/2024.
//

#import "core/object/class_db.h"

class AdmobIOS : public Object {
    GDCLASS(AdmobIOS, Object);
    
    static AdmobIOS *instance;
    static void _bind_methods();
    
public:
    static AdmobIOS *get_singleton();
    void initialize();
    
    void loadInterstitial(String ad_unit, String identifier);
    void showInterstitial(String hash_identifier);
    
    void loadRewarded(String ad_unit, String identifier);
    void showRewarded(String hash_identifier);
    
    void loadRewardedInterstitial(String ad_unit, String identifier);
    void showRewardedInterstitial(String hash_identifier);
    
    
    void onDismissedAd(String result, String identifier);
    void removeAd(String hash_identifier);
    
    AdmobIOS();
    ~AdmobIOS();
};
