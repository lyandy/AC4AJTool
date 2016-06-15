//
//  NSAlert+Andy.h
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAlert (Andy)

+ (void)andy_showSheetModelForWindow:(NSWindow *)window messageText:(NSString *)msgText informativeText:(NSString *)infoText;

@end
