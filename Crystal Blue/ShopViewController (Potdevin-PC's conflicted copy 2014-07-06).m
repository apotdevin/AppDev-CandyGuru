//
//  ShopViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/8/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshInstrumentsFromDefaults];
    
    currentShopList = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentShopList"];
    
    currentLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentLevel"];
    currentMoney = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentMoney"];
    currentPills = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentPills"];
    currentMatchbox = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentMatchbox"];
    currentAluminum = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentAluminum"];
    
    //initialize interface labels
    moneyLabel.text = [NSString stringWithFormat:@"%i",currentMoney];
    levelLabel.text = [NSString stringWithFormat:@"%i",currentLevel];
    moneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    levelLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    materialsButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    instrumentsButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    technologyButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    specialsButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    
    //initialize arrays
    materiales = [[NSMutableArray alloc]init];
    instruments = [[NSMutableArray alloc]init];
    technology = [[NSMutableArray alloc]init];
    
    [materiales addObject:@{@"Name": @"6 Pills" , @"Info" : @"Works for 1 portion of White Powder" , @"Price": @"200" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"1 Matchbox" , @"Info" : @"Works for 1 portion of Red Powder" , @"Price": @"50" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"1 Aluminum Roll" , @"Info" : @"Works for 1 portion of Grey Powder" , @"Price": @"400" , @"Unlocks":@"13"}];
    [materiales addObject:@{@"Name": @"12 Pills" , @"Info" : @"Works for 2 portions of White Powder" , @"Price": @"380" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"2 Matchboxes" , @"Info" : @"Works for 2 portions of Red Powder" , @"Price": @"90" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"24 Pills" , @"Info" : @"Works for 4 portions of White Powder" , @"Price": @"750" , @"Unlocks":@"1"}];
    [materiales addObject:@{@"Name": @"7 Matchboxes" , @"Info" : @"Works for 7 portions of Red Powder" , @"Price": @"150" , @"Unlocks":@"10"}];
    [materiales addObject:@{@"Name": @"5 Aluminum Roll" , @"Info" : @"Works for 5 portions of Grey Powder" , @"Price": @"400" , @"Unlocks":@"13"}];
    
    [instruments addObject:@{@"Name": @"Crushing Speed 2" , @"Info" : @"Crush pills faster!" , @"Price": @"10" , @"Unlocks":@"1"}];
    [instruments addObject:@{@"Name": @"Scraping Speed 2" , @"Info" : @"Scrape a matchbox faster!" , @"Price": @"100" , @"Unlocks":@"2"}];
    [instruments addObject:@{@"Name": @"Pot Size 2" , @"Info" : @"Reduces cooking time and makes 1 more batch of liquid Crystal." , @"Price": @"100" , @"Unlocks":@"3"}];
    [instruments addObject:@{@"Name": @"Storage Size 2" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!" , @"Price": @"100" , @"Unlocks":@"4"}];
    [instruments addObject:@{@"Name": @"Beaker Size 2" , @"Info" : @"Obtain Grey Powder faster!" , @"Price": @"100" , @"Unlocks":@"5"}];
    [instruments addObject:@{@"Name": @"Mixer Size 2" , @"Info" : @"Reduces mixing time and produces 1 more batch of liquid Crystal." , @"Price": @"100" , @"Unlocks":@"6"}];
    [instruments addObject:@{@"Name": @"Upgraded Storage Size 5" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!!" , @"Price": @"100" , @"Unlocks":@"7"}];
    [instruments addObject:@{@"Name": @"Extractor Speed 2" , @"Info" : @"Will help to eliminate lab toxicity faster!" , @"Price": @"100" , @"Unlocks":@"8"}];
    
    [technology addObject:@{@"Name": @"Advanced Chemical Process" , @"Info" : @"Changes the lab setting for a faster, easier, cheaper way of obtaining liquid Crystal. (Needs Suburban House!)" , @"Price": @"100" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 2 Trays." , @"Price": @"100" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Grey Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"500" , @"Unlocks":@"7"}];
    [technology addObject:@{@"Name": @"Campsite Location" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    [technology addObject:@{@"Name": @"Seller 1" , @"Info" : @"Hire a dealer to expand your Crystal Empire! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Bully 1" , @"Info" : @"Hire a thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Lawyer 1" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"1"}];
    [technology addObject:@{@"Name": @"Spy 1" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"1"}];
    
    [self updateTableInfo];
    
    if (currentShopList==0) {
        currentArray = materiales;
    }
    else if (currentShopList==1) {
        currentArray = instruments;
    }
    else if (currentShopList==2) {
        currentArray = technology;
    }
    else {
        currentArray = materiales;
    }
}

- (void)refreshInstrumentsFromDefaults
{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    //initialize values
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentProgressColor"];
    tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    animationMoneyLabel.frame = CGRectMake(0, 0, 100, 100);
    animationMoneyLabel.textColor = tintColor;
    
    currentLabBackground = [standard integerForKey:@"currentLabBackground"];
    currentLabSetting = [standard integerForKey:@"currentLabSetting"];
    currentGlass = [standard integerForKey:@"currentGlass"];
    currentBowl = [standard integerForKey:@"currentBowl"];
    currentPot = [standard integerForKey:@"currentPot"];
    currentDecantor = [standard integerForKey:@"currentDecantor"];
    currentExtractor = [standard integerForKey:@"currentExtractor"];
    currentBeaker = [standard integerForKey:@"currentBeaker"];
    currentMixer = [standard integerForKey:@"currentMixer"];
    currentDistilator = [standard integerForKey:@"currentDistilator"];
    currentCrystalColor = [standard integerForKey:@"currentCrystalColor"];
    currentSeller = [standard integerForKey:@"currentSeller"];
    currentBully = [standard integerForKey:@"currentBully"];
    currentLawyer = [standard integerForKey:@"currentLawyer"];
    currentSpy = [standard integerForKey:@"currentSpy"];
    currentFreezers = [standard integerForKey:@"currentFreezers"];
}

- (void)refreshInterfaceValues
{
    moneyLabel.text = [NSString stringWithFormat:@"%i",currentMoney];
    levelLabel.text = [NSString stringWithFormat:@"%i",currentLevel];
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
    cell.buyButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
    cell.cellImage.image = [UIImage imageNamed:@"ProgressCircle"];
    cell.buyButton.tintColor = [UIColor colorWithWhite:1 alpha:1];
    
    NSDictionary *rowData = currentArray[indexPath.row];
    int whatLevel = [rowData[@"Unlocks"] intValue];
    NSString *name = rowData[@"Name"];
    NSString *info = rowData[@"Info"];
    
    if (whatLevel>currentLevel) {
        NSString *blocked = [NSString stringWithFormat:@"Level: %i",whatLevel];
        [cell.buyButton setTitle:blocked forState:UIControlStateNormal];
    }
    else
    {
        [cell.buyButton setTitle:rowData[@"Price"] forState:UIControlStateNormal];
    }
    
    if (currentLabSetting==1)
    {
        if ([name isEqualToString:@"1 Aluminum Roll"]||[name isEqualToString:@"5 Aluminum Roll"]||[info isEqualToString:@"Obtain Grey Powder faster!"]||[info isEqualToString:@"Reduces mixing time and produces 1 more batch of liquid Crystal."]||[info isEqualToString:@"Store 3 more liquid Crystal so you are ready to cook any time!!"])
        {
            [cell.buyButton setTitle:@"Locked" forState:UIControlStateNormal];
        }
    }
    else if (currentLabSetting==2)
    {
        if ([name isEqualToString:@"6 Pills"]||[name isEqualToString:@"1 Matchbox"]||[name isEqualToString:@"12 Pills"]||[name isEqualToString:@"2 Matchboxes"]||[name isEqualToString:@"24 Pills"]||[name isEqualToString:@"7 Matchboxes"]||[info isEqualToString:@"Crush pills faster!"]||[info isEqualToString:@"Scrape a matchbox faster!"]||[info isEqualToString:@"Reduces cooking time and makes 1 more batch of liquid Crystal."]||[info isEqualToString:@"Store 3 more liquid Crystal so you are ready to cook any time!"])
        {
            [cell.buyButton setTitle:@"Locked" forState:UIControlStateNormal];
        }
    }
    if ([name isEqualToString:@"Advanced Chemical Process"]&&currentLabBackground<=6)
    {
        [cell.buyButton setTitle:@"Locked" forState:UIControlStateNormal];
    }
    if ([name isEqualToString:@"MAXED OUT"]) {
        [cell.buyButton setTitle:@"-" forState:UIControlStateNormal];
    }
    
    cell.nameLabel.text = name;
    cell.infoLabel.text = info;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void) buttonPressed:(UIButton *)sender
{
    NSDictionary *rowData = currentArray[sender.tag];
    int price = [rowData[@"Price"] intValue];
    int level = [rowData[@"Unlocks"] intValue];
    NSString *name = [rowData objectForKey:@"Name"];
    
    if (price<=currentMoney&&level<=currentLevel)
    {
        if (currentArray==materiales)
        {
            if (![sender.currentTitle isEqualToString:@"Locked"]) {
                [self changeMoney:-price];
                [self updateMaterialQuantity:sender.tag];
            }
        }
        else if (currentArray==instruments)
        {
            if (![name isEqualToString:@"MAXED OUT"]&&![sender.currentTitle isEqualToString:@"Locked"])
            {
                [self changeMoney:-price];
                [self updateInstrumentLevel:sender.tag];
                [self refreshInstrumentsFromDefaults];
                [self updateTableInfo];
                [table reloadData];
            }
        }
        else if (currentArray==technology)
        {
            if (![name isEqualToString:@"MAXED OUT"]&&![sender.currentTitle isEqualToString:@"Locked"])
            {
                [self changeMoney:-price];
                [self updateTechnologyLevel:sender.tag];
                [self refreshInstrumentsFromDefaults];
                [self updateTableInfo];
                [table reloadData];
            }
        }
    }
    else if (level<=currentLevel)
    {
        [self animateNeededMoney];
    }
    else
    {
        [self animateNeededLevel];
    }
}

- (void)updateTechnologyLevel:(int)whichRow
{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    if (whichRow==0)
    {
        [self increaseSettingPurity];
        [standard setInteger:currentLabSetting+1 forKey:@"currentLabSetting"];
    }
    else if (whichRow==1)
    {
        [standard setInteger:currentFreezers+1 forKey:@"currentFreezers"];
    }
    else if (whichRow==2)
    {
        [self increasePurity:3.45];
        [standard setInteger:currentCrystalColor+1 forKey:@"currentCrystalColor"];
    }
    else if (whichRow==3)
    {
        [self increasePurity:2.7];
        [standard setInteger:currentLabBackground+1 forKey:@"currentLabBackground"];
    }
    else if (whichRow==4)
    {
        [standard setInteger:currentSeller+1 forKey:@"currentSeller"];
    }
    else if (whichRow==5)
    {
        [standard setInteger:currentBully+1 forKey:@"currentBully"];
    }
    else if (whichRow==6)
    {
        [standard setInteger:currentLawyer+1 forKey:@"currentLawyer"];
    }
    else if (whichRow==7)
    {
        [standard setInteger:currentSpy+1 forKey:@"currentSpy"];
    }
}

- (void)updateInstrumentLevel:(int)whichRow
{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    if (whichRow==0)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentGlass+1 forKey:@"currentGlass"];
    }
    else if (whichRow==1)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentBowl+1 forKey:@"currentBowl"];
    }
    else if (whichRow==2)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentPot+1 forKey:@"currentPot"];
    }
    else if (whichRow==3)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentDecantor+1 forKey:@"currentDecantor"];
    }
    else if (whichRow==4)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentBeaker+1 forKey:@"currentBeaker"];
    }
    else if (whichRow==5)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentMixer+1 forKey:@"currentMixer"];
    }
    else if (whichRow==6)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentDistilator+1 forKey:@"currentDistilator"];
    }
    else if (whichRow==7)
    {
        [self increasePurity:1.05];
        [standard setInteger:currentExtractor+1 forKey:@"currentExtractor"];
    }
    //[standard synchronize];
}

