//
//  AndyMainViewController.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyMainViewController.h"

@interface AndyMainViewController ()
@property (weak) IBOutlet NSTextField *jsonTitleTextLable;

@property (weak) IBOutlet NSScrollView *jsonView;

@property (weak) IBOutlet NSTextField *modelPathTextLabel;

@property (weak) IBOutlet NSTextField *modelPathTextField;

@property (weak) IBOutlet NSButton *selectPathBtn;
@property (weak) IBOutlet NSButton *saveBtn;
@end

@implementation AndyMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAutoLayout];
    
    [self setupBtnEvent];

    [self setupInitStatus];
}

- (void)setupAutoLayout
{
    //AndyLog(@"%@", NSStringFromRect(self.view.bounds));
    
    CGFloat commonMargin = 10;
    
    [self.jsonTitleTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(commonMargin);
        make.bottom.equalTo(self.jsonView.top).offset(-commonMargin);
    }];
    
    [self.jsonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jsonTitleTextLable.left);
        make.top.equalTo(self.jsonTitleTextLable.bottom).offset(commonMargin);
        make.right.equalTo(self.view.right).offset(-commonMargin);
        make.bottom.equalTo(self.modelPathTextLabel.top).offset(-commonMargin);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(- 2 * commonMargin);
    }];
    
    [self.modelPathTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(commonMargin);
        make.bottom.equalTo(self.saveBtn.top).offset(-commonMargin);
        make.right.equalTo(self.selectPathBtn.left).offset(-commonMargin);
        make.height.equalTo(self.selectPathBtn.height);
    }];
    
    [self.selectPathBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-commonMargin);
        make.bottom.equalTo(self.modelPathTextField.bottom);
    }];
    
    [self.modelPathTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commonMargin);
        make.bottom.equalTo(self.modelPathTextField.top).offset(-commonMargin);
    }];

}

- (void)setupBtnEvent
{
    //@weakify和@strongify成对出现防止出现block出现循环强引用
    @weakify(self);
    self.selectPathBtn.rac_command =  [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self);
        
        NSWindow* window = self.view.window;
        
        NSOpenPanel* panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:YES];
        [panel setCanChooseFiles:NO];
        [panel setPrompt:@"选择"];
        [panel setMessage:@"选择一个路径"];
        
        [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
            if (result == NSFileHandlingPanelOKButton) {
                NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
                
                NSRange range = [theDoc.description rangeOfString:@"file://"];
                NSString *path = [theDoc.description substringFromIndex:(range.location + range.length)];
                
                self.modelPathTextField.stringValue = path;
                
                [[UserDefaultsStore sharedUserDefaultsStore] setOrUpdateValue:path ForKey:ANDY_MODEL_PATH];
            }
        }];

         //凡是返回一个信号，不允许为nil,但可以返回空信号[RACSignal empty];
        return [RACSignal empty];
    }];
    
    self.saveBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self);
        
        NSString *jsonString = [self.jsonView.documentView textStorage].string;
        
        [NSObject andy_createPropertyCodeWithJsonString:jsonString completion:^(BOOL isSuccess, NSString *errorStr) {
            if(isSuccess)
            {
                [NSAlert andy_showSheetModelForWindow:self.view.window messageText:@"提示" informativeText:@"成功创建Model文件"];
            }
            else
            {
                [NSAlert andy_showSheetModelForWindow:self.view.window messageText:@"错误" informativeText:errorStr];
            }
        }];
    
        return [RACSignal empty];
    }];
}

- (void)setupInitStatus
{
//    RAC(self.saveBtn, enabled) = [((NSTextView *)self.jsonView.documentView).rac_textSignal map:^id(NSString * value) {
//        return value.length > 0 ? @(YES) : @(NO);
//    }];
    
    [((NSTextView *)self.jsonView.documentView).rac_textSignal subscribeNext:^(NSString * value) {
        //因为self.saveBtn已经绑定了rac_command信号，就不能再用RAC绑定观察信号了。所以这里要这么写
        self.saveBtn.enabled = value.length > 0;
    }];
    
    NSString *modelExportPath = (NSString *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_MODEL_PATH DefaultValue:DesktopPath];
    self.modelPathTextField.stringValue = modelExportPath;
}

@end





















