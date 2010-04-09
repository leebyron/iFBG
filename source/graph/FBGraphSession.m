//
//  FBGraphSession.m
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright 2010 Facebook. All rights reserved.
//

#import "FBGraphSession.h"


@implementation FBGraphSession

- (FBGraphSession*)initWithOAuthToken:(NSString*)token
{
  self = [super init];
  if (!self) return nil;

  _token = token;

  return self;
}

- (void)dealloc
{
  [_token release];
  [super dealloc];
}

- (NSString*) token
{
  return _token;
}

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request
{
  return [self queryWithDelegate:delegate
                        callback:(SEL)callback
                         request:request
                      parameters:[NSDictionary dictionary]
                        metadata:NO];
}

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request
                          parameters:(NSDictionary*)parameters
{
  return [self queryWithDelegate:delegate
                        callback:(SEL)callback
                         request:request
                      parameters:parameters
                        metadata:NO];
}

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request
                            metadata:(BOOL)metadata
{
  return [self queryWithDelegate:delegate
                        callback:(SEL)callback
                         request:request
                      parameters:[NSDictionary dictionary]
                        metadata:metadata];
}

- (FBGraphRequest*)queryWithDelegate:(id)delegate
                            callback:(SEL)callback
                             request:(NSURL*)request
                          parameters:(NSDictionary*)parameters
                            metadata:(BOOL)metadata
{
  return [FBGraphRequest requestWithSession:self
                                   delegate:delegate
                                   callback:callback
                                    request:request
                                 parameters:parameters
                                   metadata:metadata];
}

@end
