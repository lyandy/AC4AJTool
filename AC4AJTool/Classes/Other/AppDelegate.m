//
//  AppDelegate.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AppDelegate.h"
#import "AndyMainViewController.h"
#import "AndyPreferenceWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSWindowController *preferencesWindow;

@end

@implementation AppDelegate

- (IBAction)openPreferences:(NSMenuItem *)sender
{
    [self.preferencesWindow showWindow:self];
}

- (NSWindowController *)preferencesWindow
{
    if (_preferencesWindow == nil)
    {
        _preferencesWindow = [[AndyPreferenceWindowController alloc] initWithWindowNibName:@"AndyPreferenceWindowController"];
    }
    return _preferencesWindow;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window.minSize = self.window.contentMinSize = CGSizeMake(550, 450);
    self.window.contentViewController = [[AndyMainViewController alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *) __unused theApplication hasVisibleWindows:(BOOL)flag
{
    if (!flag){
        [[self window] makeKeyAndOrderFront:self];
    }
    return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender{
    return YES;
}

@end
