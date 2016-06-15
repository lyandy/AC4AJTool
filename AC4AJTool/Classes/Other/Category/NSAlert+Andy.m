//
//  NSAlert+Andy.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "NSAlert+Andy.h"

@implementation NSAlert (Andy)

+ (void)andy_showSheetModelForWindow:(NSWindow *)window messageText:(NSString *)msgText informativeText:(NSString *)infoText
{
    NSAlert *alert = [[self alloc] init];
    [alert setMessageText:msgText];
    [alert setInformativeText:infoText];
    [alert beginSheetModalForWindow:window completionHandler:nil];
}

@end
