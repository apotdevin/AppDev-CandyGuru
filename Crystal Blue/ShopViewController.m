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
#import "SoundHelper.h"
#import "RMStore.h"
#import "Parse/Parse.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface ShopViewController ()

@end

@implementation ShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    productPurchased=NO;
    if ([GameSaveState sharedGameData].removeBanners==641) {
        productPurchased=YES;
    }
    if (!productPurchased) {
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        table.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        
        if ([GameSaveState sharedGameData].screenSize==0)
        {
            [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-78);
        }
        else if ([GameSaveState sharedGameData].screenSize==1)
        {
            [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-70);
        }
        else if ([GameSaveState sharedGameData].screenSize==2)
        {
            [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-81);
        }
        else if ([GameSaveState sharedGameData].screenSize==3)
        {
            [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-85);
        }
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]!=YES) {
        [BannerHelper sharedAd].bannerView.alpha = 0;
    }
    /*if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]!=YES)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height+25);
        NSLog(@"Banner no por tutorial");
    }*/
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentProgressColor"];
    tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    animationMoneyLabel.frame = CGRectMake(0, 0, 150, 100);
    animationMoneyLabel.textColor = tintColor;
    
    //initialize interface objects
    /*[materialsButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [instrumentsButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [technologyButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [specialsButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    //initialize interface labels
    [backHomeButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [backLabButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];*/
    
    moneyLabel.text = [NSString stringWithFormat:@"Money: %li",(long)[GameSaveState sharedGameData].money];
    levelLabel.text = [NSString stringWithFormat:@"Level: %i",(int)[GameSaveState sharedGameData].level];
    [self refreshAmountOfMaterials];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if ([GameSaveState sharedGameData].screenSize==1||[GameSaveState sharedGameData].screenSize==0)
    {
        backHomeButton.center = CGPointMake(80, 544-83*[GameSaveState sharedGameData].screenSize);
        backLabButton.center = CGPointMake(240, 544-83*[GameSaveState sharedGameData].screenSize);
        table.frame = CGRectMake(0, 118-20*[GameSaveState sharedGameData].screenSize, 320, 397-60*[GameSaveState sharedGameData].screenSize);
        
        moneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        levelLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        materialsButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        instrumentsButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        technologyButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        specialsButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        backHomeButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        backLabButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
        amountOfMaterials.font =[UIFont fontWithName:@"AllerDisplay" size:20];
        
        if ([GameSaveState sharedGameData].screenSize==1)
        {
            materialsButton.center = CGPointMake(70, 45);
            instrumentsButton.center = CGPointMake(70, 80);
            technologyButton.center = CGPointMake(screenBounds.size.width-70, 45);
            specialsButton.center = CGPointMake(screenBounds.size.width-70, 80);
        }
    }
    
    else if ([GameSaveState sharedGameData].screenSize!=1&&[GameSaveState sharedGameData].screenSize!=0)
    {
        moneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        levelLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        materialsButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        instrumentsButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        technologyButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        specialsButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        backHomeButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        backLabButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        amountOfMaterials.font =[UIFont fontWithName:@"AllerDisplay" size:20*(1+0.05*[GameSaveState sharedGameData].screenSize)];
        
        if ([GameSaveState sharedGameData].screenSize==2)
        {
            backHomeButton.center = CGPointMake(80, screenBounds.size.height-28);
            backLabButton.center = CGPointMake(screenBounds.size.width-80, screenBounds.size.height-28);
            
            materialsButton.center = CGPointMake(80, 65);
            instrumentsButton.center = CGPointMake(80, 115);
            technologyButton.center = CGPointMake(screenBounds.size.width-80, 65);
            specialsButton.center = CGPointMake(screenBounds.size.width-80, 115);
        }
        else if ([GameSaveState sharedGameData].screenSize==3)
        {
            backHomeButton.center = CGPointMake(85, screenBounds.size.height-33);
            backLabButton.center = CGPointMake(screenBounds.size.width-85, screenBounds.size.height-33);
            
            materialsButton.center = CGPointMake(85, 70);
            instrumentsButton.center = CGPointMake(85, 125);
            technologyButton.center = CGPointMake(screenBounds.size.width-85, 70);
            specialsButton.center = CGPointMake(screenBounds.size.width-85, 125);
        }
    }
    
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
    
    [materiales addObject:@{@"Name": @"6 Sugar Cubes" , @"Info" : @"Works for 1 portion of Sugar Dust" , @"Price": @"95" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"1 Red Taffy" , @"Info" : @"Works for 1 portion of Taffy Dust" , @"Price": @"30" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"12 Sugar Cubes" , @"Info" : @"Works for 2 portions of Sugar Dust" , @"Price": @"170" , @"Unlocks":@"3"}];
    [materiales addObject:@{@"Name": @"2 Red Taffy" , @"Info" : @"Works for 2 portions of Taffy Dust" , @"Price": @"50" , @"Unlocks":@"3"}];
    [materiales addObject:@{@"Name": @"42 Sugar Cubes" , @"Info" : @"Works for 7 portions of Sugar Dust" , @"Price": @"560" , @"Unlocks":@"5"}];
    [materiales addObject:@{@"Name": @"7 Red Taffy" , @"Info" : @"Works for 7 portions of Taffy Dust" , @"Price": @"150" , @"Unlocks":@"5"}];
    
    [materiales2 addObject:@{@"Name": @"1 Licorice Stick" , @"Info" : @"Works for 1 portion of Red Bites" , @"Price": @"950" , @"Unlocks":@"12"}];
    [materiales2 addObject:@{@"Name": @"5 Licorice Sticks" , @"Info" : @"Works for 5 portions of Red Bites" , @"Price": @"4250" , @"Unlocks":@"16"}];
    
    [instruments addObject:@{@"Name": @"Crushing Speed 2" , @"Info" : @"Crush Sugar Cubes faster!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Scraping Speed 2" , @"Info" : @"Scrape Red Taffy faster!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Pot Size 2" , @"Info" : @"Chance of making 1 more batch of Soft Candy but increases cooking time." , @"Price": @"3500" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Storage Size 2" , @"Info" : @"Store 3 more Soft Candy so you are ready to cook any time!" , @"Price": @"3500" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Small Window" , @"Info" : @"Will help to eliminate kitchen heat faster!" , @"Price": @"15000" , @"Unlocks":@"7"}];
    
    [instruments2 addObject:@{@"Name": @"Cutting Speed 2" , @"Info" : @"Obtain Red Bites faster!" , @"Price": @"100000" , @"Unlocks":@"14"}];
    [instruments2 addObject:@{@"Name": @"Mixer Size 2" , @"Info" : @"Chance of making 1 more batch of Soft Candy but increases mixing time." , @"Price": @"300000" , @"Unlocks":@"15"}];
    [instruments2 addObject:@{@"Name": @"Upgraded Storage Size 5" , @"Info" : @"Store 3 more Soft Candy so you are ready to cook any time!!" , @"Price": @"80000" , @"Unlocks":@"13"}];
    [instruments2 addObject:@{@"Name": @"Small Window" , @"Info" : @"Will help to eliminate kitchen heat faster!" , @"Price": @"15000" , @"Unlocks":@"7"}];
    
    [technology addObject:@{@"Name": @"Better Candy Recipe" , @"Info" : @"Changes the kitchen for a faster, easier, cheaper way of making Soft Candy. (Needs Triangle Wallpaper!)" , @"Price": @"400000" , @"Unlocks":@"12"}];
    [technology addObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 2 Trays." , @"Price": @"900" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Lime Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"1000" , @"Unlocks":@"2"}];
    [technology addObject:@{@"Name": @"Brick Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    [technology addObject:@{@"Name": @"Sophia's Candy Cart" , @"Info" : @"Hire Sophia to sell your candy! View in Jobs." , @"Price": @"1200" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Bumper Sticker Ads" , @"Info" : @"Give out some bumper stickers to earn Xp! View in Jobs." , @"Price": @"3000" , @"Unlocks":@"2"}];
    [technology addObject:@{@"Name": @"Home Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"2000" , @"Unlocks":@"3"}];
    [technology addObject:@{@"Name": @"Host a kid's party!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"1500" , @"Unlocks":@"2"}];
    
    [specials addObject:@{@"Name": @"Free Money!" , @"Info" : @"Share with one of your friends and recieve $150!(Only available once every 20min of game time.)" , @"Price": @"Free!" , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"Bundle of cash!" , @"Info" : @"Find a bundle of 3,000 cash!" , @"Price": @"err." , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"Briefcase full of cash!" , @"Info" : @"Find a briefcase with 10,000 cash!" , @"Price": @"err." , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"Safe full of cash!" , @"Info" : @"Open a safe with 100,000 cash!" , @"Price": @"err." , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"Bed made of cash!" , @"Info" : @"Discover a bed made with 1,000,000 cash!" , @"Price": @"err." , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"5 Gold Bars!" , @"Info" : @"Buy 5 gold bars!" , @"Price": @"err." , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"20 Gold Bars!" , @"Info" : @"Buy 20 gold bars!" , @"Price": @"err." , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"40 Gold Bars!" , @"Info" : @"Buy 40 gold bars!" , @"Price": @"err." , @"Unlocks":@"1"}];
    [specials addObject:@{@"Name": @"Remove Banner Ads!" , @"Info" : @"Remove those annoying banner ads from the app!" , @"Price": @"err." , @"Unlocks":@"1"}];
    
    iconosMateriales = [NSArray arrayWithObjects:
                        @"6Sugar",
                        @"1RedFlavor",
                        @"12Sugar",
                        @"2RedFlavor",
                        @"24Sugar",
                        @"7RedFlavor",
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
        currentArray = specials;
    }
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    tutorialButton = [[UIImageView alloc] init];
    [tutorialButton setFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    tutorialButton.hidden=YES;
    [self.view addSubview:tutorialButton];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewShop"]!=YES) {
        [self manejoDelTutorial:2 aparecer:1];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]) {
        [self manejoDelTutorial:1 aparecer:0];
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"terminoTutorial"]!=YES) {
        table.scrollEnabled=NO;
        backHomeButton.enabled=NO;
        backLabButton.enabled=NO;
        materialsButton.enabled=NO;
        instrumentsButton.enabled=NO;
        technologyButton.enabled=NO;
        specialsButton.enabled=NO;
    }
}

- (void)manejoDelTutorial:(int)queParte aparecer:(int)si
{
    NSString *queIphone=@"4";
    if ([GameSaveState sharedGameData].screenSize==0)
    {
        queIphone =@"5";
    }
    else if ([GameSaveState sharedGameData].screenSize==2)
    {
        queIphone =@"6";
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        queIphone =@"6Plus";
    }
    
    tutorialButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"Iphone%@Tut%i",queIphone,queParte]];
    
    if (si==0) {
        tutorialButton.hidden=YES;
    }
    else if (si==1)
    {
        tutorialButton.hidden=NO;
    }
}

- (void)refreshInterfaceValues
{
    moneyLabel.text = [NSString stringWithFormat:@"Money: %li",(long)[GameSaveState sharedGameData].money];
    levelLabel.text = [NSString stringWithFormat:@"Level: %i",(int)[GameSaveState sharedGameData].level];
}

- (void)refreshAmountOfMaterials
{
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        amountOfMaterials.text = [NSString stringWithFormat:@"%i - %i",(int)[GameSaveState sharedGameData].pills/6,(int)[GameSaveState sharedGameData].matchbox];
    }
    else
    {
        amountOfMaterials.text = [NSString stringWithFormat:@"%i",(int)[GameSaveState sharedGameData].aluminum];
    }
}

-(void)animateAmountOfMaterials
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         amountOfMaterials.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              amountOfMaterials.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
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
    cell.nameLabel.font = [UIFont fontWithName:@"AllerDisplay" size:14];
    cell.infoLabel.font = [UIFont fontWithName:@"AllerDisplay" size:10];
    cell.buyButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    
    int whatLevel = 0;
    NSString *name = @"NULL";
    NSString *info  = @"NULL";
    NSString *price = @"NONE";
    NSDictionary *rowData = currentArray[indexPath.row];
    
    if (![currentArray isEqualToArray:specials]) {
        whatLevel = [rowData[@"Unlocks"] intValue];
        name = rowData[@"Name"];
        info = rowData[@"Info"];
        price = rowData[@"Price"];
    }
    else if ([currentArray isEqualToArray:specials]&&indexPath.row==0)
    {
        whatLevel = [rowData[@"Unlocks"] intValue];
        name = rowData[@"Name"];
        info = rowData[@"Info"];
        price = rowData[@"Price"];
        
        if ([name isEqualToString:@"Free Money!"]&&[[NSUserDefaults standardUserDefaults]integerForKey:@"shareAvailable"]==1) {
            price=@"-";
        }
    }
    else if ([currentArray isEqualToArray:specials]&&indexPath.row>0)
    {
        whatLevel = [rowData[@"Unlocks"] intValue];
        name = rowData[@"Name"];
        
        if ([GameSaveState sharedGameData].loadedProducts==0) {
            info = @"Unavailable. Check your internet connectivity.";
            price = @"-";
        }
        else if (![[RMStore defaultStore] canMakePayments]) {
            info = @"In App purchases are locked on this device.";
            price = @"-";
        }
        else if([GameSaveState sharedGameData].loadedProducts==1&&[[RMStore defaultStore]canMakePayments])
        {
            info = rowData[@"Info"];
            if ([name isEqualToString:@"Remove Banner Ads!"]&&productPurchased==NO) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.removebanners"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
            else if ([name isEqualToString:@"Remove Banner Ads!"]&&productPurchased==YES) {
                price = @"-";
            }
            else if ([name isEqualToString:@"Bundle of cash!"]) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.1000cash"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
            else if ([name isEqualToString:@"Briefcase full of cash!"]) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.10000cash"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
            else if ([name isEqualToString:@"Safe full of cash!"]) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.100000cash"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
            else if ([name isEqualToString:@"Bed made of cash!"]) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.1000000cash"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
            else if ([name isEqualToString:@"5 Gold Bars!"]) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.5tickets"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
            else if ([name isEqualToString:@"20 Gold Bars!"]) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.20tickets"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
            else if ([name isEqualToString:@"40 Gold Bars!"]) {
                SKProduct *banner = [[RMStore defaultStore]productForIdentifier:@"anthonypotdevin.crystalblue.40tickets"];
                price = [[RMStore defaultStore] localizedPriceOfProduct:banner];
            }
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
    
    if ([name isEqualToString:@"Better Candy Recipe"]&&[GameSaveState sharedGameData].currentLabBackground<=6)
    {
        [cell.buyButton setTitle:@"Locked" forState:UIControlStateNormal];
    }
    if ([name isEqualToString:@"MAXED OUT"]) {
        [cell.buyButton setTitle:@"-" forState:UIControlStateNormal];
    }
    
    cell.nameLabel.text = name;
    
    if (whatLevel>[GameSaveState sharedGameData].level)
    {
        cell.infoLabel.text = @"Earn more xp to use this item!";
    }
    else
    {
        cell.infoLabel.text = info;
    }
    
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
            if ([GameSaveState sharedGameData].currentExtractor==4) {
                cualExtractor = @"Extractor4Icon";
            }
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
            if ([GameSaveState sharedGameData].currentExtractor==4) {
                cualExtractor = @"Extractor4Icon";
            }
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
                cell.cellImage.image = [UIImage imageNamed:@"flavor9"];
            }
            else
            {
                NSString *cualCrystal = [NSString stringWithFormat:@"flavor%i",(int)[GameSaveState sharedGameData].currentCrystalColor];
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
                NSString *cualSeller = [NSString stringWithFormat:@"candycart%i",(int)[GameSaveState sharedGameData].currentSeller];
                cell.cellImage.image = [UIImage imageNamed:cualSeller];
            }
            else
            {
                cell.cellImage.image = [UIImage imageNamed:@"candycart9"];
            }
        }
        else if (indexPath.row==5) {
            if ([GameSaveState sharedGameData].currentBully<10) {
                NSString *cualBully = [NSString stringWithFormat:@"ads%i",(int)[GameSaveState sharedGameData].currentBully];
                cell.cellImage.image = [UIImage imageNamed:cualBully];
            }
            else
            {
                cell.cellImage.image = [UIImage imageNamed:@"ads9"];
            }
        }
        else if (indexPath.row==6) {
            if ([GameSaveState sharedGameData].currentLawyer<10) {
                NSString *cualBully = [NSString stringWithFormat:@"%iInsurance",(int)[GameSaveState sharedGameData].currentLawyer+1];
                cell.cellImage.image = [UIImage imageNamed:cualBully];
            }
            else
            {
                cell.cellImage.image = [UIImage imageNamed:@"10Insurance"];
            }
        }
        else if (indexPath.row==7) {
            if ([GameSaveState sharedGameData].currentSpy<10) {
                NSString *cualBully = [NSString stringWithFormat:@"event%i",(int)[GameSaveState sharedGameData].currentSpy+1];
                cell.cellImage.image = [UIImage imageNamed:cualBully];
            }
            else
            {
                cell.cellImage.image = [UIImage imageNamed:@"event10"];
            }
        }
    }
    else if ([currentArray isEqualToArray:specials])
    {
        if ([name isEqualToString:@"Free Money!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"FreeMoney"];
        }
        else if ([name isEqualToString:@"Bed made of cash!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"1,000,000Cash"];
        }
        else if ([name isEqualToString:@"Safe full of cash!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"100,000Cash"];
        }
        else if ([name isEqualToString:@"Briefcase full of cash!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"10,000Cash"];
        }
        else if ([name isEqualToString:@"Bundle of cash!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"3,000Cash"];
        }
        else if ([name isEqualToString:@"20 Gold Bars!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"20GoldBars"];
        }
        else if ([name isEqualToString:@"40 Gold Bars!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"40GoldBars"];
        }
        else if ([name isEqualToString:@"5 Gold Bars!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"5GoldBars"];
        }
        else if ([name isEqualToString:@"Remove Banner Ads!"]) {
            cell.cellImage.image = [UIImage imageNamed:@"BlockAds"];
        }        
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
    
    if (![currentArray isEqualToArray:specials]) {
        NSDictionary *rowData = currentArray[sender.tag];
        price = [rowData[@"Price"] intValue];
        level = [rowData[@"Unlocks"] intValue];
        name = rowData[@"Name"];
    }
    else if ([currentArray isEqualToArray:specials]&&sender.tag==0)
    {
        NSDictionary *rowData = currentArray[sender.tag];
        price = [rowData[@"Price"] intValue];
        level = [rowData[@"Unlocks"] intValue];
        name = rowData[@"Name"];
    }
    
    if (price<=[GameSaveState sharedGameData].money&&level<=[GameSaveState sharedGameData].level)
    {
        if ([currentArray isEqualToArray:materiales])
        {
            if (![sender.currentTitle isEqualToString:@"Locked"]) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]==YES) {
                    [self changeMoney:-price];
                }
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
        else if ([currentArray isEqualToArray:specials])
        {
            if ([GameSaveState sharedGameData].loadedProducts==1) {
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
        int whichShare=0;
        NSInteger shareAvailable=[[NSUserDefaults standardUserDefaults]integerForKey:@"shareAvailable"];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]&&shareAvailable==0) {
            whichShare=1;
        }
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]&&whichShare!=1&&shareAvailable==0) {
            whichShare=2;
        }
        
        /*NSString *text = @"Can you become the sweetest candy maker in town? Try it out in this awesome new game on the iOS App Store! \n\nCandy Guru!";
        UIImage *image = [UIImage imageNamed:@"Icon-Small"];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[text, image]applicationActivities:nil];
        controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                             UIActivityTypeMessage,
                                             UIActivityTypeMail,
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
                 [self animateMoneyChange:150];
                 [self refreshInterfaceValues];
                 NSLog(@"share completed");
             }
             else
             {
                 NSLog(@"share not completed");
             }
         }];*/
        
        if (whichShare==1) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:@"Can you become the sweetest candy maker in town? Try it out in CANDY GURU! An awesome new game on the iOS App Store!\n\n"];
            [mySLComposerSheet addImage:[UIImage imageNamed:@"IconLarge"]];
            [mySLComposerSheet addURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/candy-guru/id910024025?mt=8"]];
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        [[GameSaveState sharedGameData] changeMoney:150];
                        [self animateMoneyChange:150];
                        [self refreshInterfaceValues];
                        NSInteger cuantosShares = [[NSUserDefaults standardUserDefaults] integerForKey:@"cs12"];
                        cuantosShares++;
                        [[NSUserDefaults standardUserDefaults]setInteger:cuantosShares forKey:@"cs12"];
                        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"shareAvailable"];
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        else if (whichShare==2) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [mySLComposerSheet setInitialText:@"Become the best candy maker in CANDY GURU for iOS!"];
            [mySLComposerSheet addImage:[UIImage imageNamed:@"IconLarge"]];
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        [[GameSaveState sharedGameData] changeMoney:150];
                        [self animateMoneyChange:150];
                        [self refreshInterfaceValues];
                        NSInteger cuantosShares = [[NSUserDefaults standardUserDefaults] integerForKey:@"cs12"];
                        cuantosShares++;
                        [[NSUserDefaults standardUserDefaults]setInteger:cuantosShares forKey:@"cs12"];
                        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"shareAvailable"];
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([[RMStore defaultStore] canMakePayments])
    {
        NSDictionary *rowData = currentArray[whichRow];
        NSString *name = rowData[@"Name"];
        NSString *productID = @"NULL";
        
        if ([name isEqualToString:@"Remove Banner Ads!"]&&productPurchased==NO) {
            productID=@"anthonypotdevin.crystalblue.removebanners";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
        else if ([name isEqualToString:@"Bundle of cash!"]) {
            productID=@"anthonypotdevin.crystalblue.1000cash";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                    [self animateMoneyChange:3000];
                    [self refreshInterfaceValues];
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
        else if ([name isEqualToString:@"Briefcase full of cash!"]) {
            productID=@"anthonypotdevin.crystalblue.10000cash";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                    [self animateMoneyChange:10000];
                    [self refreshInterfaceValues];
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
        else if ([name isEqualToString:@"Safe full of cash!"]) {
            productID=@"anthonypotdevin.crystalblue.100000cash";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                    [self animateMoneyChange:100000];
                    [self refreshInterfaceValues];
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
        else if ([name isEqualToString:@"Bed made of cash!"]) {
            productID=@"anthonypotdevin.crystalblue.1000000cash";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                    [self animateMoneyChange:1000000];
                    [self refreshInterfaceValues];
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
        else if ([name isEqualToString:@"5 Gold Bars!"]) {
            productID=@"anthonypotdevin.crystalblue.5tickets";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                    [self animateMoneyChange:5];
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
        else if ([name isEqualToString:@"20 Gold Bars!"]) {
            productID=@"anthonypotdevin.crystalblue.20tickets";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                    [self animateMoneyChange:20];
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
        else if ([name isEqualToString:@"40 Gold Bars!"]) {
            productID=@"anthonypotdevin.crystalblue.40tickets";
            
            [PFPurchase buyProduct:productID block:^(NSError *error) {
                if (!error) {
                    NSLog(@"Product purchased %@",productID);
                    [self animateMoneyChange:40];
                }
                else
                {
                    NSLog(@"Something went wrong %@",productID);
                    [GameSaveState sharedGameData].loadedProducts=0;
                    [table reloadData];
                }
                NSLog(@"No ha validado");
            }];
            
        }
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
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"terminoTutorial"]==YES) {
            [GameSaveState sharedGameData].pills+=6;
            [GameSaveState sharedGameData].totalPills+=6;
        }
        else
        {
            [[SoundHelper sharedSoundInstance] playSound:5];
            [self animateMoneyChange:-95];
        }
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ComproSugar"]!=YES) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ComproSugar"];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ComproSugar"]==YES&&[[NSUserDefaults standardUserDefaults] boolForKey:@"ComproTaffy"]==YES) {
                [self manejoDelTutorial:3 aparecer:1];
                backLabButton.enabled=YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewShop"];
            }
        }
    }
    else if (whichRow==1)
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"terminoTutorial"]==YES) {
            [GameSaveState sharedGameData].matchbox+=1;
            [GameSaveState sharedGameData].totalMatchboxes+=1;
        }
        else
        {
            [[SoundHelper sharedSoundInstance] playSound:5];
            [self animateMoneyChange:-30];
        }
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ComproTaffy"]!=YES) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ComproTaffy"];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ComproSugar"]==YES&&[[NSUserDefaults standardUserDefaults] boolForKey:@"ComproTaffy"]==YES) {
                [self manejoDelTutorial:3 aparecer:1];
                backLabButton.enabled=YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewShop"];
            }
        }
    }
    else if (whichRow==2)
    {
        [GameSaveState sharedGameData].pills+=12;
        [GameSaveState sharedGameData].totalPills+=12;
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
    }
    else if (whichRow==3)
    {
        [GameSaveState sharedGameData].matchbox+=2;
        [GameSaveState sharedGameData].totalMatchboxes+=2;
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
    }
    else if (whichRow==4)
    {
        [GameSaveState sharedGameData].pills+=42;
        [GameSaveState sharedGameData].totalPills+=42;
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
    }
    else if (whichRow==5)
    {
        [GameSaveState sharedGameData].matchbox+=7;
        [GameSaveState sharedGameData].totalMatchboxes+=7;
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
    }
}

