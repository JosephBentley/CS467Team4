//
//  GVItems.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/14/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVItems.h"
#import <Parse/Parse.h>

@implementation GVItems

-(GVItems*)init {
    if (self = [super init]) {
        self.name = nil;
        self.cost = -1.0;
        self.productID = nil;
        self.sharedFlag = @-1;
    }
    return self;
}

-(id)initWithName:(NSString*)itemName cost:(double)cost productID:(NSString*)productID sharedItem:(NSNumber*)sharedFlag
{
    if (self = [super init]) {
        self.name = itemName;
        self.cost = cost;
        self.productID = productID;
        self.sharedFlag = sharedFlag;
    }
    return self;
}
@end
