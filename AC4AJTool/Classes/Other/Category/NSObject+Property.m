//
//  NSObject+Property.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "NSObject+Property.h"

@implementation NSObject (Property)

+ (void)andy_createPropertyCodeWithJsonString:(NSString *)jsonString completion:(void (^)(BOOL, NSString *))completion
{
    BOOL isSuccess = YES;
    NSString *errorStr = nil;
    
    NSDictionary *dict = [NSDictionary dictionary];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    if ([jsonString andy_trim].length == 0)
    {
        isSuccess = NO;
        errorStr = @"无效数据，无法生成Model";
    }
    else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")])
    {
        dict = obj;
    }
    else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")])
    {
        if (((NSArray *)obj).count > 0)
        {
            dict = ((NSArray *)obj)[0];
        }
        else
        {
            isSuccess = NO;
            errorStr = @"有效数据为空，无法生成Model";
        }
    }
    else
    {
        isSuccess = NO;
        errorStr = @"数据格式错误，无法生成Model";
    }

    if (isSuccess)
    {
        [self createPropertyCodeWithDict:dict withModelName:@"RootModel"];
    }
    
    if (completion)
    {
        completion(isSuccess, errorStr);
    }
}

+ (void)createPropertyCodeWithDict:(NSDictionary *)dict withModelName:modelName
{
    NSMutableString *headerStrM = [NSMutableString string];
    
    //导入头
    NSString *preStr = [NSString stringWithFormat:@"\n#import <Foundation/Foundation.h>\n\n@interface %@", modelName];
    [headerStrM appendFormat:@"\n%@\n",preStr];
    
    // 遍历字典
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull propertyName, id  _Nonnull value, BOOL * _Nonnull stop) {
        //NSLog(@"%@ %@",propertyName,[value class]);
        NSString *code;
        
        if ([value isKindOfClass:NSClassFromString(@"NSNull")])
        {
            //这里要再判断
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) id %@;",propertyName];
        }
        else
            if ([value isKindOfClass:NSClassFromString(@"NSTaggedPointerString")])
            {
                //这里要再判断
                code = [NSString stringWithFormat:@"@property (nonatomic, strong) id %@;",propertyName];
            }
            else if ([value isKindOfClass:NSClassFromString(@"__NSCFString")]) {
                code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",propertyName];
            }else if ([value isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
                //这里要有更细的判断 CGFloat 或者NSInteger
                code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",propertyName];
            }else if ([value isKindOfClass:NSClassFromString(@"__NSArrayI")]){
                code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray<%@ *> *%@;",[propertyName capitalizedString], propertyName];
                //如果发现是数组的话，则试着去取第一个来产生一个Model
                [self createPropertyCodeWithDict:((NSArray *)dict[propertyName])[0] withModelName:[propertyName capitalizedString]];
            }else if ([value isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
                code = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",[propertyName capitalizedString], propertyName];
                //如果发现是字典的话，则试着再次调用此方法来产生一个Model
                [self createPropertyCodeWithDict:dict[propertyName] withModelName:[propertyName capitalizedString]];
            }else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
                code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",propertyName];
            }
        [headerStrM appendFormat:@"\n%@\n",code];
    }];
    
    [headerStrM appendFormat:@"\n%@\n",@"@end"];
    
    //将Model数据存储到本地文件 -- 写.h
    NSString *modelInterfaceName = [NSString stringWithFormat:@"%@.h", modelName];
    [self saveModelString:headerStrM withModelName:modelInterfaceName];
    
    //将Model数据存储到本地文件 -- 写.m
    NSString *implementationStr = [NSString stringWithFormat:@"\n#import \"%@.h\"\n\n@implementation %@\n\n@end",modelName, modelName];
    NSString *modelImplementationName = [NSString stringWithFormat:@"%@.m", modelName];
    [self saveModelString:implementationStr withModelName:modelImplementationName];
}

+ (void)saveModelString:(NSString *)modelString withModelName:(NSString *)modelName
{
    AndyLog(@"\r\n-----------%@----------------------\r\n", modelName);
    
    NSString *path = (NSString *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_MODEL_PATH DefaultValue:DesktopPath];
    
    NSString *modePath = [NSString stringWithFormat:@"file://%@/%@",path, modelName];
    
    [modelString writeToURL:[NSURL URLWithString:modePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
