//
//  GVHttpCommunication.m
//  TopTracksApp
//
//  Created by Jonathan Engelsma on 10/15/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import "GVHttpCommunication.h"
#import "AppDelegate.h"

@interface GVHttpCommunication()
@property (nonatomic,copy) void (^successBlock)(NSData*);

@end

@implementation GVHttpCommunication

- (void) retrieveURL:(NSURL* )url successBlock:(void (^) (NSData*))successBlk
{
    self.successBlock = successBlk;
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] incrementNetworkActivity];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    NSURLSessionTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location
{
 
    NSData *data = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] decrementNetworkActivity];
        self.successBlock(data);
    });
}

@end
