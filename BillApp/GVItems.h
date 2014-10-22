//
//  GVItems.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/14/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVItems : NSObject
@property (strong, nonatomic)NSString* name;
@property (nonatomic, assign)double cost;
@property (strong, nonatomic)NSString* productID;
@property (strong, nonatomic)NSNumber* sharedFlag;
-(GVItems*)init;
-(id)initWithName:(NSString*)itemName cost:(double)cost productID:(NSString*)productID sharedItem:(NSNumber*)sharedFlag;
@end
