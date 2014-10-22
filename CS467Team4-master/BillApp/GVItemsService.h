//
//  GVItemsService.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVItems.h"

@interface GVItemsService : NSObject
-(bool)saveItemInBackgroundWithGVItem:(GVItems*)item error:(NSError**)error;
@end
