//
//  GVGroups.m
//  ParseLogInAttempt
//
//  Created by X Code User on 11/6/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVGroups.h"

@implementation GVGroups

-(GVGroups*)init {
    if (self = [super init]) {
        self.name = nil;
        self.users = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)groupname users:(NSMutableArray*)users
{
    if (self = [super init]) {
        self.name = groupname;
        self.users = users;
    }
    return self;
}
@end
