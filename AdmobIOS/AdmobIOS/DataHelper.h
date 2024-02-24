//
//  DataHelper.h
//  AdmobIOS
//
//  Created by Carlos Montes on 23/02/2024.
//

#ifndef DataHelper_h
#define DataHelper_h

String nsStringToString(NSString *text) {
    const char *str = [text UTF8String];
    return String::utf8(str != NULL ? str : "");
}

NSString * stringToNSString(String text) {
    return [NSString stringWithCString:text.utf8().get_data() encoding:NSUTF8StringEncoding];
}

#endif /* DataHelper_h */
