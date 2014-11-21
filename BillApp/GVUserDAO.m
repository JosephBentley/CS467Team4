//
//  GVUserDAO.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/26/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//
#import "GVUserDAO.h"

@implementation GVUserDAO

#pragma mark Singleton Methods

+ (id)sharedGVUserDAO {
    static GVUserDAO *sharedGVUserDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGVUserDAO = [[self alloc] init];
    });
    return sharedGVUserDAO;
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

-(void)createNewUserWithUserNameWithBlock:(NSString*)username password:(NSString*)password email:(NSString*)email block:(void (^) (BOOL succeeded, NSError* error)) block
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            PFACL* userACL = [PFACL ACLWithUser:[PFUser currentUser]];
            //user.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            [userACL setPublicReadAccess:TRUE];
            [userACL setPublicWriteAccess:FALSE];
            
            user.ACL = userACL;
            [user saveInBackgroundWithBlock:block];
            //block(succeeded, error);
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"GVUserDAO: %@", errorString);
            // Show the errorString somewhere and let the user try again.
            block(succeeded, [NSError errorWithDomain:@"com.gvsu.edu" code:-400 userInfo:[error userInfo]]);
        }
    }];
}

-(void)logInWithUsernameInBackgroundWithBlock:(NSString*)username password:(NSString*)password block:(void (^) (NSError* error) ) block
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            
            block(error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"error: %@", errorString);
            block([NSError errorWithDomain:@"com.gvsu.edu" code:-400 userInfo:[error userInfo]]);
        }
    }];
}

-(void)logoutCurrentUserWithBlock:(void (^)(BOOL succeeded)) block
{
	[PFUser logOut];
	if ([PFUser currentUser] == nil)
		block(true);
    else
        block(false);
}

-(void)resetPasswordWithEmailAddressWithBlock:(NSString*)email block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [PFUser requestPasswordResetForEmailInBackground:email block:block];
}

-(void)queryForUserWithUserNameWithBlock:(NSString*)username block:(void (^) (PFObject* object, NSError* error)) block
{
    //NSLog(@"Inside queryForUserWithUserNameWithBlock");
    PFQuery* query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSLog(@"The user has been retrieved!");
            block(object, error);
        }
        else {
            NSLog(@"queryForUserWithUserNameWithBlock failed.");
            block(nil, error);
        }
    }];
    
//    PFQuery* query = [PFQuery queryWithClassName:@"_User"];
//    [query whereKey:@"username" equalTo:username];
//    [query getFirstObjectInBackgroundWithBlock:block];
}




@end