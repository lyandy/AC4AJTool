//
//  FileTool.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "FileTool.h"

@implementation FileTool

+ (BOOL)checkDirectoryExist:(NSString *)directoryPath
{
    NSError *error = nil;
    
    id result = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    
    if (result != nil && error == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
