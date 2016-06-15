//
//  AndyEditApplication.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyEditApplication.h"

@implementation AndyEditApplication

- (void)sendEvent:(NSEvent *)event
{
    if (event.type == NSKeyDown)
    {
        NSString *inputKey = [event.charactersIgnoringModifiers lowercaseString];
        if ((event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask ||
            (event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == (NSCommandKeyMask | NSAlphaShiftKeyMask))
        {
            if ([inputKey isEqualToString:@"x"])
            {
                if ([self sendAction:@selector(cut:) to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"c"])
            {
                if ([self sendAction:@selector(copy:) to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"v"])
            {
                if ([self sendAction:@selector(paste:) to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"z"])
            {
                if ([self sendAction:NSSelectorFromString(@"undo:") to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"a"])
            {
                if ([self sendAction:@selector(selectAll:) to:nil from:self])
                    return;
            }
        }
        else if ((event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == (NSCommandKeyMask | NSShiftKeyMask) ||
                 (event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == (NSCommandKeyMask | NSShiftKeyMask | NSAlphaShiftKeyMask))
        {
            if ([inputKey isEqualToString:@"z"])
            {
                if ([self sendAction:NSSelectorFromString(@"redo:") to:nil from:self])
                    return;
            }
        }
    }
    [super sendEvent:event];
}


@end
