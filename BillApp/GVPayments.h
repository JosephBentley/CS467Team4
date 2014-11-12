//
//  GVPayments.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/14/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVPayments : NSObject
@property (strong, nonatomic)NSString* name;
@property (nonatomic, assign)double total;
@property (nonatomic, assign)double interestRate;
@property (nonatomic, assign)int interval;
@property (strong, nonatomic)NSDate* nextPayDate;
@property (strong, nonatomic)NSString* boughtByName;
@property (strong, nonatomic)NSString* group;
-(GVPayments*)init;
-(id)initWithName:(NSString*)paymentName total:(double)total interestRate:(double)interestRate interval:(int)interval nextPayDate:(NSDate*)nextPayDate boughtBy:(NSString*)boughtByName group:(NSString*)group;
@end
