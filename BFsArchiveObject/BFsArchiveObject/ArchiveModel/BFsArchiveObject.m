//
//  BFsArchiveObject.m
//  BFsArchiveObject
//
//  Created by BFAlex on 2019/7/3.
//  Copyright © 2019年 BFs. All rights reserved.
//

#import "BFsArchiveObject.h"
#import <objc/runtime.h>

#define kArchiveKey  @"ArchiveObject"

@interface BFsArchiveObject () <NSCoding>

@end

@implementation BFsArchiveObject

#pragma mark - API

+ (id)unarchiveInstance {
    
    NSData *objData = [[NSUserDefaults standardUserDefaults] objectForKey:kArchiveKey];
    BFsArchiveObject *obj = [NSKeyedUnarchiver unarchiveObjectWithData:objData];
    
    return obj;
}

- (void)archiveInstance {
    
    NSData *objData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:objData forKey:kArchiveKey];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        Class class = [self class];
        while (class != [NSObject class]) {
            unsigned int count = 0;
            //获取类中所有成员变量名
            Ivar *ivar = class_copyIvarList(class, &count);
            for (int i = 0; i < count; i++) {
                Ivar iva = ivar[i];
                const char *name = ivar_getName(iva);
                NSString *strName = [NSString stringWithUTF8String:name];
                //进行解档取值
                id value = [aDecoder decodeObjectForKey:strName];
                //利用KVC对属性赋值
                [self setValue:value forKey:strName];
            }
            free(ivar);
            
            // 遍历父类的属性
            class = class_getSuperclass(class);
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [self valueForKey:strName];
            [aCoder encodeObject:value forKey:strName];
        }
        free(ivar);
        
        // 遍历父类的属性
        class = class_getSuperclass(class);
    }
}

@end