- (void)updateMaterial2Quantity:(int)whichRow
{
    if (whichRow==0)
    {
        [GameSaveState sharedGameData].aluminum+=1;
        [GameSaveState sharedGameData].totalAluminum+=1;
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
    }
    else if (whichRow==1)
    {
        [GameSaveState sharedGameData].aluminum+=5;
        [GameSaveState sharedGameData].totalAluminum+=5;
        
        [self refreshAmountOfMaterials];
        [self animateAmountOfMaterials];
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
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Wave Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive!" , @"Price": @"7000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==3) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Dots Wallpaper" , @"Info" : @"Will increase your candy sweetness purity and make it more expensive! Kitchen heat will affect you!" , @"Price": @"12000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==4) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Edgy Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Kitchen heat will affect you!" , @"Price": @"20000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==5) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Tile Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Kitchen heat will affect you!" , @"Price": @"40000" , @"Unlocks":@"11"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==6) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Triangle Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Kitchen heat will affect you!" , @"Price": @"55000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==7) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Circle Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Kitchen heat will affect you!" , @"Price": @"110000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==8) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Swirl Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Kitchen heat will affect you!" , @"Price": @"150000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==9) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Designers Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Kitchen heat will affect you!" , @"Price": @"200000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentLabBackground==10) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"The Pro Wallpaper" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Kitchen heat will NOT affect you!" , @"Price": @"350000" , @"Unlocks":@"19"}];
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
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"Crushing Speed 3" , @"Info" : @"Crush Sugar Cubes faster!" , @"Price": @"8000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentGlass==3) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"Crushing Speed 4" , @"Info" : @"Crush Sugar Cubes faster!" , @"Price": @"25000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentGlass==4) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"5"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentBowl==2) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"Scraping Speed 3" , @"Info" : @"Scrape Red Taffy faster!" , @"Price": @"5000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentBowl==3) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"Scraping Speed 4" , @"Info" : @"Scrape Red Taffy faster!" , @"Price": @"15000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentBowl==4) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentPot==2) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"Pot Size 3" , @"Info" : @"Chance of making 1 more batch of Soft Candy but increases cooking time." , @"Price": @"11000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentPot==3) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"Pot Size 4" , @"Info" : @"Chance of making 1 more batch of Soft Candy but increases cooking time." , @"Price": @"50000" , @"Unlocks":@"11"}];
    }
    else if ([GameSaveState sharedGameData].currentPot==4) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentDecantor==2) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"Storage Size 3" , @"Info" : @"Store 3 more Soft Candy so you are ready to cook any time!" , @"Price": @"10000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentDecantor==3) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"Storage Size 4" , @"Info" : @"Store 3 more Soft Candy so you are ready to cook any time!" , @"Price": @"22000" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentDecantor==4) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentExtractor==2) {
        [cualInstruments replaceObjectAtIndex:cualExtractor withObject:@{@"Name": @"Big Window" , @"Info" : @"Will help to eliminate kitchen heat faster!" , @"Price": @"50000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentExtractor==3) {
        [cualInstruments replaceObjectAtIndex:cualExtractor withObject:@{@"Name": @"Huge Window" , @"Info" : @"Will help to eliminate kitchen heat faster!" , @"Price": @"140000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentExtractor==4) {
        [cualInstruments replaceObjectAtIndex:cualExtractor withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentBeaker==2) {
        [instruments2 replaceObjectAtIndex:0 withObject:@{@"Name": @"Cutting Speed 3" , @"Info" : @"Obtain Red Bites faster!" , @"Price": @"200000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentBeaker==3) {
        [instruments2 replaceObjectAtIndex:0 withObject:@{@"Name": @"Cutting Speed 4" , @"Info" : @"Obtain Red Bites faster!" , @"Price": @"310000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentBeaker==4) {
        [instruments2 replaceObjectAtIndex:0 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentMixer==2) {
        [instruments2 replaceObjectAtIndex:1 withObject:@{@"Name": @"Mixer Size 3" , @"Info" : @"Chance of making 1 more batch of Soft Candy but increases mixing time." , @"Price": @"400000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentMixer==3) {
        [instruments2 replaceObjectAtIndex:1 withObject:@{@"Name": @"Mixer Size 4" , @"Info" : @"Chance of making 1 more batch of Soft Candy but increases mixing time." , @"Price": @"550000" , @"Unlocks":@"18"}];
    }
    else if ([GameSaveState sharedGameData].currentMixer==4) {
        [instruments2 replaceObjectAtIndex:1 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentDistilator==2) {
        [instruments2 replaceObjectAtIndex:2 withObject:@{@"Name": @"Upgraded Storage Size 6" , @"Info" : @"Store 3 more Soft Candy so you are ready to cook any time!!" , @"Price": @"140000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentDistilator==3) {
        [instruments2 replaceObjectAtIndex:2 withObject:@{@"Name": @"Upgraded Storage Size 7" , @"Info" : @"Store 3 more Soft Candy so you are ready to cook any time!!" , @"Price": @"190000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentDistilator==4) {
        [instruments2 replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentCrystalColor==2) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Blueberry Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"3000" , @"Unlocks":@"3"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==3) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Peach Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"10000" , @"Unlocks":@"4"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==4) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Lemon Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"32000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==5) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Strawberry Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"80000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==6) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Orange Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"220000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==7) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Watermelon Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"390000" , @"Unlocks":@"8"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==8) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Cherry Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"750000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==9) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Blue Rasberry Candy Flavor" , @"Info" : @"Will increase your candy sweetness and make it more expensive! Increases Cooking Time." , @"Price": @"1490000" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentCrystalColor==10) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1990000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentSeller==1)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Jack's Candy Cart" , @"Info" : @"Hire Jack to sell your candy! View in Jobs." , @"Price": @"2400" , @"Unlocks":@"3"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==2)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Lukas's Candy Cart" , @"Info" : @"Hire Lukas to sell your candy! View in Jobs." , @"Price": @"6000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==3)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Lily's Candy Cart" , @"Info" : @"Hire Lily to sell your candy! View in Jobs." , @"Price": @"15000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==4)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Noah's Candy Cart" , @"Info" : @"Hire Noah to sell your candy! View in Jobs." , @"Price": @"21000" , @"Unlocks":@"8"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==5)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Chloe's Candy Cart" , @"Info" : @"Hire Chloe to sell your candy! View in Jobs." , @"Price": @"50000" , @"Unlocks":@"11"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==6)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Julia's Candy Cart" , @"Info" : @"Hire Julia to sell your candy! View in Jobs." , @"Price": @"130000" , @"Unlocks":@"13"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==7)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Pedro's Candy Cart" , @"Info" : @"Hire Pedro to sell your candy! View in Jobs." , @"Price": @"170000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==8)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Dan's Candy Cart" , @"Info" : @"Hire Dan to sell your candy! View in Jobs." , @"Price": @"240000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==9)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Ana's Candy Cart" , @"Info" : @"Hire Ana to sell your candy! View in Jobs." , @"Price": @"300000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentSeller==10)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentBully==1) {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"T-Shirt Ads" , @"Info" : @"Give out t-shirts to earn Xp! View in Jobs." , @"Price": @"5000" , @"Unlocks":@"4"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==2)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Flyers" , @"Info" : @"Give out some flyers to earn Xp! View in Jobs." , @"Price": @"9000" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==3)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Magazine Ad" , @"Info" : @"Place a magazine ad to earn Xp! View in Jobs." , @"Price": @"16000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==4)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Street Banner" , @"Info" : @"Place a street banner to earn Xp! View in Jobs." , @"Price": @"7500" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==5)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Highway Banner" , @"Info" : @"Place a street banner to earn Xp! View in Jobs." , @"Price": @"50000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==6)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Newspaper Ad" , @"Info" : @"Place a newspaper ad to earn Xp! View in Jobs." , @"Price": @"150000" , @"Unlocks":@"13"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==7)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Internet Ad" , @"Info" : @"Place an internet ad to earn Xp! View in Jobs." , @"Price": @"200000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==8)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Radio Station Ad" , @"Info" : @"Hire a radio station to earn Xp! View in Jobs." , @"Price": @"300000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==9)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"TV Ad" , @"Info" : @"Place a TV ad to earn Xp! View in Jobs." , @"Price": @"400000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentBully==10)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentLawyer==1) {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Car Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"5000" , @"Unlocks":@"4"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==2)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Fire Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"5900" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==3)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Zombie Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"8500" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==4)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Pet Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"12000" , @"Unlocks":@"7"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==5)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Flood Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"14300" , @"Unlocks":@"10"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==6)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Health Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"42000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==7)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Work Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"120000" , @"Unlocks":@"13"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==8)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Candy Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"180000" , @"Unlocks":@"15"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==9)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Alien Abduction Insurance" , @"Info" : @"Reduces the cost when you have problems! (Also reduces chance of trouble)" , @"Price": @"240000" , @"Unlocks":@"17"}];
    }
    else if ([GameSaveState sharedGameData].currentLawyer==10)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if ([GameSaveState sharedGameData].currentSpy==1) {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a block party!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"1700" , @"Unlocks":@"3"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==2)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a garage sale!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"5000" , @"Unlocks":@"5"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==3)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a bake sale!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"8500" , @"Unlocks":@"6"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==4)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a carnival!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"15000" , @"Unlocks":@"8"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==5)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a Soccer Match!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"27000" , @"Unlocks":@"9"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==6)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a movie night!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"38000" , @"Unlocks":@"12"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==7)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a fancy diner!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"70000" , @"Unlocks":@"14"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==8)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a fundraiser!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"170000" , @"Unlocks":@"16"}];
    }
    else if ([GameSaveState sharedGameData].currentSpy==9)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Host a Concert!" , @"Info" : @"Will increase your candy love and the amount of customer arrivals!" , @"Price": @"220000" , @"Unlocks":@"17"}];
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
    [[SoundHelper sharedSoundInstance] playSound:9];
    levelLabel.font = [UIFont fontWithName:@"AllerDisplay" size:22];
    levelLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [self performSelector:@selector(reverseAnimationLevel) withObject:nil afterDelay:0.5];
}

