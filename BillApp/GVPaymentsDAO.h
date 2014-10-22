//
//  GVPaymentsDAO.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVPayments.h"

@interface GVPaymentsDAO : NSObject
+ (id)sharedGVPaymentsDAO;
-(bool)savePaymentInBackgroundWithGVPayments:(GVPayments*)payment error:(NSError**) error;
@end
