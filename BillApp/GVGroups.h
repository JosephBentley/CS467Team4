//
//  GVGroups.h
//  ParseLogInAttempt
//
//  Created by X Code User on 11/6/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVGroups : NSObject
@property (strong, nonatomic)NSString* name;
@property (strong, nonatomic)NSMutableArray* users;
-(id)initWithName:(NSString*)groupname users:(NSMutableArray*)users;
@end
