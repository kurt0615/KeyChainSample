//
//  ViewController.m
//  GetKeyChainDataSample
//
//  Created by Kurt Yang on 2014/8/18.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "ViewController.h"
#import "Keychain.h"

@interface ViewController ()
@property (nonatomic, strong) Keychain *keychain;
@end

#define SERVICE_NAME @"SHARDSERVICE" //固定名稱
#define GROUP_NAME @"2YXH3Z227F.com.gigabyte.Gmarket.shared" // 命名原則： prefix id(2YXH3Z227F) . bundle id(com.gbt.gmarket) . xxxx(shared)

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getItemFromKeychain];
}

-(void)getItemFromKeychain
{
    NSData * userId =[self.keychain find:@"account"];
    
    NSData * password =[self.keychain find:@"password"];
    
    NSLog(@"userId is =%@",[[NSString alloc] initWithData:userId encoding:NSUTF8StringEncoding]);
    NSLog(@"password is =%@",[[NSString alloc] initWithData:password encoding:NSUTF8StringEncoding]);
}


-(Keychain *)keychain
{
    if (!_keychain) {
        _keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:GROUP_NAME];
    }
    return _keychain;
}
@end
