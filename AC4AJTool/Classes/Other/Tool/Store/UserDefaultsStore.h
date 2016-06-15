//
//  UserDefaultsStore.h
//  AndyCode4App
//
//  Created by 李扬 on 16/5/11.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsStore : NSObject

- (BOOL)setOrUpdateValue:(id)value ForKey:(NSString *)key;

- (instancetype)getValueForKey:(NSString *)key DefaultValue:(id)defaultValue ;

- (BOOL)removeValueForKey:(NSString *)key;

- (BOOL)clear;

+ (instancetype)sharedUserDefaultsStore;

@end
