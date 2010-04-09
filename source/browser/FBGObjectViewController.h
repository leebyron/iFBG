//
//  FBGObjectViewController.h
//  iFBG
//
//  Created by Lee Byron on 4/9/10.
//  Copyright 2010 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBGObjectViewController : UITableViewController {
  id                _data;
  NSMutableArray*   _kv;
  NSMutableArray*   _links;
}

- (id)initWithData:(id)data;

- (void)flatten:(id)data
        toArray:(NSMutableArray*)array
          depth:(NSInteger)depth;

- (void)addKey:(NSString*)key
        object:(id)object
       toArray:(NSMutableArray*)array
         depth:(NSInteger)depth;

@end


@interface FBGObjectView : UITableView {

}

@end
