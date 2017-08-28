//
//  FBLeaderboardViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 2/22/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import "FBLeaderboardViewController.h"
#import "FacebookSDK/FacebookSDK.h"

@interface FBLeaderboardViewController ()

@end

@implementation FBLeaderboardViewController

- (void)viewWillAppear:(BOOL)animated
{
    friends = [[NSArray alloc] init];
    
     [FBRequestConnection startWithGraphPath:@"/app/scores" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
     
     if (!error)
     {
         NSLog(@"Got Highscores!");
         
         NSDictionary *friendsArray = result;
         friends = [friendsArray objectForKey:@"data"];
         /*
         for (int i=0; i<friends.count; i++)
         {
             NSMutableDictionary *packet = friends[i];
             NSMutableDictionary *user = [packet objectForKey:@"user"];
             
             NSString *name = [user objectForKey:@"name"];
             NSString *userId = [user objectForKey:@"id"];
             NSString *score = [packet objectForKey:@"score"];
             
             NSLog(@"Name: %@ Id: %@ Score: %@",name,userId,score);
         }*/
         
         [table reloadData];
     }
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return friends.count;
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
    NSMutableDictionary *packet = friends[indexPath.row];
    NSMutableDictionary *user = [packet objectForKey:@"user"];
    
    NSString *name = [user objectForKey:@"name"];
    NSString *userId = [user objectForKey:@"id"];
    NSString *score = [packet objectForKey:@"score"];
    
    cell.cellImage.profileID = userId;
    cell.nameLabel.text = name;
    cell.infoLabel.text = [NSString stringWithFormat:@"Score: %@ xp",score];
    cell.numberLabel.text = [NSString stringWithFormat:@"%li.",indexPath.row];
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}*/

-(BOOL)prefersStatusBarHidden
{
    return true;
}

@end