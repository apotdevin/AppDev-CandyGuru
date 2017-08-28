//
//  ParseHelper.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 3/4/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseHelper : NSObject

+(instancetype)sharedParseData;

-(void)loadOldGame:(PFUser*)user;
-(void)saveOldGame;

@end
