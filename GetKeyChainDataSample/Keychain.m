//
//  Keychain.m
//  gmarket
//
//  Created by Kurt Yang on 2014/8/7.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "Keychain.h"

@implementation Keychain

-(instancetype) initWithService:(NSString *)service withGroup:(NSString*)group
{
    self = [super init];
    if(self)
    {
        _service = [NSString stringWithString:service];
        
        if(group)
            _group = [NSString stringWithString:group];
    }
    
    return  self;
}

-(NSMutableDictionary*) prepareDict:(NSString *) key
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:self.service forKey:(__bridge id)kSecAttrService];
    [dict setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    if(self.group != nil) {
        [dict setObject:self.group forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    return  dict;
}

-(BOOL)insert:(NSString *)key :(NSData *)value
{
    NSMutableDictionary * dict =[self prepareDict:key];
    [dict setObject:value forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
    
    if(errSecSuccess != status) {
        NSLog(@"Unable add item with key =%@ error:%d",key,(int)status);
    }
    return (errSecSuccess == status);
}

-(NSData*)find:(NSString *)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    [dict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,&result);
    
    if(status != errSecSuccess) {
        NSLog(@"Unable to fetch item for key %@ with error:%d",key,(int)status);
        return nil;
    }
    return (__bridge NSData *)result;
}

-(BOOL)update:(NSString *)key :(NSData *)value
{
    NSMutableDictionary * dictKey =[self prepareDict:key];
    
    NSMutableDictionary * dictUpdate =[[NSMutableDictionary alloc] init];
    [dictUpdate setObject:value forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)dictKey, (__bridge CFDictionaryRef)dictUpdate);
    
    if(errSecSuccess != status) {
        NSLog(@"Unable add update with key =%@ error:%d",key,(int)status);
    }
    return (errSecSuccess == status);
}

-(BOOL)remove:(NSString *)key
{
    NSMutableDictionary *dict = [self prepareDict:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dict);
    if( status != errSecSuccess) {
        NSLog(@"Unable to remove item for key %@ with error:%d",key,(int)status);
        return NO;
    }
    return  YES;
}

//-(void)resetKeychain {
//    [self deleteAllKeysForSecClass:kSecClassGenericPassword];
//    [self deleteAllKeysForSecClass:kSecClassInternetPassword];
//    [self deleteAllKeysForSecClass:kSecClassCertificate];
//    [self deleteAllKeysForSecClass:kSecClassKey];
//    [self deleteAllKeysForSecClass:kSecClassIdentity];
//}
//
//
//-(void)deleteAllKeysForSecClass:(CFTypeRef)secClass {
//    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    [dict setObject:(__bridge id)secClass forKey:(__bridge id)kSecClass];
//    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) dict);
//    NSAssert(result == noErr || result == errSecItemNotFound, @"Error deleting keychain data (%d)", (int)result);
//}
@end