- (void)updateMaterialQuantity:(int)whichRow
{
    if (whichRow==0)
    {
        currentPills = currentPills + 6;
        [[NSUserDefaults standardUserDefaults] setInteger:currentPills forKey:@"currentPills"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalPills"]+6;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalPills"];
    }
    else if (whichRow==1)
    {
        currentMatchbox = currentMatchbox + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:currentMatchbox forKey:@"currentMatchbox"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalMatchboxes"]+1;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalMatchboxes"];
    }
    else if (whichRow==2)
    {
        currentAluminum = currentAluminum + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:currentAluminum forKey:@"currentAluminum"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalAluminum"]+1;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalAluminum"];
    }
    else if (whichRow==3)
    {
        currentPills = currentPills + 12;
        [[NSUserDefaults standardUserDefaults] setInteger:currentPills forKey:@"currentPills"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalPills"]+12;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalPills"];
    }
    else if (whichRow==4)
    {
        currentMatchbox = currentMatchbox + 2;
        [[NSUserDefaults standardUserDefaults] setInteger:currentMatchbox forKey:@"currentMatchbox"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalMatchboxes"]+2;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalMatchboxes"];
    }
    else if (whichRow==5)
    {
        currentPills = currentPills + 24;
        [[NSUserDefaults standardUserDefaults] setInteger:currentPills forKey:@"currentPills"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalPills"]+24;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalPills"];
    }
    else if (whichRow==6)
    {
        currentMatchbox = currentMatchbox + 7;
        [[NSUserDefaults standardUserDefaults] setInteger:currentMatchbox forKey:@"currentMatchbox"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalMatchboxes"]+7;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalMatchboxes"];
    }
    else if (whichRow==7)
    {
        currentAluminum = currentAluminum + 5;
        [[NSUserDefaults standardUserDefaults] setInteger:currentAluminum forKey:@"currentAluminum"];
        
        int total = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalAluminum"]+5;
        [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalAluminum"];
    }
    //[[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)updateTableInfo
{
    //--------------------------------------------------------------------------------------------------------
    if (currentFreezers==2)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 3 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==3)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 4 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==4)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 5 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==5)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 6 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==6)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 7 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==7)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 8 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==8)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 9 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==9)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 10 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==10)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 11 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==11)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 12 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==12)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 13 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==13)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 14 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==14)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 15 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==15)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 16 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==16)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 17 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==17)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"Extra Freezer Tray" , @"Info" : @"For a total of 18 Trays." , @"Price": @"1000" , @"Unlocks":@"1"}];
    }
    else if (currentFreezers==18)
    {
        [technology replaceObjectAtIndex:1 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentLabBackground==2) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Car Trunk" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"5"}];
    }
    else if (currentLabBackground==3) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Car Trailer" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLabBackground==4) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Motel Room" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"1000" , @"Unlocks":@"9"}];
    }
    else if (currentLabBackground==5) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Basement" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"1000" , @"Unlocks":@"11"}];
    }
    else if (currentLabBackground==6) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Suburban House" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"1000" , @"Unlocks":@"12"}];
    }
    else if (currentLabBackground==7) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"University Lab" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"1000" , @"Unlocks":@"14"}];
    }
    else if (currentLabBackground==8) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Abandoned Barn" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"1000" , @"Unlocks":@"16"}];
    }
    else if (currentLabBackground==9) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Warehouse" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will affect you!" , @"Price": @"1000" , @"Unlocks":@"17"}];
    }
    else if (currentLabBackground==10) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"Secret Laboratory" , @"Info" : @"Will increase your crystal purity and make it more expensive! Lab toxicity will NOT affect you!" , @"Price": @"1000" , @"Unlocks":@"19"}];
    }
    else if (currentLabBackground==11) {
        [technology replaceObjectAtIndex:3 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentLabSetting==2) {
        [technology replaceObjectAtIndex:0 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentGlass==2) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"Crushing Speed 3" , @"Info" : @"Crush pills faster!" , @"Price": @"1000" , @"Unlocks":@"3"}];
    }
    else if (currentGlass==3) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"Crushing Speed 4" , @"Info" : @"Crush pills faster!" , @"Price": @"1000" , @"Unlocks":@"4"}];
    }
    else if (currentGlass==4) {
        [instruments replaceObjectAtIndex:0 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"5"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentBowl==2) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"Scraping Speed 3" , @"Info" : @"Scrape matchboxes faster!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBowl==3) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"Scraping Speed 4" , @"Info" : @"Scrape matchboxes faster!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBowl==4) {
        [instruments replaceObjectAtIndex:1 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentPot==2) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"Pot Size 3" , @"Info" : @"Reduces cooking time and makes 1 more batch of liquid Crystal." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentPot==3) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"Pot Size 4" , @"Info" : @"Reduces cooking time and makes 1 more batch of liquid Crystal." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentPot==4) {
        [instruments replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentDecantor==2) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"Storage Size 3" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentDecantor==3) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"Storage Size 4" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentDecantor==4) {
        [instruments replaceObjectAtIndex:3 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentExtractor==2) {
        [instruments replaceObjectAtIndex:7 withObject:@{@"Name": @"Extractor Speed 3" , @"Info" : @"Will help to eliminate lab toxicity faster!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentExtractor==3) {
        [instruments replaceObjectAtIndex:7 withObject:@{@"Name": @"Extractor Speed 4" , @"Info" : @"Will help to eliminate lab toxicity faster!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentExtractor==4) {
        [instruments replaceObjectAtIndex:7 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentBeaker==2) {
        [instruments replaceObjectAtIndex:4 withObject:@{@"Name": @"Beaker 3" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBeaker==3) {
        [instruments replaceObjectAtIndex:4 withObject:@{@"Name": @"Beaker 4" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBeaker==4) {
        [instruments replaceObjectAtIndex:4 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentMixer==2) {
        [instruments replaceObjectAtIndex:5 withObject:@{@"Name": @"Mixer 3" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentMixer==3) {
        [instruments replaceObjectAtIndex:5 withObject:@{@"Name": @"Mixer 4" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentMixer==4) {
        [instruments replaceObjectAtIndex:5 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentDistilator==2) {
        [instruments replaceObjectAtIndex:6 withObject:@{@"Name": @"Upgraded Storage Size 6" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentDistilator==3) {
        [instruments replaceObjectAtIndex:6 withObject:@{@"Name": @"Upgraded Storage Size 7" , @"Info" : @"Store 3 more liquid Crystal so you are ready to cook any time!!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentDistilator==4) {
        [instruments replaceObjectAtIndex:6 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentCrystalColor==2) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Black Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"5"}];
    }
    else if (currentCrystalColor==3) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Green Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"6"}];
    }
    else if (currentCrystalColor==4) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Yellow Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"8"}];
    }
    else if (currentCrystalColor==5) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Purple Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"9"}];
    }
    else if (currentCrystalColor==6) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Red Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"11"}];
    }
    else if (currentCrystalColor==7) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"White Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"12"}];
    }
    else if (currentCrystalColor==8) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Blue Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"14"}];
    }
    else if (currentCrystalColor==9) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"Crystal Blue Crystal Color" , @"Info" : @"Will increase your crystal purity and make it more expensive!" , @"Price": @"1000" , @"Unlocks":@"15"}];
    }
    else if (currentCrystalColor==10) {
        [technology replaceObjectAtIndex:2 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentSeller==1)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 2" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==2)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 3" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==3)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 4" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==4)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 5" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==5)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 6" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==6)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 7" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==7)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 8" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==8)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 9" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==9)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"Seller 10" , @"Info" : @"Hire another dealer to expand your Crystal Empire faster! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSeller==10)
    {
        [technology replaceObjectAtIndex:4 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentBully==1) {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 2" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==2)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 3" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==3)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 4" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==4)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 5" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==5)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 6" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==6)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 7" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==7)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 8" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==8)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 9" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==9)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"Bully 10" , @"Info" : @"Hire another thug to spread your name and earn Xp! View in Contracts." , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentBully==10)
    {
        [technology replaceObjectAtIndex:5 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentLawyer==1) {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 2" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==2)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 3" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==3)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 4" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==4)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 5" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==5)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 6" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==6)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 7" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==7)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 8" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==8)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 9" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==9)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"Lawyer 10" , @"Info" : @"Reduces the trouble you get into when visited by cops, thieves and other troublemakers!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentLawyer==10)
    {
        [technology replaceObjectAtIndex:6 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    //--------------------------------------------------------------------------------------------------------
    if (currentSpy==1) {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 2" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==2)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 3" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==3)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 4" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==4)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 5" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==5)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 6" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==6)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 7" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==7)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 8" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==8)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 9" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==9)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"Spy 10" , @"Info" : @"Will reduce the danger of going to other places!" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
    else if (currentSpy==10)
    {
        [technology replaceObjectAtIndex:7 withObject:@{@"Name": @"MAXED OUT" , @"Info" : @"" , @"Price": @"1000" , @"Unlocks":@"7"}];
    }
}

