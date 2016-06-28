//
//  NSObject+Property.h
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

+ (void)andy_createPropertyCodeWithJsonString:(NSString *)jsonString andFileName:(NSString *)fileName completion:(void (^)(BOOL isSuccess, NSString *errorStr))completion;

@end
