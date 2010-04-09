//
//  FBGraphSession.h
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright 2010 Facebook. All rights reserved.
//

#import "FBGraphRequest.h"

@interface FBGraphSession : NSObject {
  NSString* _token;
}

- (FBGraphSession*)initWithOAuthToken:(NSString*)token;

- (NSString*) token;

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request;

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request
                          parameters:(NSDictionary*)parameters;

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request
                            metadata:(BOOL)metadata;

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request
                          parameters:(NSDictionary*)parameters
                            metadata:(BOOL)metadata;

@end
