////
////  Person.h
////  RunLoopDemo
////
////  Created by kongfanlie on 2019/8/16.
////  Copyright © 2019 kongfanlie. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface Launage : NSObject
//
//@end
//
//@protocol Sex <NSObject>
//
//- (BOOL)isMale;
//
//@end
//
//@interface Sex : NSObject <Sex>
//
//@end
//
//@interface Male : Sex
//
//@end
//
//@interface Female : Sex
//
//@end
//
//@interface Chinese : Launage
//
//@end
//
//@interface English : Launage
//
//@end
//
//@interface Things : NSObject
//
//@end
//
//@protocol Name <NSObject>
//
//@end
//
//@interface Person<__covariant Sex: Sex *, __covariant Launage : Launage *, __covariant Name> : Things<Name, Sex>
//
//@property (nonatomic, strong) Sex sex;
//
//@property (nonatomic, strong) Launage launage;
//
//@property (nonatomic, copy) NSString *name;
//
//@end
//
//NS_ASSUME_NONNULL_END
