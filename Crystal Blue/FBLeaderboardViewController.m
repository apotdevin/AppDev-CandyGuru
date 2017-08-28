//
//  FBLeaderboardViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 2/22/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import "FBLeaderboardViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import <Parse/Parse.h>

@interface FBLeaderboardViewController ()

@end

@implementation FBLeaderboardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    friends = [[NSMutableArray alloc] init];
    sortedArray = [[NSArray alloc] init];
    
    PFUser *actualUser = [PFUser currentUser];
    
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"FBID" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            
            [friends addObject:@{@"Name": [actualUser objectForKey:@"Name"] , @"Id" : [actualUser objectForKey:@"FBID"] , @"Xp": [NSNumber numberWithInteger:[[actualUser objectForKey:@"tXp"] integerValue]]}];
            
            for (int i=0; i<friendUsers.count; i++) {
                [friends addObject:@{@"Name": [friendUsers[i] objectForKey:@"Name"] , @"Id" : [friendUsers[i] objectForKey:@"FBID"] , @"Xp": [NSNumber numberWithInteger:[[friendUsers[i] objectForKey:@"tXp"] integerValue]]}];
            }
            
            NSSortDescriptor *xpDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Xp" ascending:NO];
            NSArray *sortDescriptors = @[xpDescriptor];
            sortedArray = [friends sortedArrayUsingDescriptors:sortDescriptors];
            
            [table reloadData];
            
        }
    }];
    
    /*
     [FBRequestConnection startWithGraphPath:@"/app/scores" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
     
     if (!error)
     {
         NSLog(@"Got Highscores!");
         
         NSDictionary *friendsArray = result;
         friends = [friendsArray objectForKey:@"data"];
         
         [table reloadData];
     }
     }];*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //like.objectID = @"https://www.facebook.com/CandyGuruApp";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sortedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomFacebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fbCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomFacebookTableViewCell" bundle:nil] forCellReuseIdentifier:@"fbCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"fbCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomFacebookTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *user = sortedArray[indexPath.row];
    
    NSString *name = [user objectForKey:@"Name"];
    NSString *userId = [user objectForKey:@"Id"];
    NSInteger score = [[user objectForKey:@"Xp"] integerValue];
    
    NSLog(@"name: %@\nscore: %ld",name,(long)score);
    
    /*
    NSMutableDictionary *packet = friends[indexPath.row];
    NSMutableDictionary *user = [packet objectForKey:@"user"];
    
    NSString *name = [user objectForKey:@"name"];
    NSString *userId = [user objectForKey:@"id"];
    NSString *score = [packet objectForKey:@"score"];
    */
    cell.cellImage.profileID = userId;
    cell.nameLabel.text = name;
    cell.infoLabel.text = [NSString stringWithFormat:@"Score: %ld xp",(long)score];
    if (indexPath.row==0) {
        cell.numberLabel.text = @"Guru";
    }
    else
    {
        cell.numberLabel.text = [NSString stringWithFormat:@"%li.",(long)indexPath.row+1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(BOOL)prefersStatusBarHidden
{
    return true;
}

@end