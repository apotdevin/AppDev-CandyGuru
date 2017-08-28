//
//  GameSaveState.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/20/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "GameSaveState.h"
#import "FacebookSDK/FacebookSDK.h"

@implementation GameSaveState

+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)newGame
{
    _xp = 0;
    _level = 1;
    _purity = 1000;
    _money = 1200;
    _crystal = 0;
    _pills = 6;
    _matchbox = 1;
    _aluminum = 1;
    _whitePowder = 0;
    _redPowder = 0;
    _greyPowder = 0;
    _liquidCrystal = 0;
    _currentFreezers = 1;
    _tickets = 8;
    
    _currentSeller = 0;
    _currentBully = 0;
    _currentLawyer = 0;
    _currentSpy = 0;
    
    _totalCustomersAttended = 0;
    _totalCustomersIgnored = 0;
    _totalCustomersNotAttended = 0;
    _totalCrystalSold = 0;
    _totalCrystalMade = 0;
    _totalLiquidCrystal = 0;
    _totalRedPowder = 0;
    _totalWhitePowder = 0;
    _totalGreyPowder = 0;
    _totalPills = 0;
    _totalMatchboxes = 0;
    _totalAluminum = 0;
    _totalXpGained = 0;
    _totalMoneyMade = 0;
    _totalTime = 0;
    
    _currentLabBackground = 1;
    _currentLabSetting = 1;
    _currentGlass = 1;
    _currentBowl = 1;
    _currentPot = 1;
    _currentDecantor = 1;
    _currentExtractor = 1;
    _currentBeaker = 1;
    _currentMixer = 1;
    _currentDistilator = 1;
    _currentCrystalColor = 1;
    
    _potActive = 0;
    _potDate = CACurrentMediaTime();
    _pastDate = CACurrentMediaTime();
    
    _removeBanners = 946;
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight==480)
    {
        _screenSize = 1;
        NSLog(@"iphone 4");
    }
    else if(screenHeight==568)
    {
        _screenSize = 0;
        NSLog(@"iphone 5");
    }
    else if(screenHeight==667)
    {
        _screenSize = 2;
        NSLog(@"iphone 6");
    }
    else if(screenHeight==736)
    {
        _screenSize = 3;
        NSLog(@"iphone 6 plus");
    }
    
    _currentShopList = 0;
    _changeDanger = 0;
    _showCustomerHome = 0;
    _whichCustomerToShow = 0;
    _loadedProducts = 0;
    _scrollToTheLeftLab = 0;
}

