//
//  AndyPreferenceWindowController.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/23.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyPreferenceWindowController.h"

@interface AndyPreferenceWindowController ()
@property (weak) IBOutlet NSButton *cbReplaceId;
@property (weak) IBOutlet NSButton *cbIgnoreNull;

@property (weak) IBOutlet NSTextField *tfReplacedKey;
@property (weak) IBOutlet NSTextField *lbReplaceKey;
@end

@implementation AndyPreferenceWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self setupInitStatus];
    
    [self setupRAC];
}

- (void)setupInitStatus
{
    self.cbReplaceId.state = [((NSNumber *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_IS_REPLACE_ID DefaultValue:@(NO)]) boolValue];
    self.cbIgnoreNull.state = [((NSNumber *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_IS_IGNORE_NULL DefaultValue:@(NO)]) boolValue];
}

- (void)setupRAC
{
    RAC(self.tfReplacedKey, enabled) = [RACSignal return:@(self.cbReplaceId.state)];
    
    [self.tfReplacedKey.window makeFirstResponder:nil];
    
    self.lbReplaceKey.textColor = self.cbReplaceId.state ? [NSColor blackColor] : [NSColor grayColor];
    
    self.tfReplacedKey.stringValue = self.cbReplaceId.state ? (NSString *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_REPLACE_KEY DefaultValue:@"ID"] : @"";
    
    @weakify(self);
    
    self.cbReplaceId.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self);
        
        RAC(self.tfReplacedKey, enabled) = [RACSignal return:@(self.cbReplaceId.state)];
        
        self.lbReplaceKey.textColor = self.cbReplaceId.state ? [NSColor blackColor] : [NSColor grayColor];
        self.tfReplacedKey.stringValue = self.cbReplaceId.state ? (NSString *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_REPLACE_KEY DefaultValue:@"ID"] : @"";
        
        [[UserDefaultsStore sharedUserDefaultsStore] setOrUpdateValue:@(self.cbReplaceId.state) ForKey:ANDY_IS_REPLACE_ID];
        
        return [RACSignal empty];
    }];
    
    self.cbIgnoreNull.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self);
        
        [self.tfReplacedKey.window makeFirstResponder:nil];
        
        [[UserDefaultsStore sharedUserDefaultsStore] setOrUpdateValue:@(self.cbIgnoreNull.state) ForKey:ANDY_IS_IGNORE_NULL];
        
        return [RACSignal empty];
    }];

    [self.tfReplacedKey.rac_textSignal subscribeNext:^(id x) {
       
        NSString *text = ((NSString *)x).andy_trim;
        
        [[UserDefaultsStore sharedUserDefaultsStore] setOrUpdateValue:text.andy_trim ForKey:ANDY_REPLACE_KEY];
        
        if (text.length == 0)
        {
            self.cbReplaceId.state = NO;
            
            [self.cbReplaceId.rac_command execute:nil];
        }

    }];

}

@end
























