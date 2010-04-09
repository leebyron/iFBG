//
//  iFBGAppDelegate.h
//  iFBG
//
//  Created by Lee Byron on 4/8/10.
//  Copyright Facebook 2010. All rights reserved.
//

/*
 * TODO
 *
 * Add a list of text fields for changing the query parameters based on introspection
 * Add pagination buttons when it exists
 * Render /picture for all objects which can use it
 * Groups renderings of lists of things.
 * NSOrderedDictionary
 *
 */

#import "FBGraphSession.h"


@interface iFBGAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UINavigationController *navigationController;

  FBGraphSession* graphSession;
}

- (void)makeGraphRequest:(NSURL*)url;

@end
