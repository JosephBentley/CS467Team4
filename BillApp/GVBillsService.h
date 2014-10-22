//
//  GVBillsService.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVBills.h"

@interface GVBillsService : NSObject
-(bool)saveBillInBackgroundWithGVBills:(GVBills*)bill error:(NSError**) error;
@end
