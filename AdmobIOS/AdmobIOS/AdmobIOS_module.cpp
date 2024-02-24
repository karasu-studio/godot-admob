//
//  AdmobIOS_module.cpp
//  AdmobIOS
//
//  Created by Carlos Montes on 16/02/2024.
//

#include "AdmobIOS_module.h"
#import "AdmobIOS.h"
#import "core/config/engine.h"

AdmobIOS *plugin;

void register_admob_ios() {
    plugin = memnew(AdmobIOS);
    Engine::get_singleton()->add_singleton(Engine::Singleton("AdmobIOS", plugin));
}

void unregister_admob_ios() {
    if (plugin != NULL) {
        memdelete(plugin);
    }
}
