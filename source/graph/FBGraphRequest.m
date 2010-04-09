//
//  FBGraphRequest.m
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright 2010 Facebook. All rights reserved.
//

#import "FBGraphRequest.h"
#import "FBGraphSession.h"
#import "NSURL+.h"
#import "JSON.h"


@interface FBGraphRequest (Private)

- (id)initWithSession:(FBGraphSession*)session
             delegate:(id)delegate
             callback:(SEL)callback
              request:(NSURL*)request
           parameters:(NSDictionary*)parameters
             metadata:(BOOL)metadata;

- (void)finished;

- (NSURL*)query;

@end


@implementation FBGraphRequest

+ (FBGraphRequest*)requestWithSession:(FBGraphSession*)session
                             delegate:(id)delegate
                             callback:(SEL)callback
                              request:(NSURL*)request
                           parameters:(NSDictionary*)parameters
                             metadata:(BOOL)metadata
{
  return [[[FBGraphRequest alloc] initWithSession:session
                                         delegate:delegate
                                         callback:callback
                                          request:request
                                       parameters:parameters
                                         metadata:metadata] autorelease];
}

- (id)initWithSession:(FBGraphSession*)session
             delegate:(id)delegate
             callback:(SEL)callback
              request:(NSURL*)request
           parameters:(NSDictionary*)parameters
             metadata:(BOOL)metadata
{
  self = [super init];
  if (!self) return nil;

  _requestStarted  = NO;
  _requestFinished = NO;
  _connection      = nil;
  _responseBuffer  = nil;
  _response        = nil;

  _session      = [session retain];
  _delegate     = delegate;
  _callback     = callback;
  _request      = [request retain];
  _parameters   = [parameters retain];
  _getMetadata  = metadata;

  [self start];

  return self;
}

- (NSString*)description {
  return [[self query] absoluteString];
}

- (void)dealloc
{
  [_connection      release];
  [_responseBuffer  release];
  [_response        release];

  [_session     release];
  [_request     release];
  [_parameters  release];
  [super dealloc];
}

- (id)request {
  return _request;
}

- (id)response {
  return _response;
}

- (id)metadata {
  return [_response valueForKey:@"metadata"];
}

- (NSURL*)query
{
  NSMutableDictionary* reqParams = [NSMutableDictionary dictionary];

  // take original params
  [reqParams addEntriesFromDictionary:[_request queryData]];

  // add given params
  [reqParams addEntriesFromDictionary:_parameters];
  
  // add metadata if requested
  if (_getMetadata) {
    [reqParams setValue:@"1" forKey:@"metadata"];
  }

  // add auth key
  [reqParams setValue:[_session token] forKey:@"access_token"];

  // assemble and return query
  return [NSURL urlWithBase:_request queryData:reqParams];
}

- (void)start
{
  if (_requestStarted) {
    [NSException raise:@"Request already started" format:@""];
    return;
  }
  _requestStarted = YES;

  [self retain];

  @try {
    NSURL* url = [self query];

    #ifdef NSURLRequestReloadIgnoringLocalCacheData
    NSURLRequestCachePolicy policy = NSURLRequestReloadIgnoringLocalCacheData;
    #else
    NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;
    #endif

    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:policy
                                                   timeoutInterval:kRequestTimeout];

    [req setHTTPMethod:@"GET"];
    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [req setValue:@"FBGraph/0.0.1 (AppKit)" forHTTPHeaderField:@"User-Agent"];

    [_connection cancel];
    [_connection release];
    [_responseBuffer release];

    _connection     = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    _responseBuffer = [[NSMutableData alloc] init];

  } @catch (NSException* exception) {
    [self finished];
  }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
  [_responseBuffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
  NSString* rawJson = [[NSString alloc] initWithData:_responseBuffer
                                            encoding:NSUTF8StringEncoding];

  SBJsonParser* jsonParser = [SBJsonParser new];
  id json = [jsonParser fragmentWithString:rawJson];

  if (!json) {
    NSError* jsonError = [NSString stringWithFormat:@"JSON Parsing error: %@", [jsonParser errorTrace]];
    NSLog(@"%@", jsonError);
  } else {
    _response = [json retain];
  }

  [rawJson release];
  [jsonParser release];
  [self finished];
}

- (void)finished
{
  _requestFinished = YES;
  DELEGATE(_delegate, _callback);
  [self release];
}

@end
