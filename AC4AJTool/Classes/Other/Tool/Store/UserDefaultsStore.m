//
//  UserDefaultsStore.m
//  AndyCode4App
//
//  Created by 李扬 on 16/5/11.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "UserDefaultsStore.h"

@implementation UserDefaultsStore

static id instance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return instance;
}

- (instancetype)init
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        instance = [super init];
    });
    
    return instance;
}

+ (instancetype)sharedUserDefaultsStore
{
    return [[self alloc] init];
}


- (BOOL)setOrUpdateValue:(id)value ForKey:(NSString *)key
{
    @try {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:value forKey:key];
        
        [defaults synchronize];
        
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
}

- (instancetype)getValueForKey:(NSString *)key DefaultValue:(id)defaultValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    id value = [defaults objectForKey:key];
    
    if (value != nil)
    {
        return value;
    }
    else
    {
        return defaultValue;
    }
}

- (BOOL)removeValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:key];
    
    [defaults synchronize];
    
    return YES;
}

- (BOOL)clear
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *appDomainStr = [[NSBundle mainBundle] bundleIdentifier];
    
    [defaults removePersistentDomainForName:appDomainStr];
    
    [defaults synchronize];
    
    return YES;
}



@end