//-------------------------------------------------------------------------------
//animation level label
//-------------------------------------------------------------------------------
- (void)animateNeededLevel
{
    levelLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    levelLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [self performSelector:@selector(reverseAnimationLevel) withObject:nil afterDelay:0.5];
}

- (void)reverseAnimationLevel
{
    levelLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    levelLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}

//-------------------------------------------------------------------------------
//animation money label
//-------------------------------------------------------------------------------
- (void)animateNeededMoney
{
    moneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    moneyLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    
    [self performSelector:@selector(reverseAnimationMoney) withObject:nil afterDelay:0.5];
}

- (void)reverseAnimationMoney
{
    moneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:14];
    moneyLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}
//-------------------------------------------------------------------------------

- (void)animateMoneyChange:(int)cuanto
{
    int randomX = arc4random()%230+50;
    int randomY = arc4random()%50+350;
    
    animationMoneyLabel.text = [NSString stringWithFormat:@"%i",cuanto];
    animationMoneyLabel.font = [UIFont fontWithName:@"28 Days Later" size:40];
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
    currentMoney = currentMoney + cuanto;
    
    [self sonidoMoney];
    [self animateMoneyChange:cuanto];
    
    [[NSUserDefaults standardUserDefaults] setInteger:currentMoney forKey:@"currentMoney"];
    //[[NSUserDefaults standardUserDefaults]synchronize];
    
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
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"currentShopList"];
    currentArray = materiales;
    [table reloadData];
}

