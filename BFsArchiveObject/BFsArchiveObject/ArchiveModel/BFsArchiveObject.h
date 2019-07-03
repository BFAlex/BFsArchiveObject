//
//  BFsArchiveObject.h
//  BFsArchiveObject
//
//  Created by BFAlex on 2019/7/3.
//  Copyright © 2019年 BFs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFsArchiveObject : NSObject

+ (id)unarchiveInstance;
- (void)archiveInstance;

@end

NS_ASSUME_NONNULL_END
