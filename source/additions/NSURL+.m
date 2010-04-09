//
//  NSURL+.m
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright 2010 Facebook. All rights reserved.
//

#import "NSURL+.h"
#import "NSString+.h"

@implementation NSURL (Additions)

+ (NSURL*)urlWithBase:(NSURL*)url
            queryData:(NSDictionary*)queryData
{
  return [NSURL urlWithScheme:[url scheme]
                         host:[url host]
                         path:[url path]
                    queryData:queryData];
}

+ (NSURL*)urlWithScheme:(NSString*)scheme
                   host:(NSString*)host
                   path:(NSString*)path
              queryData:(NSDictionary*)queryData
{
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@?%@",
                               scheme,
                               host,
                               path,
                               [NSString urlEncodeArguments:queryData],
                               nil]];
}

- (NSDictionary*)queryData
{
  return [[self query] urlDecodeArguments];
}

@end
