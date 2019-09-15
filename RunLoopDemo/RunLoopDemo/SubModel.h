//
//  SubModel.h
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/9/15.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@property (nonatomic, copy) NSString * _Nullable baseName;

@end

@interface SubModel : BaseModel

@property (nonatomic, copy) NSString * _Nullable subName;

@property (nonatomic, copy) NSString *temp;

- (void)printMethodName:(Class)cls;

@end

NS_ASSUME_NONNULL_END
