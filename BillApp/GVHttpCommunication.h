//
//  GVHttpCommunication.h
//  TopTracksApp
//
//  Created by Jonathan Engelsma on 10/15/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVHttpCommunication : NSObject <NSURLSessionDataDelegate>
- (void) retrieveURL:(NSURL* )url successBlock:(void (^) (NSData*))successBlk;
@end
