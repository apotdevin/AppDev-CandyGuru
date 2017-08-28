//
//  ShopViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/8/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "ShopViewController.h"
#import "CrystalAppDelegate.h"
#import "BannerHelper.h"
#import <StoreKit/StoreKit.h>
#import "CrystalblueIAPHelper.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UITableViewController *tableViewController = [[UITableViewController alloc] init];
    //tableViewController.tableView = table;
    
    //UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    //tableViewController.refreshControl = refreshControl;
    
    BOOL valid = NO;
    productPurchased = [[NSUserDefaults standardUserDefaults] secureBoolForKey:@"anthonypotdevin.crystalblue.removebanners" valid:&valid];
    if (!valid)
    {
        [[NSUserDefaults standardUserDefaults] setSecureBool:NO forKey:@"anthonypotdevin.crystalblue.removebanners"];
        NSLog(@"INVALID removeAds!");
    }
    if (!productPurchased) {
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(160, screenBounds.size.height-78);
        table.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    }
    else
    {
        NSLog(@"Banner removed");
    }
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentProgressColor"];
    tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    animationMoneyLabel.frame = CGRectMake(0, 0, 100, 100);
    animationMoneyLabel.textColor = tintColor;
    
    //initialize interface objects
    backHomeButton.center = CGPointMake(80, 544-88*[GameSaveState sharedGameData].screenSize);
    backLabButton.center = CGPointMake(240, 544-88*[GameSaveState sharedGameData].screenSize);
    table.frame = CGRectMake(0, 118, 320, 397-88*[GameSaveState sharedGameData].screenSize);
    
    //initialize interface labels
    moneyLabel.text = [NSString stringWithFormat:@"Money: %li",(long)[GameSaveState sharedGameData].money];
    levelLabel.text = [NSString stringWithFormat:@"Level: %i",(int)[GameSaveState sharedGameData].level];
    moneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    levelLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    
    materialsButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    instrumentsButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    technologyButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    specialsButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    [materialsButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [instrumentsButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [technologyButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [specialsButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    backHomeButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    backLabButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    [backHomeButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [backLabButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    //initialize arrays
    materiales = [[NSMutableArray alloc]init];
    materiales2 = [[NSMutableArray alloc]init];
    instruments = [[NSMutableArray alloc]init];
    instruments2 = [[NSMutableArray alloc]init];
    technology = [[NSMutableArray alloc]init];
    iconosMateriales = [[NSArray alloc]init];
    iconosMateriales2 = [[NSArray alloc]init];
    iconosInstruments = [[NSArray alloc]init];
    iconosInstruments2 = [[NSArray alloc]init];
    specials = [[NSMutableArray alloc]init];
    specialsAndShop = [[NSMutableArray alloc]init];
    
    [materiales addObject:@{@"Name": @"6 Pills" , @"Info" : @"Works for 1 portion of White Powder" , @"Price": @"95" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"1 Matchbox" , @"Info" : @"Works for 1 portion of Red Powder" , @"Price": @"30" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"12 Pills" , @"Info" : @"Works for 2 portions of White Powder" , @"Price": @"170" , @"Unlocks":@"3"}];
    [materiales addObject:@{@"Name": @"2 Matchboxes" , @"Info" : @"Works for 2 portions of Red Powder" , @"Price": @"50" , @"Unlocks":@"3"}];
    [materiales addObject:@{@"Name": @"42 Pills" , @"Info" : @"Works for 7 portions of White Powder" , @"Price": @"610" , @"Unlocks":@"5"}];
    [materiales addObject:@{@"Name": @"7 Matchboxes" , @"Info" : @"Works for 7 portions of Red Powder" , @"Price": @"185" , @"Unlocks":@"5"}];
    
    [materiales2 addObject:@{@"Name": @"1 Aluminium Roll" , @"Info" : @"Works for 1 portion of Grey Powder" , @"Price": @"950" , @"Unlocks":@"12"}];
    [materiales2 addObject:@{@"Name": @"5 Aluminium Roll" , @"Info" : @"Works for 5 portions of Grey Powder" , @"Price": @"4250" , @"Unlocks":@"16"}];
    
    [instruments addObject:@{@"Name": @"Crushing Speed 2" , @"Info" : @"Crush pills faster!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Scraping Speed 2" , @"Info" : @"Scrape a matchbox faster!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Pot Size 2" , @"Info" : @"Chance of making 1 more batch of liquid Crystal but increases cooking time." , @"Price": @"3500" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Storage Size 2" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!" , @"Price": @"3500" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Extractor Speed 2" , @"Info" : @"Will help to eliminate lab toxins faster!" , @"Price": @"15000" , @"Unlocks":@"7"}];
    
    [instruments2 addObject:@{@"Name": @"Cutting Speed 2" , @"Info" : @"Obtain Grey Powder faster!" , @"Price": @"100000" , @"Unlocks":@"14"}];
    [instruments2 addObject:@{@"Name": @"Mixer Size 2" , @"Info" : @"Chance of making 1 more batch of liquid Crystal but increases mixing time." , @"Price": @"300000" , @"Unlocks":@"15"}];
    [instruments2 addObject:@{@"Name": @"Upgraded Storage Size 5" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!!" , @"Price": @"80000" , @"Unlocks":@"13"}];
    [instruments2 addObject:@{@"Name": @"Extractor Speed 2" , @"Info" : @"Will help to eliminate lab toxins faster!" , @"Price": @"15000" , @"Unlocks":@"7"}];
    
    [technology addObject:@{@"Name": @"Advanced Chemical Process" , @"Info" : @"Changes the lab setting for a faster, easier, cheaper way of obtaining liquid Crystal. (Needs Suburban House!)" , @"Price": @"400000" , @"Unlocks":@"12"}];
    [technology addObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 2 Trays." , @"Price": @"900" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Grey Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"2"}];
    [technology addObject:@{@"Name": @"Campsite Location" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    [technology addObject:@{@"Name": @"Seller 1" , @"Info" : @"Hire a dealer to expand your Crystal Empire! View in Contracts." , @"Price": @"1200" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Bully 1" , @"Info" : @"Hire a thug to spread your name and earn Xp! View in Contracts." , @"Price": @"3000" , @"Unlocks":@"2"}];
    [technology addObject:@{@"Name": @"Lawyer 1" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"2000" , @"Unlocks":@"3"}];
    [technology addObject:@{@"Name": @"Spy 1" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"1500" , @"Unlocks":@"2"}];
    
    [specials addObject:@{@"Name": @"Free Money!" , @"Info" : @"Share with one of your friends and recieve $150!" , @"Price": @"Free!" , @"Unlocks":@"1"}];
    
    iconosMateriales = [NSArray arrayWithObjects:
                        @"6Pills",
                        @"1Matchbox",
                        @"12Pills",
                        @"2Matchbox",
                        @"24Pills",
                        @"7Matchbox",
                        nil];
    iconosMateriales2 = [NSArray arrayWithObjects:
                        @"1Aluminum",
                        @"5Aluminum",
                        nil];
    iconosInstruments = [NSArray arrayWithObjects:
                        @"GlassIcon",
                        @"BowlIcon",
                        @"PotIcon",
                        @"DecantorIcon",
                        @"Glass2Icon",
                        @"Pot2Icon",
                        @"DestillatorIcon",
                        nil];
    iconosInstruments2 = [NSArray arrayWithObjects:
                         @"Glass2Icon",
                         @"Pot2Icon",
                         @"DestillatorIcon",
                         nil];
    
    specialsAndShop = [NSMutableArray arrayWithArray:specials];
    
    [self updateTableInfo];
    
    if ([GameSaveState sharedGameData].currentShopList==0) {
        if ([GameSaveState sharedGameData].currentLabSetting==1) {
            currentArray = materiales;
        }
        else
        {
            currentArray = materiales2;
        }
    }
    else if ([GameSaveState sharedGameData].currentShopList==1) {
        if ([GameSaveState sharedGameData].currentLabSetting==1) {
            currentArray = instruments;
        }
        else
        {
            currentArray = instruments2;
        }
    }
    else if ([GameSaveState sharedGameData].currentShopList==2) {
        currentArray = technology;
    }
    else {
        currentArray = specialsAndShop;
    }
    
    [self refresh];
}

- (void)refresh
{
    productsArray = nil;
    
    [[CrystalblueIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            productsArray = products;
            if (productsArray !=nil) {
                specialsAndShop = [NSMutableArray arrayWithArray:[specials arrayByAddingObjectsFromArray:productsArray]];
            }
            [table reloadData];
            [self refreshInterfaceValues];
        }
    }];
}

- (void)refreshInterfaceValues
{
    moneyLabel.text = [NSString stringWithFormat:@"Money: %li",(long)[GameSaveState sharedGameData].money];
    levelLabel.text = [NSString stringWithFormat:@"Level: %i",(int)[GameSaveState sharedGameData].level];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    }
    
    [cell.buyButton setTag:indexPath.row];
    [cell.buyButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomShopTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.nameLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    cell.infoLabel.font = [UIFont fontWithName:@"28 Days Later" size:10];
    cell.buyButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    
    int whatLevel = 0;
    NSString *name = @"NULL";
    NSString *info  = @"NULL";
    NSString *price = @"NONE";
    NSDictionary *rowData = currentArray[indexPath.row];
    
    if (![currentArray isEqualToArray:specialsAndShop]) {
        whatLevel = [rowData[@"Unlocks"] intValue];
        name = rowData[@"Name"];
        info = rowData[@"Info"];
        price = rowData[@"Price"];
    }
    else if ([currentArray isEqualToArray:specialsAndShop]&&indexPath.row==0)
    {
        whatLevel = [rowData[@"Unlocks"] intValue];
        name = rowData[@"Name"];
        info = rowData[@"Info"];
        price = rowData[@"Price"];
    }
    else if ([currentArray isEqualToArray:specialsAndShop]&&indexPath.row>0)
    {
        SKProduct * product = (SKProduct *) productsArray[indexPath.row-1];
        name = product.localizedTitle;
        info = product.localizedDescription;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:product.priceLocale];
        
        price = [formatter stringFromNumber:product.price];
        if ([name isEqualToString:@"Remove Banner Ads!"]&&productPurchased==YES) {
            price = @"Bought!";
        }
    }
    
    if (whatLevel>[GameSaveState sharedGameData].level) {
        NSString *blocked = [NSString stringWithFormat:@"Level: %i",whatLevel];
        [cell.buyButton setTitle:blocked forState:UIControlStateNormal];
    }
    else
    {
        [cell.buyButton setTitle:price forState:UIControlStateNormal];
    }
    
    if ([name isEqualToString:@"Advanced Chemical Process"]&&[GameSaveState sharedGameData].currentLabBackground<=6)
    {
        [cell.buyButton setTitle:@"Locked" forState:UIControlStateNormal];
    }
    if ([name isEqualToString:@"MAXED OUT"]) {
        [cell.buyButton setTitle:@"-" forState:UIControlStateNormal];
    }
    
    cell.nameLabel.text = name;
    cell.infoLabel.text = info;
    
    if ([currentArray isEqualToArray:materiales]) {
        cell.cellImage.image = [UIImage imageNamed:iconosMateriales[indexPath.row]];
    }
    else if ([currentArray isEqualToArray:materiales2])
    {
        cell.cellImage.image = [UIImage imageNamed:iconosMateriales2[indexPath.row]];
    }
    else if ([currentArray isEqualToArray:instruments])
    {
        if (indexPath.row<4) {
            cell.cellImage.image = [UIImage imageNamed:iconosInstruments[indexPath.row]];
        }
        else
        {
            NSString *cualExtractor = [NSString stringWithFormat:@"Extractor%iIcon",(int)[GameSaveState sharedGameData].currentExtractor+1];
            cell.cellImage.image = [UIImage imageNamed:cualExtractor];
            if ([GameSaveState sharedGameData].currentLabBackground<=3) {
                [cell.buyButton setTitle:@"Locked" forState:UIControlStateNormal];
            }
        }
    }
    else if ([currentArray isEqualToArray:instruments2])
    {
        if (indexPath.row<3) {
            cell.cellImage.image = [UIImage imageNamed:iconosInstruments2[indexPath.row]];
        }
        else
        {
            NSString *cualExtractor = [NSString stringWithFormat:@"Extractor%iIcon",(int)[GameSaveState sharedGameData].currentExtractor+1];
            cell.cellImage.image = [UIImage imageNamed:cualExtractor];
            if ([GameSaveState sharedGameData].currentLabBackground<=3) {
                [cell.buyButton setTitle:@"Locked" forState:UIControlStateNormal];
            }
        }
    }
    else if ([currentArray isEqualToArray:technology])
    {
        if (indexPath.row==2)
        {
            if ([GameSaveState sharedGameData].currentCrystalColor==10) {
                cell.cellImage.image = [UIImage imageNamed:@"9CrystalsIcon"];
            }
            else
            {
                NSString *cualCrystal = [NSString stringWithFormat:@"%iCrystalsIcon",(int)[GameSaveState sharedGameData].currentCrystalColor];
                cell.cellImage.image = [UIImage imageNamed:cualCrystal];
            }
        }
        else if (indexPath.row==0) {
            cell.cellImage.image = [UIImage imageNamed:@"AdvancedChemicalProcess"];
        }
        else if (indexPath.row==1)
        {
            cell.cellImage.image = [UIImage imageNamed:@"ExtraTray"];
        }
        else if (indexPath.row==3)
        {
            if ([GameSaveState sharedGameData].currentLabBackground==11) {
                cell.cellImage.image = [UIImage imageNamed:@"11LocationIcon"];
            }
            else
            {
                NSString *cualBackground = [NSString stringWithFormat:@"%iLocationIcon",(int)[GameSaveState sharedGameData].currentLabBackground+1];
                cell.cellImage.image = [UIImage imageNamed:cualBackground];
            }
        }
        else if (indexPath.row==4) {
            if ([GameSaveState sharedGameData].currentSeller<10) {
                NSString *cualSeller = [NSString stringWithFormat:@"%iSeller",(int)[GameSaveState sharedGameData].currentSeller];
                cell.cellImage.image = [UIImage imageNamed:cualSeller];
            }
            else
            {
                cell.cellImage.image = [UIImage imageNamed:@"9Seller"];
            }
        }
        else if (indexPath.row==5) {
            cell.cellImage.image = [UIImage imageNamed:@"ProgressImage"];
        }
        else if (indexPath.row==6) {
            cell.cellImage.image = [UIImage imageNamed:@"Lawyer"];
        }
        else if (indexPath.row==7) {
            cell.cellImage.image = [UIImage imageNamed:@"Spy"];
        }
    }
    /*else if ([currentArray isEqualToArray:specialsAndShop])
    {
        if (indexPath.row>0)
        {
            
        }
    }*/
    
    else
    {
        cell.cellImage.image = [UIImage imageNamed:@"ProgressImage"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void) buttonPressed:(UIButton *)sender
{
    int price = 0 ;
    int level = 1 ;
    NSString *name = @"NULL";
    
    if (![currentArray isEqualToArray:specialsAndShop]) {
        NSDictionary *rowData = currentArray[sender.tag];
        price = [rowData[@"Price"] intValue];
        level = [rowData[@"Unlocks"] intValue];
        name = [rowData objectForKey:@"Name"];
    }
    else if ([currentArray isEqualToArray:specialsAndShop]&&sender.tag==0)
    {
        NSDictionary *rowData = currentArray[sender.tag];
        price = [rowData[@"Price"] intValue];
        level = [rowData[@"Unlocks"] intValue];
        name = [rowData objectForKey:@"Name"];
    }
    else if ([currentArray isEqualToArray:specialsAndShop]&&sender.tag>0)
    {
        SKProduct * product = (SKProduct *) productsArray[sender.tag-1];
        name = product.localizedTitle;
    }
    
    if (price<=[GameSaveState sharedGameData].money&&level<=[GameSaveState sharedGameData].level)
    {
        if ([currentArray isEqualToArray:materiales])
        {
            if (![sender.currentTitle isEqualToString:@"Locked"]) {
                [self changeMoney:-price];
                [self updateMaterialQuantity:(int)sender.tag];
            }
        }
        else if ([currentArray isEqualToArray:materiales2])
        {
            if (![sender.currentTitle isEqualToString:@"Locked"]) {
                [self changeMoney:-price];
                [self updateMaterial2Quantity:(int)sender.tag];
            }
        }
        else if ([currentArray isEqualToArray:instruments])
        {
            if (![name isEqualToString:@"MAXED OUT"]&&![sender.currentTitle isEqualToString:@"Locked"])
            {
                [self changeMoney:-price];
                [self updateInstrumentLevel:(int)sender.tag];
                [self updateTableInfo];
                [table reloadData];
            }
        }
        else if ([currentArray isEqualToArray:instruments2])
        {
            if (![name isEqualToString:@"MAXED OUT"]&&![sender.currentTitle isEqualToString:@"Locked"])
            {
                [self changeMoney:-price];
                [self updateInstrument2Level:(int)sender.tag];
                [self updateTableInfo];
                [table reloadData];
            }
        }
        else if ([currentArray isEqualToArray:technology])
        {
            if (![name isEqualToString:@"MAXED OUT"]&&![sender.currentTitle isEqualToString:@"Locked"])
            {
                [self changeMoney:-price];
                [self updateTechnologyLevel:(int)sender.tag];
                [self updateTableInfo];
                [table reloadData];
            }
        }
        else if ([currentArray isEqualToArray:specialsAndShop])
        {
            if ([name isEqualToString:@"Remove Banner Ads!"]&&productPurchased==YES) {
                NSLog(@"Remove ads already purchased");
            }
            else
            {
                [self specialButtonPressed:(int)sender.tag];
            }
        }
    }
    else if (level<=[GameSaveState sharedGameData].level)
    {
        [self animateNeededMoney];
    }
    else
    {
        [self animateNeededLevel];
    }
}

- (void)specialButtonPressed:(int)whichRow
{
    if (whichRow==0)
    {
        
        NSString *text = @"Can you become a more fearfull and dominating crystal lord? Try it out in this awesome new game on the App Store! Crystal Blue!";
        UIImage *image = [UIImage imageNamed:@"Icon-Small"];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[text, image] applicationActivities:nil];
        controller.excludedActivityTypes = @[//UIActivityTypePostToWeibo,
                                             //UIActivityTypeMessage,
                                             //UIActivityTypeMail,
                                             UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
                                             UIActivityTypeAirDrop];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        [controller setCompletionHandler:^(NSString *activityType, BOOL completed)
         {
             if (completed)
             {
                 [[GameSaveState sharedGameData] changeMoney:150];
                 NSLog(@"share completed");
             }
             else
             {
                 NSLog(@"share not completed");
             }
         }];
    }
    else
    {
        SKProduct *product = productsArray[whichRow-1];
        NSLog(@"Buying %@...",product.productIdentifier);
        [[CrystalblueIAPHelper sharedInstance] buyProduct:product];
    }
}

- (void)updateTechnologyLevel:(int)whichRow
{
    if (whichRow==0)
    {
        [self increaseSettingPurity];
        [GameSaveState sharedGameData].currentLabSetting+=1;
        [[GameCenterHelper sharedGC] buyThingsAchievements];
    }
    else if (whichRow==1)
    {
        [GameSaveState sharedGameData].currentFreezers++;
    }
    else if (whichRow==2)
    {
        [[GameSaveState sharedGameData] changePurity:345];
        [GameSaveState sharedGameData].currentCrystalColor++;
    }
    else if (whichRow==3)
    {
        [[GameSaveState sharedGameData] changePurity:240];
        [GameSaveState sharedGameData].currentLabBackground++;
    }
    else if (whichRow==4)
    {
        [GameSaveState sharedGameData].currentSeller+=1;
    }
    else if (whichRow==5)
    {
        [GameSaveState sharedGameData].currentBully++;
    }
    else if (whichRow==6)
    {
        [GameSaveState sharedGameData].currentLawyer++;
    }
    else if (whichRow==7)
    {
        [GameSaveState sharedGameData].currentSpy++;
        [GameSaveState sharedGameData].changeDanger=1;
    }
}

- (void)updateInstrumentLevel:(int)whichRow
{
    if (whichRow==0)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentGlass++;
    }
    else if (whichRow==1)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentBowl++;
    }
    else if (whichRow==2)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentPot++;
    }
    else if (whichRow==3)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentDecantor++;
    }
    else if (whichRow==4)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentExtractor++;
    }
}

- (void)updateInstrument2Level:(int)whichRow
{
    if (whichRow==0)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentBeaker++;
    }
    else if (whichRow==1)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentMixer++;
    }
    else if (whichRow==2)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentDistilator++;
    }
    else if (whichRow==3)
    {
        [[GameSaveState sharedGameData] changePurity:105];
        [GameSaveState sharedGameData].currentExtractor++;
    }
}

- (void)updateMaterialQuantity:(int)whichRow
{
    if (whichRow==0)
    {
        [GameSaveState sharedGameData].pills+=6;
        [GameSaveState sharedGameData].totalPills+=6;
    }
    else if (whichRow==1)
    {
        [GameSaveState sharedGameData].matchbox+=1;
        [GameSaveState sharedGameData].totalMatchboxes+=1;
    }
    else if (whichRow==2)
    {
        [GameSaveState sharedGameData].pills+=12;
        [GameSaveState sharedGameData].totalPills+=12;
    }
    else if (whichRow==3)
    {
        [GameSaveState sharedGameData].matchbox+=2;
        [GameSaveState sharedGameData].totalMatchboxes+=2;
    }
    else if (whichRow==4)
    {
        [GameSaveState sharedGameData].pills+=24;
        [GameSaveState sharedGameData].totalPills+=24;
    }
    else if (whichRow==5)
    {
        [GameSaveState sharedGameData].matchbox+=7;
        [GameSaveState sharedGameData].totalMatchboxes+=7;
    }
}

- (void)updateMaterial2Quantity:(int)whichRow
{
    if (whichRow==0)
    {
        [GameSaveState sharedGameData].aluminum+=1;
        [GameSaveState sharedGameData].totalAluminum+=1;
    }
    else if (whichRow==1)
    {
        [GameSaveState sharedGameData].aluminum+=5;
        [GameSaveState sharedGameData].totalAluminum+=5;
    }
}

- (void)updateTableInfo
{
    NSMutableArray *cualInstruments;
    int cualExtractor = 0;
    
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        cualInstruments = instruments;
        cualExtractor = 4;
    }
    else
    {
        cualInstruments = instruments2;
        cualExtractor = 3;
    }
    
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentFreezers==2)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 3 Trays." , @"Price": @"5000" , @"Unlocks":@"4"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==3)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 4 Trays." , @"Price": @"11000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==4)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 5 Trays." , @"Price": @"16000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==5)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 6 Trays." , @"Price": @"21000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==6)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 7 Trays." , @"Price": @"30000" , @"Unlocks":@"8"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==7)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 8 Trays." , @"Price": @"45000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==8)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 9 Trays." , @"Price": @"60000" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==9)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 10 Trays." , @"Price": @"100000" , @"Unlocks":@"11"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==10)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 11 Trays." , @"Price": @"150000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==11)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 12 Trays." , @"Price": @"200000" , @"Unlocks":@"13"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==12)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 13 Trays." , @"Price": @"350000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==13)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 14 Trays." , @"Price": @"500000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==14)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 15 Trays." , @"Price": @"700000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==15)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 16 Trays." , @"Price": @"950000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==16)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 17 Trays." , @"Price": @"1300000" , @"Unlocks":@"18"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==17)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 18 Trays." , @"Price": @"1700000" , @"Unlocks":@"19"}];
    }
    else if ([GameSaveState sharedGameData].currentFreezers==18)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentLabBackground==2) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Car Trunk" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"7000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==3) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Car Trailer" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"12000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==4) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Motel Room" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"20000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==5) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Basement" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"40000" , @"Unlocks":@"11"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==6) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Suburban House" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"55000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==7) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Abandoned Barn" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"110000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==8) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Warehouse" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"150000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==9) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"University Lab" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"200000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==10) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Secret Laboratory" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will NOT affect you!" , @"Price": @"350000" , @"Unlocks":@"19"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==11) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentLabSetting==2) {
        [technology replaceObjectAtIndex:0 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentGlass==2) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"Crushing Speed 3" , @"Info" : @"Crush pills faster!" , @"Price": @"8000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentGlass==3) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"Crushing Speed 4" , @"Info" : @"Crush pills faster!" , @"Price": @"25000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentGlass==4) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"5"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentBowl==2) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"Scraping Speed 3" , @"Info" : @"Scrape matchboxes faster!" , @"Price": @"5000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentBowl==3) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"Scraping Speed 4" , @"Info" : @"Scrape matchboxes faster!" , @"Price": @"15000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentBowl==4) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentPot==2) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"Pot Size 3" , @"Info" : @"Chance of making 1 more batch of liquid Crystal but increases cooking time." , @"Price": @"11000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentPot==3) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"Pot Size 4" , @"Info" : @"Chance of making 1 more batch of liquid Crystal but increases cooking time." , @"Price": @"50000" , @"Unlocks":@"11"}];
    }
    else if ([GameSaveState sharedGameData].currentPot==4) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentDecantor==2) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"Storage Size 3" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!" , @"Price": @"10000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentDecantor==3) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"Storage Size 4" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!" , @"Price": @"22000" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentDecantor==4) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentExtractor==2) {
        [cualInstruments replaceObjectAtIndex:cualExtractor withObject:@{@"Name": @"Extractor Speed 3" , @"Info" : @"Will help to eliminate lab toxins faster!" , @"Price": @"50000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentExtractor==3) {
        [cualInstruments replaceObjectAtIndex:cualExtractor withObject:@{@"Name": @"Extractor Speed 4" , @"Info" : @"Will help to eliminate lab toxins faster!" , @"Price": @"140000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentExtractor==4) {
        [cualInstruments replaceObjectAtIndex:cualExtractor withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentBeaker==2) {
        [instruments2 replaceObjectAtIndex:0 withObject:@{@"Name": @"Cutting Speed 3" , @"Info" : @"Obtain Grey Powder faster!" , @"Price": @"200000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentBeaker==3) {
        [instruments2 replaceObjectAtIndex:0 withObject:@{@"Name": @"Cutting Speed 4" , @"Info" : @"Obtain Grey Powder faster!" , @"Price": @"310000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentBeaker==4) {
        [instruments2 replaceObjectAtIndex:0 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentMixer==2) {
        [instruments2 replaceObjectAtIndex:1 withObject:@{@"Name": @"Mixer Size 3" , @"Info" : @"Chance of making 1 more batch of liquid Crystal but increases mixing time." , @"Price": @"400000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentMixer==3) {
        [instruments2 replaceObjectAtIndex:1 withObject:@{@"Name": @"Mixer Size 4" , @"Info" : @"Chance of making 1 more batch of liquid Crystal but increases mixing time." , @"Price": @"550000" , @"Unlocks":@"18"}];
    }
    else if ([GameSaveState sharedGameData].currentMixer==4) {
        [instruments2 replaceObjectAtIndex:1 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentDistilator==2) {
        [instruments2 replaceObjectAtIndex:2 withObject:@{@"Name": @"Upgraded Storage Size 6" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!!" , @"Price": @"140000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentDistilator==3) {
        [instruments2 replaceObjectAtIndex:2 withObject:@{@"Name": @"Upgraded Storage Size 7" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!!" , @"Price": @"190000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentDistilator==4) {
        [instruments2 replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentCrystalColor==2) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Black Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"2000" , @"Unlocks":@"3"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==3) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Green Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"8000" , @"Unlocks":@"4"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==4) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Yellow Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"20000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==5) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Purple Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"50000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==6) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Red Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"100000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==7) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"White Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"210000" , @"Unlocks":@"8"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==8) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Blue Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"470000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==9) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Crystal Blue Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000000" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==10) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1990000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentSeller==1)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 2" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"2400" , @"Unlocks":@"3"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==2)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 3" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"6000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==3)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 4" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"15000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==4)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 5" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"21000" , @"Unlocks":@"8"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==5)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 6" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"50000" , @"Unlocks":@"11"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==6)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 7" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"130000" , @"Unlocks":@"13"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==7)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 8" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"170000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==8)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 9" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"240000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==9)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 10" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"300000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==10)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentBully==1) {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 2" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"5000" , @"Unlocks":@"4"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==2)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 3" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"9000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==3)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 4" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"16000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==4)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 5" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"7500" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==5)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 6" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"50000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==6)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 7" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"150000" , @"Unlocks":@"13"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==7)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 8" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"200000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==8)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 9" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"300000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==9)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 10" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"400000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==10)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentLawyer==1) {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 2" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"5000" , @"Unlocks":@"4"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==2)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 3" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"5900" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==3)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 4" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"8500" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==4)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 5" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"12000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==5)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 6" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"14300" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==6)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 7" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"42000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==7)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 8" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"120000" , @"Unlocks":@"13"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==8)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 9" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"180000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==9)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 10" , @"Info" : @"Reduces the cost when you get into trouble! (Also reduces chance of trouble)" , @"Price": @"240000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==10)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentSpy==1) {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 2" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"1700" , @"Unlocks":@"3"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==2)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 3" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"5000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==3)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 4" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"8500" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==4)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 5" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"15000" , @"Unlocks":@"8"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==5)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 6" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"27000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==6)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 7" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"38000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==7)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 8" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"70000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==8)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 9" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"170000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==9)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 10" , @"Info" : @"Will reduce the danger of going to other places! (Also increases amount of customer arrivals)" , @"Price": @"220000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==10)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
}

