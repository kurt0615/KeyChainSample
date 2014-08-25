//
//  Keychain.h
//  gmarket
//
//  Created by Kurt Yang on 2014/8/7.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject
@property (nonatomic, weak) NSString* service;
@property (nonatomic, weak) NSString* group;
-(instancetype)initWithService:(NSString *)service withGroup:(NSString*)group;
-(BOOL)insert:(NSString *)key :(NSData *)value;
-(BOOL)update:(NSString*)key :(NSData*) value;
-(BOOL)remove:(NSString*)key;
-(NSData*)find:(NSString*)key;
@end