- (void)reverseAnimationLevel
{
    levelLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    levelLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

//-------------------------------------------------------------------------------
//animation money label
//-------------------------------------------------------------------------------
- (void)animateNeededMoney
{
    [[SoundHelper sharedSoundInstance] playSound:9];
    moneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:22];
    moneyLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [self performSelector:@selector(reverseAnimationMoney) withObject:nil afterDelay:0.5];
}

- (void)reverseAnimationMoney
{
    moneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    moneyLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}
//-------------------------------------------------------------------------------

- (void)animateMoneyChange:(int)cuanto
{
    CGSize screenbounds = [[UIScreen mainScreen] bounds].size;
    int randomX = (screenbounds.width/2-100)+arc4random_uniform(200);
    //int randomX = arc4random()%230+50;
    int randomY = arc4random()%50+350;
    
    int cuantoChanged = abs(cuanto);
    
    NSString *animationText;
    if (cuantoChanged>=1000) {
        float cuantoDividido = (float)cuanto/1000;
        animationText = [NSString stringWithFormat:@"%1.1fk",cuantoDividido];
    }
    if (cuantoChanged>=1000000)
    {
        float cuantoDividido = (float)cuanto/1000000;
        animationText = [NSString stringWithFormat:@"%1.1fm",cuantoDividido];
    }
    if (cuantoChanged<1000)
    {
        animationText = [NSString stringWithFormat:@"%i",cuanto];
    }
    
    animationMoneyLabel.font = [UIFont fontWithName:@"AllerDisplay" size:35];
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
    
    [[SoundHelper sharedSoundInstance] playSound:5];
    [self animateMoneyChange:cuanto];
    
    [self refreshInterfaceValues];
}

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
    currentArray = specials;
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
    [[BannerHelper sharedAd].bannerView removeFromSuperview];
    [self performSegueWithIdentifier:@"exitShopToHome" sender:self];
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
    [super viewWillDisappear:animated];
}

@end
