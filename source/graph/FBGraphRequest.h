//
//  FBGraphRequest.h
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright 2010 Facebook. All rights reserved.
//

@class FBGraphSession;

@interface FBGraphRequest : NSObject {
  BOOL              _requestStarted;
  BOOL              _requestFinished;
  NSURLConnection*  _connection;
  NSMutableData*    _responseBuffer;
  id                _response;

  FBGraphSession*   _session;
  id                _delegate;
  SEL               _callback;
  NSURL*            _request;
  NSDictionary*     _parameters;
  BOOL              _getMetadata;
}

+ (FBGraphRequest*)requestWithSession:(FBGraphSession*)session
                             delegate:(id)delegate
                             callback:(SEL)callback
                              request:(NSURL*)request
                           parameters:(NSDictionary*)parameters
                             metadata:(BOOL)metadata;

- (void)start;

- (NSURL*)request;

/**
 * The full response
 */
- (id)response;

/**
 * Self-reflective metadata
 */
- (id)metadata;

@end