- (void)loadGame
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL valid = NO;
    _xp = [[defaults secureObjectForKey:@"101" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState xp");
        _xp = 0;
    }
    
    valid = NO;
    _level = [[defaults secureObjectForKey:@"102" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState level");
        _level = 1;
    }
    
    valid = NO;
    _purity = [[defaults secureObjectForKey:@"103" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState purity");
        _purity = 1000;
    }
    
    valid = NO;
    _money = [[defaults secureObjectForKey:@"104" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState money");
        _money = 1200;
    }
    
    valid = NO;
    _crystal = [[defaults secureObjectForKey:@"105" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState crystal");
        _crystal = 0;
    }
    
    valid = NO;
    _pills = [[defaults secureObjectForKey:@"106" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState pills");
        _pills = 6;
    }
    
    valid = NO;
    _matchbox = [[defaults secureObjectForKey:@"107" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState matchbox");
        _matchbox = 1;
    }
    
    valid = NO;
    _aluminum = [[defaults secureObjectForKey:@"108" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState aluminum");
        _aluminum = 1;
    }
    
    valid = NO;
    _whitePowder = [[defaults secureObjectForKey:@"109" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState whitepowder");
        _whitePowder = 0;
    }
    
    valid = NO;
    _redPowder = [[defaults secureObjectForKey:@"110" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState redpowder");
        _redPowder = 0;
    }
    
    valid = NO;
    _greyPowder = [[defaults secureObjectForKey:@"111" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState greypowder");
        _greyPowder = 0;
    }
    
    valid = NO;
    _liquidCrystal = [[defaults secureObjectForKey:@"112" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState liquidCrystal");
        _liquidCrystal = 0;
    }
    
    valid = NO;
    _currentFreezers = [[defaults secureObjectForKey:@"113" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState currentFreezers");
        _currentFreezers = 1;
    }
    
    valid = NO;
    _tickets = [[defaults secureObjectForKey:@"114" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID GameSaveState tickets");
        _tickets = 0;
    }
    
    valid = NO;
    NSArray *gameSaveArray = [NSArray arrayWithArray:[defaults secureObjectForKey:@"gameSaveArray" valid:&valid]];
    if (!valid) {
        NSLog(@"INVALID GameSaveState");
        _currentSeller = 0;
        _currentBully = 0;
        _currentLawyer = 0;
        _currentSpy = 0;
        
        _totalCustomersAttended = 0;
        _totalCustomersIgnored = 0;
        _totalCustomersNotAttended = 0;
        _totalCrystalSold = 0;
        _totalCrystalMade = 0;
        _totalLiquidCrystal = 0;
        _totalRedPowder = 0;
        _totalWhitePowder = 0;
        _totalGreyPowder = 0;
        _totalPills = 0;
        _totalMatchboxes = 0;
        _totalAluminum = 0;
        _totalXpGained = 0;
        _totalMoneyMade = 0;
        _totalTime = 0;
        
        _currentLabBackground = 1;
        _currentLabSetting = 1;
        _currentGlass = 1;
        _currentBowl = 1;
        _currentPot = 1;
        _currentDecantor = 1;
        _currentExtractor = 1;
        _currentBeaker = 1;
        _currentMixer = 1;
        _currentDistilator = 1;
        _currentCrystalColor = 1;
        
        _potActive = 0;
        _potDate = CACurrentMediaTime();
        _pastDate = CACurrentMediaTime();
    }
    else
    {
        _currentSeller = [gameSaveArray[0] integerValue];
        _currentBully = [gameSaveArray[1] integerValue];
        _currentLawyer = [gameSaveArray[2] integerValue];
        _currentSpy = [gameSaveArray[3] integerValue];
        _totalCustomersAttended = [gameSaveArray[4] integerValue];
        _totalCustomersIgnored = [gameSaveArray[5] integerValue];
        _totalCustomersNotAttended = [gameSaveArray[6] integerValue];
        _totalCrystalSold = [gameSaveArray[7] integerValue];
        _totalCrystalMade = [gameSaveArray[8] integerValue];
        _totalLiquidCrystal = [gameSaveArray[9] integerValue];
        _totalRedPowder = [gameSaveArray[10] integerValue];
        _totalWhitePowder = [gameSaveArray[11] integerValue];
        _totalGreyPowder = [gameSaveArray[12] integerValue];
        _totalPills = [gameSaveArray[13] integerValue];
        _totalMatchboxes = [gameSaveArray[14] integerValue];
        _totalAluminum = [gameSaveArray[15] integerValue];
        _totalXpGained = [gameSaveArray[16] integerValue];
        _totalMoneyMade = [gameSaveArray[17] integerValue];
        _totalTime = [gameSaveArray[18] integerValue];
        _currentLabBackground = [gameSaveArray[19] integerValue];
        _currentLabSetting = [gameSaveArray[20] integerValue];
        _currentGlass = [gameSaveArray[21] integerValue];
        _currentBowl = [gameSaveArray[22] integerValue];
        _currentPot = [gameSaveArray[23] integerValue];
        _currentDecantor = [gameSaveArray[24] integerValue];
        _currentExtractor = [gameSaveArray[25] integerValue];
        _currentBeaker = [gameSaveArray[26] integerValue];
        _currentMixer = [gameSaveArray[27] integerValue];
        _currentDistilator = [gameSaveArray[28] integerValue];
        _currentCrystalColor = [gameSaveArray[29] integerValue];
        _potActive = [gameSaveArray[30]integerValue];
        if ([gameSaveArray[31] isKindOfClass:[NSNumber class]])
        {
            _potDate = [gameSaveArray[31] floatValue];
        }
        else
        {
            _potDate = CACurrentMediaTime();
        }
        if ([gameSaveArray[32] isKindOfClass:[NSNumber class]])

        {
            _pastDate = [gameSaveArray[32] floatValue];
        }
        else
        {
            _pastDate = CACurrentMediaTime();
        }
    }
    
    valid = NO;
    _removeBanners = [defaults secureIntegerForKey:@"Stats" valid:&valid];
    if (!valid) {
        NSLog(@"Invalid remove Banners");
        _removeBanners = 946;
    }
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight==480)
    {
        _screenSize = 1;
        NSLog(@"iphone 4");
    }
    else if(screenHeight==568)
    {
        _screenSize = 0;
        NSLog(@"iphone 5");
    }
    else if(screenHeight==667)
    {
        _screenSize = 2;
        NSLog(@"iphone 6");
    }
    else if(screenHeight==736)
    {
        _screenSize = 3;
        NSLog(@"iphone 6 plus");
    }
    
    _currentShopList = 0;
    _changeDanger = 0;
    _showCustomerHome = 0;
    _whichCustomerToShow = 0;
    _loadedProducts = 0;
    _scrollToTheLeftLab = 0;
}

- (void)saveGame
{
    NSArray *gameSaveArray = [NSArray arrayWithObjects:
                              [NSNumber numberWithInteger:_currentSeller],
                              [NSNumber numberWithInteger:_currentBully],
                              [NSNumber numberWithInteger:_currentLawyer],
                              [NSNumber numberWithInteger:_currentSpy],
                              [NSNumber numberWithInteger:_totalCustomersAttended],
                              [NSNumber numberWithInteger:_totalCustomersIgnored],
                              [NSNumber numberWithInteger:_totalCustomersNotAttended],
                              [NSNumber numberWithInteger:_totalCrystalSold],
                              [NSNumber numberWithInteger:_totalCrystalMade],
                              [NSNumber numberWithInteger:_totalLiquidCrystal],
                              [NSNumber numberWithInteger:_totalRedPowder],
                              [NSNumber numberWithInteger:_totalWhitePowder],
                              [NSNumber numberWithInteger:_totalGreyPowder],
                              [NSNumber numberWithInteger:_totalPills],
                              [NSNumber numberWithInteger:_totalMatchboxes],
                              [NSNumber numberWithInteger:_totalAluminum],
                              [NSNumber numberWithInteger:_totalXpGained],
                              [NSNumber numberWithInteger:_totalMoneyMade],
                              [NSNumber numberWithInteger:_totalTime],
                              [NSNumber numberWithInteger:_currentLabBackground],
                              [NSNumber numberWithInteger:_currentLabSetting],
                              [NSNumber numberWithInteger:_currentGlass],
                              [NSNumber numberWithInteger:_currentBowl],
                              [NSNumber numberWithInteger:_currentPot],
                              [NSNumber numberWithInteger:_currentDecantor],
                              [NSNumber numberWithInteger:_currentExtractor],
                              [NSNumber numberWithInteger:_currentBeaker],
                              [NSNumber numberWithInteger:_currentMixer],
                              [NSNumber numberWithInteger:_currentDistilator],
                              [NSNumber numberWithInteger:_currentCrystalColor],
                              [NSNumber numberWithInteger:_potActive],
                              [NSNumber numberWithFloat:_potDate],
                              [NSNumber numberWithFloat:_pastDate],
                              nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setSecureObject:[NSNumber numberWithInteger:_xp] forKey:@"101"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_level] forKey:@"102"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_purity] forKey:@"103"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_money] forKey:@"104"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_crystal] forKey:@"105"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_pills] forKey:@"106"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_matchbox] forKey:@"107"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_aluminum] forKey:@"108"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_whitePowder] forKey:@"109"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_redPowder] forKey:@"110"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_greyPowder] forKey:@"111"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_liquidCrystal] forKey:@"112"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_currentFreezers] forKey:@"113"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_tickets] forKey:@"114"];
    [defaults setSecureObject:gameSaveArray forKey:@"gameSaveArray"];
    [defaults setSecureInteger:_removeBanners forKey:@"Stats"];
    [defaults synchronize];
    NSLog(@"GameSaveState SAVED");
}