- (IBAction)instrumentsButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"currentShopList"];
    currentArray = instruments;
    [table reloadData];
}

- (IBAction)specialsButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"currentShopList"];
    
    [table reloadData];
}

- (IBAction)technologyButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"currentShopList"];
    currentArray = technology;
    [table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)increaseSettingPurity
{
    float currentPurity = [[NSUserDefaults standardUserDefaults]floatForKey:@"currentPurity"];
    
    currentPurity = currentPurity - 1.05*currentGlass;
    currentPurity = currentPurity - 1.05*currentBowl;
    currentPurity = currentPurity - 1.05*currentPot;
    currentPurity = currentPurity - 1.05*currentDecantor;
    
    [[NSUserDefaults standardUserDefaults]setFloat:currentPurity forKey:@"currentPurity"];
    
    [self increasePurity:22.6];
}

- (void)increasePurity:(float)howMuch
{
    float currentPurity = [[NSUserDefaults standardUserDefaults]floatForKey:@"currentPurity"];
    
    if (currentPurity<99.9) {
        currentPurity=currentPurity+howMuch;
        [[NSUserDefaults standardUserDefaults]setFloat:currentPurity forKey:@"currentPurity"];
    }
    if (currentPurity>99.9) {
        [[NSUserDefaults standardUserDefaults]setFloat:99.9 forKey:@"currentPurity"];
    }
    
}









@end