//-------------------------------------------------------------------------------
//animation level label
//-------------------------------------------------------------------------------
- (void)animateNeededLevel
{
    levelLabel.font = [UIFont fontWithName:@"28 Days Later" size:22];
    levelLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [self performSelector:@selector(reverseAnimationLevel) withObject:nil afterDelay:0.5];
}

- (void)reverseAnimationLevel
{
    levelLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    levelLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

//-------------------------------------------------------------------------------
//animation money label
//-------------------------------------------------------------------------------
- (void)animateNeededMoney
{
    moneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:22];
    moneyLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [self performSelector:@selector(reverseAnimationMoney) withObject:nil afterDelay:0.5];
}

- (void)reverseAnimationMoney
{
    moneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    moneyLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}
//-------------------------------------------------------------------------------

- (void)animateMoneyChange:(int)cuanto
{
    int randomX = arc4random()%230+50;
    int randomY = arc4random()%50+350;
    
    NSString *animationText;
    if (cuanto>=1000) {
        float cuantoDividido = (float)cuanto/1000;
        animationText = [NSString stringWithFormat:@"%1.0fk",cuantoDividido];
    }
    else
    {
        animationText = [NSString stringWithFormat:@"%i",cuanto];
    }
    
    animationMoneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:35];
    animationMoneyLabel.text = animationText;
    animationMoneyLabel.center = CGPointMake(randomX, randomY);
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         animationMoneyLabel.center = CGPointMake(randomX, randomY-200);
                     }
                     completion:nil ];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         animationMoneyLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              animationMoneyLabel.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
}

