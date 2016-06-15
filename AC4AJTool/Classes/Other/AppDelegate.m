//
//  AppDelegate.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AppDelegate.h"
#import "AndyMainViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window.minSize = self.window.contentMinSize = CGSizeMake(550, 450);
    self.window.contentViewController = [[AndyMainViewController alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
