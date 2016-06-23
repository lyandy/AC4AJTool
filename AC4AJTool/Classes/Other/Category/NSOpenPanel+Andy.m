//
//  NSOpenPanel+Andy.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/23.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "NSOpenPanel+Andy.h"

@implementation NSOpenPanel (Andy)

- (void)setCancelButtonTitle:(NSString *)newTitle
{
    NSRect oldFrame = [_cancelButton frame];
    
    [_cancelButton setTitle:newTitle];
    [_cancelButton sizeToFit];
    
    NSRect newFrame = [_cancelButton frame];
    float delta = oldFrame.size.width - newFrame.size.width;
    
    [_cancelButton setFrameOrigin:NSMakePoint(oldFrame.origin.x + delta,
                                              oldFrame.origin.y)];
}


@end