- (void)changeMoney:(int)cuanto
{
    [[GameSaveState sharedGameData] changeMoney:cuanto];
    
    [self sonidoMoney];
    [self animateMoneyChange:cuanto];
    
    [self refreshInterfaceValues];
}

- (void)sonidoMoney
{
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"soundOnOrOff"]==0) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"moneySound" ofType:@"wav"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
        AudioServicesPlaySystemSound (soundID);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)materialsButton:(id)sender
{
    [GameSaveState sharedGameData].currentShopList=0;
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        currentArray = materiales;
    }
    else
    {
        currentArray = materiales2;
    }
    [table reloadData];
}

- (IBAction)instrumentsButton:(id)sender
{
    [GameSaveState sharedGameData].currentShopList=1;
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        currentArray = instruments;
    }
    else
    {
        currentArray = instruments2;
    }
    [table reloadData];
}

- (IBAction)specialsButton:(id)sender
{
    [GameSaveState sharedGameData].currentShopList=3;
    currentArray = specialsAndShop;
    [table reloadData];
}

- (IBAction)technologyButton:(id)sender
{
    [GameSaveState sharedGameData].currentShopList=2;
    currentArray = technology;
    [table reloadData];
}

- (IBAction)backHomeButton:(id)sender
{
    [self performSegueWithIdentifier:@"exitShopToHome" sender:self];
    //[GameSaveState sharedGameData].changingBetweenLabAndShop = 0;
}

- (IBAction)backLabButton:(id)sender
{
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"labVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)increaseSettingPurity
{
    [[GameSaveState sharedGameData] changePurity:-105*[GameSaveState sharedGameData].currentGlass];
    [[GameSaveState sharedGameData] changePurity:-105*[GameSaveState sharedGameData].currentBowl];
    [[GameSaveState sharedGameData] changePurity:-105*[GameSaveState sharedGameData].currentPot];
    [[GameSaveState sharedGameData] changePurity:-105*[GameSaveState sharedGameData].currentDecantor];
    [[GameSaveState sharedGameData] changePurity:2680];
}

- (void)productPurchased:(NSNotification *)notification {
    NSString * productIdentifier = notification.object;
    [productsArray enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([GameSaveState sharedGameData].currentShopList==3) {
        [GameSaveState sharedGameData].currentShopList=0;
    }
    [[BannerHelper sharedAd].bannerView removeFromSuperview];
}

@end
