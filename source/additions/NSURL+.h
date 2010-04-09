//
//  NSURL+.h
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright 2010 Facebook. All rights reserved.
//


@interface NSURL (Additions)

+ (NSURL*)urlWithBase:(NSURL*)url
            queryData:(NSDictionary*)queryData;

+ (NSURL*)urlWithScheme:(NSString*)scheme
                   host:(NSString*)host
                   path:(NSString*)path
              queryData:(NSDictionary*)queryData;

- (NSDictionary*)queryData;

@end
