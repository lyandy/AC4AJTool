//
//  NSObject+Property.m
//  AC4AJTool
//
//  Created by 李扬 on 16/6/15.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "NSObject+Property.h"
#import "AndyFoundation.h"

@implementation NSObject (Property)

static bool isReplaceId = NO;
static bool isIgnoreNull = NO;
static NSString * replacedKey = @"";

+ (void)andy_createPropertyCodeWithJsonString:(NSString *)jsonString andModelFolderName:(NSString *)modelFolderName completion:(void (^)(BOOL, NSString *))completion
{
    BOOL isSuccess = YES;
    NSString *errorStr = nil;
    
    NSDictionary *dict = [NSDictionary dictionary];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    NSLog(@"%@", obj);
    
    if ([jsonString andy_trim].length == 0)
    {
        isSuccess = NO;
        errorStr = @"无效数据，无法生成Model";
    }
    else if ([obj isKindOfClass:[NSDictionary class]])
    {
        dict = obj;
    }
    else if ([obj isKindOfClass:[NSArray class]])
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
        isReplaceId = [((NSNumber *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_IS_REPLACE_ID DefaultValue:@(NO)]) boolValue];
        
        if (isReplaceId)
        {
            replacedKey = (NSString *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_REPLACE_KEY DefaultValue:@"ID"];
        }
        
        isIgnoreNull = [((NSNumber *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_IS_IGNORE_NULL DefaultValue:@(NO)]) boolValue];
        
        [self createPropertyCodeWithDict:dict withModelName:@"RootModel" andModelFolderName:(NSString *)modelFolderName];
    }
    
    if (completion)
    {
        completion(isSuccess, errorStr);
    }
}

+ (void)createPropertyCodeWithDict:(NSDictionary *)dict withModelName:modelName andModelFolderName:(NSString *)modelFolderName
{
    //导入头
    NSMutableString *headerImportStrM = [NSMutableString string];
    NSString *headerImportStr = @"\n#import <Foundation/Foundation.h>\n";
    [headerImportStrM appendString:headerImportStr];
    
    NSMutableString *headerContentStrM = [NSMutableString string];
    NSString *preStr = [NSString stringWithFormat:@"\n@interface %@ : NSObject", modelName];
    [headerContentStrM appendFormat:@"\n%@\n",preStr];
    
    
    // 遍历字典
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull propertyName, id  _Nonnull value, BOOL * _Nonnull stop) {
        //NSLog(@"%@ %@",propertyName,[value class]);
        NSString *code;
        
        //id 类型 key 的替换
        if ([propertyName isEqualToString:@"id"] && isReplaceId && ![replacedKey isEqualToString:@""])
        {
            propertyName = replacedKey;
        }
        
        if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")])
        {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",propertyName];
        }
        else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:NSClassFromString(@"NSTaggedPointerString")])
        {
            code = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",propertyName];
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            //这里要有更细的判断 CGFloat 或者NSInteger
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",propertyName];
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray<%@ *> *%@;",[propertyName capitalizedString], propertyName];
            
            [headerImportStrM appendString:[NSString stringWithFormat:@"#import \"%@.h\"\n", [propertyName capitalizedString]]];
            
            NSArray *arr = (NSArray *)dict[propertyName];
            if (arr.count > 0)
            {
                //如果是Foundation框架下的类型,比如NSArray下是{"name":"超重低音","gainArray":[6,8,7,4,0,-1,-5,1,2,-2],"equalizerEffect":2}，根本没有key,也就是根本不是字典，直接使用即可。
                if (![arr[0] isKindOfClass:[NSDictionary class]])
                {
                    code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;", propertyName];
                }
                else
                {
                    //如果发现是数组的话，则试着去取第一个来产生一个Model
                    [self createPropertyCodeWithDict:arr[0] withModelName:[propertyName capitalizedString] andModelFolderName:modelFolderName];
                }
            }
        }
        else if ([value isKindOfClass:[NSDictionary class]])
        {
            NSString *propertyCapitalizedName = [propertyName capitalizedString];
            
            [headerImportStrM appendString:[NSString stringWithFormat:@"#import \"%@.h\"\n", propertyCapitalizedName]];

            code = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;", propertyCapitalizedName, propertyName];
            //如果发现是字典的话，则试着再次调用此方法来产生一个Model
            [self createPropertyCodeWithDict:dict[propertyName] withModelName:propertyCapitalizedName andModelFolderName:modelFolderName];
            
        }
        else if ([value isKindOfClass:[NSNull class]])
        {
            if (!isIgnoreNull)
            {
                code = [NSString stringWithFormat:@"@property (nullable, nonatomic, strong) id %@;",propertyName];
            }
        }
        
        if (code != nil)
        {
            [headerContentStrM appendFormat:@"\n%@\n",code];
        }
    }];
    
    [headerContentStrM appendFormat:@"\n%@\n",@"@end"];
    
    NSMutableString *headerStrM = [NSMutableString string];
    [headerStrM appendString:headerImportStrM];
    [headerStrM appendString:headerContentStrM];
    
    //将Model数据存储到本地文件 -- 写.h
    NSString *modelInterfaceName = [NSString stringWithFormat:@"%@.h", modelName];
    [self saveModelString:headerStrM withModelName:modelInterfaceName andModelFolderName:modelFolderName];
    
    //将Model数据存储到本地文件 -- 写.m
    NSString *implementationStr = [NSString stringWithFormat:@"\n#import \"%@.h\"\n\n@implementation %@\n\n@end",modelName, modelName];
    NSString *modelImplementationName = [NSString stringWithFormat:@"%@.m", modelName];
    [self saveModelString:implementationStr withModelName:modelImplementationName andModelFolderName:modelFolderName];
}

+ (void)saveModelString:(NSString *)modelString withModelName:(NSString *)modelName andModelFolderName:modelFolderName
{
    AndyLog(@"\r\n-----------%@----------------------\r\n", modelName);
    
    NSString *path = (NSString *)[[UserDefaultsStore sharedUserDefaultsStore] getValueForKey:ANDY_MODEL_PATH DefaultValue:DesktopPath];
    
    //    // URL方法
    //    NSString *modePath = [NSString stringWithFormat:@"file://%@/%@",path, modelName];
    //
    //    [modelString writeToURL:[NSURL URLWithString:modePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // 文件夹方法
    // 拼接文件夹目录
    NSString *filePath = [NSString stringWithFormat:@"%@%@", path, (modelFolderName == nil || [modelFolderName isEqualToString:@""]) ? @"AndyModel" : modelFolderName];
    // 拼接文件完整目录
    NSString *modePath = [NSString stringWithFormat:@"%@/%@", filePath, modelName];
    // 初始化文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建文件目录
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    // 判断,如果文件是否存在
    if (![fileManager fileExistsAtPath:modePath])
    {
        // 文件不存在就创建文件
        [fileManager createFileAtPath:modePath contents:nil attributes:nil];
    }
    
    // 写入数据到文件
    [modelString writeToFile:modePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