-(void)changeXp:(NSInteger)howMuch
{
    _xp = _xp + howMuch;
    [self checkLevel];
}

-(void)checkLevel
{
    NSArray *levelXp = [NSArray arrayWithObjects:
                @100,
                @300,
                @750,
                @1500,
                @2600,
                @4200,
                @6400,
                @9200,
                @13000,
                @17000,
                @22500,
                @29000,
                @36500,
                @45000,
                @55000,
                @66000,
                @79000,
                @94000,
                @110000,
                @130000,
                nil];
    NSInteger amountXpForLevel;
    if (_level<=20) {
        amountXpForLevel = [[levelXp objectAtIndex:_level-1]integerValue];
    }
    else if (_level>20)
    {
        amountXpForLevel = 155000+(5000+1000*(_level-21))*(_level-21);
    }
    if (_xp>=amountXpForLevel) {
        _level++;
        _xp = _xp - amountXpForLevel;
        [FBAppEvents logEvent:FBAppEventNameAchievedLevel
                   parameters:@{ FBAppEventParameterNameLevel    : [NSString stringWithFormat:@"%ld",(long)_level ]} ];
        [[GameCenterHelper sharedGC] checkLevelAchievements];
        if (_level<19) {
            NSInteger amountXpForNextLevel = [[levelXp objectAtIndex:_level]integerValue];
            if (_xp>=amountXpForNextLevel) {
                [self checkLevel];
            }
        }
    }
}

-(void)changeMoney:(NSInteger)howMuch
{
    if (_money+howMuch>=2000000000) {
        _money = 2000000000;
    }
    else
    {
        _money=_money+howMuch;
    }
}

-(void)changeTotalMoney:(NSInteger)howMuch
{
    if (_totalMoneyMade+howMuch>=2000000000) {
        _totalMoneyMade = 2000000000;
    }
    else
    {
        _totalMoneyMade+=howMuch;
    }
    [[GameCenterHelper sharedGC] earnMoneyAchievements];
}

-(void)changePurity:(NSInteger)howMuch
{
    if (_purity+howMuch>=10000) {
        _purity=10000;
    }
    else
    {
        _purity+=howMuch;
    }
    [[GameCenterHelper sharedGC] reachPurityAchievements];
}

@end