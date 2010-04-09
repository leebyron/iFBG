//
//  iFBGAppDelegate.m
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright Facebook 2010. All rights reserved.
//

#import "iFBGAppDelegate.h"
#import "FBGObjectViewController.h"


@implementation iFBGAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  navigationController = nil;
  window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [window makeKeyAndVisible];

  graphSession = [[FBGraphSession alloc] initWithOAuthToken:@"2227470867|2.viWH0Qdrd4GDsnNLC3DV5w__.3600.1270821600-4802170|2RIxOmPU4IdbSAlm2GU9BhUhB0Y."];

  NSURL* me = [NSURL URLWithString:@"https://graph.dev.facebook.com/me"];
  [self makeGraphRequest:me];
}

- (void)makeGraphRequest:(NSURL*)url {
  [graphSession queryWithDelegate:self
                         callback:@selector(gotGraphRequest:)
                          request:url
                         metadata:YES];
}

- (void)gotGraphRequest:(FBGraphRequest*)req {
  UIViewController* dataView;
  
  id data = [req response];

  dataView = [[FBGObjectViewController alloc] initWithData:data];

  if (!navigationController) {
    navigationController = [[UINavigationController alloc] initWithRootViewController:dataView];
    [window addSubview:[navigationController view]];
  } else {
    [navigationController pushViewController:dataView animated:YES];
  }
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];

  [graphSession release];

	[super dealloc];
}

@end
