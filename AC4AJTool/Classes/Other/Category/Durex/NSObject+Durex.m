//
//  NSObject+Durex.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "NSObject+Durex.h"
#import <objc/message.h>

/**
 *  可拦截 KVC 或者 调用 setValue:forKey: 方法引起的nil为空的崩溃问题
 */

@implementation NSObject (Durex)

+ (void)load
{
    
    Method setValueforUndefinedKeyMethod = class_getClassMethod([NSObject class], @selector(setValue:forUndefinedKey:));

    Method andy_setValueforUndefinedKeyMethod = class_getClassMethod([NSObject class], @selector(andy_setValue:forUndefinedKey:));

    method_exchangeImplementations(setValueforUndefinedKeyMethod, andy_setValueforUndefinedKeyMethod);
    
}

- (void)andy_setValue:(id)value forUndefinedKey:(NSString *)key
{
    AndyLog(@"出错了，杜蕾斯拦截: %s", __func__);
}

@end
