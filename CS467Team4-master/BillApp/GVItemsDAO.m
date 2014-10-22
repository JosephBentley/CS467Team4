//
//  GVItemsDAO.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVItemsDAO.h"
#import <Parse/Parse.h>

@implementation GVItemsDAO

#pragma mark Singleton Methods

+ (id)sharedGVItemsDAO {
    static GVItemsDAO *sharedGVItemsDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGVItemsDAO = [[self alloc] init];
    });
    return sharedGVItemsDAO;
}

- (id)init {
    if (self = [super init]) {
        // set queries (or make them static final)
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


#pragma mark Parse Methods

-(bool)saveItemInBackgroundWithGVItem:(GVItems*)item error:(NSError**)error;
{
    if (item.name == nil || item.cost < 0 || item.productID == nil || item.sharedFlag < 0)
        return false;
    else {
        NSNumber* nsCost = [[NSNumber alloc] initWithDouble:item.cost];
        
        PFObject *itemObject = [PFObject objectWithClassName:@"IndividualItems"];
        itemObject[@"item_nm"] = item.name;
        itemObject[@"cost_nb"] = nsCost;
        itemObject[@"productID_nm"] = item.productID;
        itemObject[@"shared_f"] = item.sharedFlag;
        [itemObject saveInBackground];
    }
    return true;
}

@end
