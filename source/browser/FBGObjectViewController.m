//
//  FBGObjectViewController.m
//  iFBG
//
//  Created by Lee Byron on 4/9/10.
//  Copyright 2010 Facebook. All rights reserved.
//

#import "FBGObjectViewController.h"
#import "iFBGAppDelegate.h"


@implementation FBGObjectViewController

- (id)initWithData:(id)data
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (!self) return nil;

  _data = [data retain];

  id dataD = _data;
  if ([dataD isKindOfClass:[NSDictionary class]] && [dataD valueForKey:@"data"]) {
    dataD = [dataD valueForKey:@"data"];
  }

  _kv = [[NSMutableArray alloc] init];
  [self flatten:dataD toArray:_kv depth:0];

  NSDictionary* connections = [[_data objectForKey:@"metadata"] objectForKey:@"connections"];
  _links = [[NSMutableArray alloc] init];
  for (id key in connections) {
    [_links addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    key, @"key",
                    [connections valueForKey:key], @"url",
                    nil]];
  }

  self.tableView = [[FBGObjectView alloc] init];
  self.tableView.delegate = self;

  // do cool things.
  self.title = [_data valueForKey:@"name"];

  return self;
}

- (void)flatten:(id)data
        toArray:(NSMutableArray*)array
          depth:(NSInteger)depth
{
  if ([data isKindOfClass:[NSArray class]]) {

    for (NSUInteger i = 0; i < [data count]; i++) {
      id object = [data objectAtIndex:i];
      NSString* key = @"";
      if (![object isKindOfClass:[NSString class]] && [data count] > 1) {
        key = [NSString stringWithFormat:@"%d", i+1];
      }
      [self addKey:key object:object toArray:array depth:depth];
    }

  } else if ([data isKindOfClass:[NSDictionary class]]) {
     
    for (id key in data) {
      if ([key isEqualToString:@"metadata"]) {
        continue;
      }
      id object = [data objectForKey:key];
      [self addKey:key object:object toArray:array depth:depth];
    }

  }
}

- (void)addKey:(NSString*)key
        object:(id)object
       toArray:(NSMutableArray*)array
         depth:(NSInteger)depth
{
  if ([object isKindOfClass:[NSString class]] ||
      [object isKindOfClass:[NSNumber class]]) {
    [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                      key, @"key",
                      [NSString stringWithFormat:@"%@", object], @"value",
                      [NSNumber numberWithInt:depth], @"depth",
                      [NSNumber numberWithBool:NO], @"isHeader",
                      nil]];
  } else {
    if ([key length] > 0) {
      [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"", @"key",
                        key, @"value",
                        [NSNumber numberWithInt:depth], @"depth",
                        [NSNumber numberWithBool:YES], @"isHeader",
                        nil]];
    }
    [self flatten:object toArray:array depth:(depth+1)];
  }
}

- (void)dealloc
{
  [_data  release];
  [_kv    release];
  [_links release];
  [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return [_kv count];
  } else {
    return [_links count];
  }
}

- (NSInteger)tableView:(UITableView*)tableView indentationLevelForRowAtIndexPath:(NSIndexPath*)indexPath
{
  if ([indexPath indexAtPosition:0] == 0) {
    NSUInteger rowNum = [indexPath indexAtPosition:1];
    return [[[_kv objectAtIndex:rowNum] valueForKey:@"depth"] intValue];
  } else {
    return 0;
  }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  NSUInteger rowNum = [indexPath indexAtPosition:1];
  
  if ([indexPath indexAtPosition:0] == 0) {
    
    if (![[[_kv objectAtIndex:rowNum] valueForKey:@"key"] isEqualToString:@"id"]) {
      return;
    }
    
    NSURL* url = [NSURL URLWithString:
                  [NSString stringWithFormat:
                   @"http://graph.facebook.com/%@",
                   [[_kv objectAtIndex:rowNum] valueForKey:@"value"]]];
    iFBGAppDelegate* app = [[UIApplication sharedApplication] delegate];
    [app makeGraphRequest:url];
    
  } else if ([indexPath indexAtPosition:0] == 1) {
    
    NSURL* url = [NSURL URLWithString:[[_links objectAtIndex:rowNum] valueForKey:@"url"]];
    iFBGAppDelegate* app = [[UIApplication sharedApplication] delegate];
    [app makeGraphRequest:url];
    
  }
}

- (UITableViewCell*)tableView:(UITableView*)tableView
         cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  UITableViewCell* cell = nil;

  if ([indexPath indexAtPosition:0] == 0) {
    static NSString*CellIdentifier = @"Cell";

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier] autorelease];
    }

    NSUInteger rowNum = [indexPath indexAtPosition:1];

    // Configure the cell.
    cell.textLabel.text = [[_kv objectAtIndex:rowNum] valueForKey:@"value"];
    cell.detailTextLabel.text = [[_kv objectAtIndex:rowNum] valueForKey:@"key"];
    cell.accessoryType = [[[_kv objectAtIndex:rowNum] valueForKey:@"key"] isEqualToString:@"id"] ?
      UITableViewCellAccessoryDisclosureIndicator :
      UITableViewCellAccessoryNone;

  } else {
    static NSString*CellIdentifier = @"Link";

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSUInteger rowNum = [indexPath indexAtPosition:1];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[_links objectAtIndex:rowNum] valueForKey:@"key"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  return cell;
}

@end


@implementation FBGObjectView



@end
