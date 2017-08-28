//
//  ScrollContractsViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/11/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "ScrollContractsViewController.h"
#import "ClientsAtHome.h"
#import "SoundHelper.h"

static int padding = 90;

@interface ScrollContractsViewController ()

@end

@implementation ScrollContractsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scroller.delegate=self;
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 950)];
    
    [self startTables];
    [self startInterface];

    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)startTables
{
    people = [[NSMutableArray alloc] init];
    nameLabelArray = [[NSMutableArray alloc] init];
    infoLabelArray = [[NSMutableArray alloc] init];
    locationButtonArray = [[NSMutableArray alloc] init];
    timerLabelArray = [[NSMutableArray alloc] init];
    startButtonArray = [[NSMutableArray alloc] init];
    imageViewArray = [[NSMutableArray alloc] init];
    collectButtonArray = [[NSMutableArray alloc] init];
    lockedLabelArray = [[NSMutableArray alloc] init];
    backgroundImageArray = [[NSMutableArray alloc] init];
    
    //Sellers
    [people addObject:@{@"Name": @"Sophia's Cart" , @"Info" : @"Sells 100 Candys" , @"Time" : @"5" , @"Need" : @"100" , @"Give" : @"100"}];
    [people addObject:@{@"Name": @"Jack's Cart" , @"Info" : @"Sells 150 Candys" , @"Time" : @"7" , @"Need" : @"150" , @"Give" : @"150"}];
    [people addObject:@{@"Name": @"Lukas's Cart" , @"Info" : @"Sells 200 Candys" , @"Time" : @"9" , @"Need" : @"200" , @"Give" : @"200"}];
    [people addObject:@{@"Name": @"Lily's Cart" , @"Info" : @"Sells 250 Candys" , @"Time" : @"11" , @"Need" : @"250" , @"Give" : @"250"}];
    [people addObject:@{@"Name": @"Noah's Cart" , @"Info" : @"Sells 300 Candys" , @"Time" : @"13" , @"Need" : @"300" , @"Give" : @"300"}];
    [people addObject:@{@"Name": @"Chloe's Cart" , @"Info" : @"Sells 350 Candys" , @"Time" : @"15" , @"Need" : @"350" , @"Give" : @"350"}];
    [people addObject:@{@"Name": @"Julia's Cart" , @"Info" : @"Sells 400 Candys" , @"Time" : @"17" , @"Need" : @"400" , @"Give" : @"400"}];
    [people addObject:@{@"Name": @"Pedro's Cart" , @"Info" : @"Sells 450 Candys" , @"Time" : @"20" , @"Need" : @"450" , @"Give" : @"450"}];
    [people addObject:@{@"Name": @"Dan's Cart" , @"Info" : @"Sells 500 Candys" , @"Time" : @"22" , @"Need" : @"500" , @"Give" : @"500"}];
    [people addObject:@{@"Name": @"Ana's Cart" , @"Info" : @"Sells 550 Candys" , @"Time" : @"25" , @"Need" : @"550" , @"Give" : @"550"}];
    //Bullys
    [people addObject:@{@"Name": @"Bumper Stickers" , @"Info" : @"800 for 50Xp" , @"Time" : @"5" , @"Need" : @"800" , @"Give" : @"50"}];
    [people addObject:@{@"Name": @"T-Shirts" , @"Info" : @"900 for 55Xp" , @"Time" : @"7" , @"Need" : @"900" , @"Give" : @"55"}];
    [people addObject:@{@"Name": @"Flyers" , @"Info" : @"1000 for 60Xp" , @"Time" : @"9" , @"Need" : @"1000" , @"Give" : @"60"}];
    [people addObject:@{@"Name": @"Magazines" , @"Info" : @"1100 for 65Xp" , @"Time" : @"11" , @"Need" : @"1100" , @"Give" : @"65"}];
    [people addObject:@{@"Name": @"Street Banners" , @"Info" : @"1200 for 70Xp" , @"Time" : @"13" , @"Need" : @"1200" , @"Give" : @"70"}];
    [people addObject:@{@"Name": @"Highway Banners" , @"Info" : @"1300 for 75Xp" , @"Time" : @"15" , @"Need" : @"1300" , @"Give" : @"75"}];
    [people addObject:@{@"Name": @"Newspaper" , @"Info" : @"1400 for 80Xp" , @"Time" : @"17" , @"Need" : @"1400" , @"Give" : @"80"}];
    [people addObject:@{@"Name": @"Internet" , @"Info" : @"1500 for 85Xp" , @"Time" : @"20" , @"Need" : @"1500" , @"Give" : @"85"}];
    [people addObject:@{@"Name": @"Radio Station" , @"Info" : @"1600 for 90Xp" , @"Time" : @"22" , @"Need" : @"1600" , @"Give" : @"90"}];
    [people addObject:@{@"Name": @"TV Ad" , @"Info" : @"1700 for 95Xp" , @"Time" : @"25" , @"Need" : @"1700" , @"Give" : @"95"}];
    
    for (int i = 0; i<20; i++) {
        UILabel *label = [[UILabel alloc] init];
        UILabel *info = [[UILabel alloc] init];
        UIButton *location = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UILabel *timer = [[UILabel alloc] init];
        UIButton *start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIImageView *image = [[UIImageView alloc]init];
        UIButton *collect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        UILabel *locked = [[UILabel alloc] init];
        locked.userInteractionEnabled = YES;
        locked.font = [UIFont fontWithName:@"AllerDisplay" size:34];
        locked.text = @"LOCKED!";
        locked.textColor = [UIColor whiteColor];
        locked.frame = CGRectMake(0, 0, 150, 80);
        locked.textAlignment = NSTextAlignmentCenter;
        
        UIImage *img = [UIImage imageNamed:@"ContractsWindow"];
        CGSize imgSize = locked.frame.size;
        
        UIGraphicsBeginImageContext( imgSize );
        [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        locked.backgroundColor = [UIColor colorWithPatternImage:newImage];
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
        background.image = [UIImage imageNamed:@"statsWindow"];
        
        [nameLabelArray addObject:label];
        [infoLabelArray addObject:info];
        [locationButtonArray addObject:location];
        [timerLabelArray addObject:timer];
        [startButtonArray addObject:start];
        [imageViewArray addObject:image];
        [collectButtonArray addObject:collect];
        [lockedLabelArray addObject:locked];
        [backgroundImageArray addObject:background];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewContracts"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewContracts"];
    }
    
    else
    {
        
    }
}

-(void)startInterface
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentProgressColor"];
    tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    animationLabel.textColor = tintColor;
    animationLabel.font = [UIFont fontWithName:@"AllerDisplay" size:26];
    animationLabel.shadowColor = [UIColor blackColor];
    animationLabel.shadowOffset = CGSizeMake(1, 1);
    
    sellers.font = [UIFont fontWithName:@"AllerDisplay" size:30];
    bullys.font = [UIFont fontWithName:@"AllerDisplay" size:30];
    //sellers.textColor = [UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1];
    //bullys.textColor = [UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1];
    money.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    crystal.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    backButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    //[backButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    money.text = [NSString stringWithFormat:@"Money: %li",(long)[GameSaveState sharedGameData].money];
    crystal.text = [NSString stringWithFormat:@"Candy: %li",(long)[GameSaveState sharedGameData].crystal];
    
    for (int i=0; i<20; i++) {
        
        int column = 0;
        int bully = 0;
        if (i>9) {column = 1;bully = i-10;}
        
        backgroundImage = backgroundImageArray[i];
        backgroundImage.center = CGPointMake(81+(160*column), 45+(padding*i)-((padding*(people.count/2))*column));
        [scroller addSubview:backgroundImage];
        
        NSDictionary *rowData = people[i];
        
        NSString *name = rowData[@"Name"];
        NSString *info = rowData[@"Info"];
        int time = [rowData[@"Time"] intValue];
        NSString *timeText = [self changeToHrMin:time];
        
        UILabel *nameLabel = nameLabelArray[i];
        nameLabel.frame = CGRectMake(10+(160*column), 5+(padding*i)-((padding*(people.count/2))*column), 150, 20);
        nameLabel.text = name;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
        [scroller addSubview:nameLabel];
        
        UILabel *infoLabel = infoLabelArray[i];
        infoLabel.frame = CGRectMake(4+(160*column), 20+(padding*i)-((padding*(people.count/2))*column), 160, 20);
        infoLabel.text = info;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.font = [UIFont fontWithName:@"AllerDisplay" size:12];
        [scroller addSubview:infoLabel];
        
        UIButton *locationButton = locationButtonArray[i];
        [locationButton setTag:i];
        [locationButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[ClientsAtHome sharedClientData].placeSentTo[i] isEqualToString:@"NONE"]) {
            [locationButton setTitle:[NSString stringWithFormat:@"Send to:"] forState:UIControlStateNormal];
        }
        else
        {
            NSString *cualSitio = [[ClientsAtHome sharedClientData].placeSentTo objectAtIndex:i];
            [locationButton setTitle:cualSitio forState:UIControlStateNormal];
        }
        locationButton.frame = CGRectMake(55+(160*column), 35+(padding*i)-((padding*(people.count/2))*column), 100, 30);
        locationButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
        [locationButton setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1] forState:UIControlStateNormal];
        [locationButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        locationButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [scroller addSubview:locationButton];
        
        UILabel *timerLabel = timerLabelArray[i];
        timerLabel.frame = CGRectMake(55+(160*column), 60+(padding*i)-((padding*(people.count/2))*column), 100, 20);
        timerLabel.text = timeText;
        timerLabel.font = [UIFont fontWithName:@"AllerDisplay" size:12];
        [scroller addSubview:timerLabel];
        
        UIButton *startButton = startButtonArray[i];
        [startButton setTag:i];
        [startButton addTarget:self action:@selector(buttonPressedStart:) forControlEvents:UIControlEventTouchUpInside];
        [startButton setTitle:[NSString stringWithFormat:@"Start"] forState:UIControlStateNormal];
        startButton.frame = CGRectMake(80+(160*column), 55+(padding*i)-((padding*(people.count/2))*column), 100, 30);
        startButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
        [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [startButton setTitleShadowColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
        startButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [scroller addSubview:startButton];
        
        if (![[ClientsAtHome sharedClientData].peopleOnOrOff[i] isEqualToString:@"NONE"]) {
            startButton.hidden = YES;
        }
        
        UIImageView *cellImage = imageViewArray[i];
        cellImage.frame = CGRectMake(5+(160*column), 40+(padding*i)-((padding*(people.count/2))*column), 40, 40);
        if (i<10) {
            cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"candycart%i",i]];
        }
        else
        {
            cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ads%i",i-10]];
        }
        [scroller addSubview:cellImage];
        
        UIButton *collectButton = collectButtonArray[i];
        [collectButton setTag:i];
        [collectButton addTarget:self action:@selector(buttonPressedCollect:) forControlEvents:UIControlEventTouchUpInside];
        [collectButton setTitle:[NSString stringWithFormat:@"Collect!"] forState:UIControlStateNormal];
        collectButton.frame = CGRectMake(50+(160*column), 55+(padding*i)-((padding*(people.count/2))*column), 100, 30);
        collectButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
        [collectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [collectButton setTitleShadowColor:[UIColor greenColor] forState:UIControlStateNormal];
        collectButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [scroller addSubview:collectButton];
        collectButton.hidden = YES;
        
        if ([[ClientsAtHome sharedClientData].peopleOnOrOff[i] isEqualToString:@"TERMINO"]) {
            timerLabel.hidden = YES;
            collectButton.hidden = NO;
        }
        
        if ([GameSaveState sharedGameData].currentSeller<=i&&column==0) {
            lockedLabel = lockedLabelArray[i];
            lockedLabel.center = CGPointMake(81+(160*column), 45+(padding*i)-((padding*(people.count/2))*column));
            [scroller addSubview:lockedLabel];
        }
        if ([GameSaveState sharedGameData].currentBully<=bully&&column==1) {
        lockedLabel = lockedLabelArray[i];
        lockedLabel.center = CGPointMake(81+(160*column), 45+(padding*i)-((padding*(people.count/2))*column));
        [scroller addSubview:lockedLabel];
        }
    }
    
    if ([GameSaveState sharedGameData].screenSize==1) {
        backButton.center = CGPointMake(160, 452);
    }
    
}

-(void)buttonPressedCollect:(UIButton *)sender
{
    int gives = 0;
    int cual = [self cualSitioEs:sender sumarONo:0];
    int dangerZone = [[ClientsAtHome sharedClientData].valoresDangerEnRegion[cual]intValue];
    
    NSDictionary *rowData = people[sender.tag];
    
    int randomValue = arc4random_uniform(101);
    
    if (randomValue>(100-dangerZone)) {
        if (sender.tag>9) {
            [self animateChange:100 cual:5];
        }
        else {
            [self animateChange:100 cual:3];
        }
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:5];
        [self cualSitioEs:sender sumarONo:1];
        gives = [rowData[@"Give"] intValue];
        if (sender.tag>9) {
            [[GameSaveState sharedGameData] changeXp:gives];
            [GameSaveState sharedGameData].totalXpGained+=gives;
            
            [self animateChange:gives cual:2];
            [self refreshInterfaceValues];
        }
        else
        {
            float purityDecimales = (float)[GameSaveState sharedGameData].purity/100;
            float precioRandom = arc4random_uniform((int)sender.tag)+purityDecimales;
            int cuanto = ceil(precioRandom)*gives;
            
            [GameSaveState sharedGameData].totalCrystalSold+=[rowData[@"Need"]intValue];
            [[GameSaveState sharedGameData] changeMoney:cuanto];
            [[GameSaveState sharedGameData] changeTotalMoney:cuanto];
            [[GameCenterHelper sharedGC] sellCrystalAchievements];
            
            [self animateChange:cuanto cual:1];
            [self refreshInterfaceValues];
        }
    }
    
    [[ClientsAtHome sharedClientData].peopleOnOrOff replaceObjectAtIndex:sender.tag withObject:@"NONE"];
    
    sender.hidden = YES;
    
    UILabel *tiempo = timerLabelArray[sender.tag];
    tiempo.hidden = NO;
    NSString *tiempoTotal = [self changeToHrMin:[rowData[@"Time"] intValue]];
    tiempo.text = tiempoTotal;
    tiempo.textAlignment = NSTextAlignmentLeft;
    tiempo.font = [UIFont fontWithName:@"AllerDisplay" size:12];
    
    UIButton *cualBoton = startButtonArray[sender.tag];
    cualBoton.hidden = NO;
    
    UIButton *sitioBoton = locationButtonArray[sender.tag];
    [[ClientsAtHome sharedClientData].placeSentTo replaceObjectAtIndex:sender.tag withObject:@"NONE"];
    [sitioBoton setTitle:[NSString stringWithFormat:@"Send to:"] forState:UIControlStateNormal];
}

-(void)buttonPressed:(UIButton *)sender
{
    if ([[[ClientsAtHome sharedClientData].peopleOnOrOff objectAtIndex:sender.tag] isEqualToString:@"NONE"])
    {
        [ClientsAtHome sharedClientData].contractsCustomerPressed=sender.tag;
        [[ClientsAtHome sharedClientData].placeSentTo replaceObjectAtIndex:sender.tag withObject:@"NONE"];
        
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        LocationSelectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LocationSelectionViewController"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)buttonPressedStart:(UIButton *)sender
{
    if (![[[ClientsAtHome sharedClientData].placeSentTo objectAtIndex:sender.tag] isEqualToString:@"NONE"])
    {
        int opcion = 0;
        NSDictionary *rowData = people[sender.tag];
        
        if (sender.tag>9) {
            
            int plataNecesitada = [rowData[@"Need"] intValue];
            if (plataNecesitada<=[GameSaveState sharedGameData].money) {
                opcion=1;
                sender.hidden = YES;
                
                [[GameSaveState sharedGameData] changeMoney:-plataNecesitada];
                
                [self refreshInterfaceValues];
                
                [self animateChange:-plataNecesitada cual:1];
            }
            else
            {
                [[SoundHelper sharedSoundInstance] playSound:9];
                money.font = [UIFont fontWithName:@"AllerDisplay" size:18];
                money.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
                [self performSelector:@selector(reverseAnimationMoneyNeeded:) withObject:sender afterDelay:0.5];
            }
        }
        else
        {
            int crystalNecesitado = [rowData[@"Need"]intValue];
            if (crystalNecesitado<=[GameSaveState sharedGameData].crystal) {
                opcion=1;
                sender.hidden = YES;
                
                [GameSaveState sharedGameData].crystal-=crystalNecesitado;
                
                [self refreshInterfaceValues];
                
                [self animateChange:-crystalNecesitado cual:4];
            }
            else
            {
                [[SoundHelper sharedSoundInstance] playSound:9];
                crystal.font = [UIFont fontWithName:@"AllerDisplay" size:18];
                crystal.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
                [self performSelector:@selector(reverseAnimationCrystalNeeded:) withObject:sender afterDelay:0.5];
            }
        }
        
        if (opcion==1) {
            [[ClientsAtHome sharedClientData].peopleOnOrOff replaceObjectAtIndex:sender.tag withObject:@"EMPEZO"];
            [[ClientsAtHome sharedClientData].peopleStartDate replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithFloat:CACurrentMediaTime()]];
            //[[ClientsAtHome sharedClientData].peopleStartDate replaceObjectAtIndex:sender.tag withObject:[NSDate date]];
        }
    }
    
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        UIButton *sitioBoton = locationButtonArray[sender.tag];
        sitioBoton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
        sitioBoton.titleLabel.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        
        [self performSelector:@selector(reverseAnimationPlaceNeeded:) withObject:sender afterDelay:0.5];
    }
}

- (void)reverseAnimationPlaceNeeded:(UIButton *)sender
{
    UIButton *sitioBoton = locationButtonArray [sender.tag];
    sitioBoton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    sitioBoton.titleLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
}

- (void)reverseAnimationMoneyNeeded:(UIButton *)sender
{
    money.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    money.textColor = [UIColor blackColor];
}

- (void)reverseAnimationCrystalNeeded:(UIButton *)sender
{
    crystal.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    crystal.textColor = [UIColor blackColor];
}

- (void)animateChange:(int)cuanto cual:(int)queTipo
{
    CGSize screenbounds = [[UIScreen mainScreen] bounds].size;
    int randomX = (screenbounds.width/2-100)+arc4random_uniform(200);
    //int randomX = arc4random()%80+120;
    int randomY = arc4random()%50+350;
    
    if (queTipo==1) {
        animationLabel.text = [NSString stringWithFormat:@"$%i",cuanto];
    }
    else if (queTipo==2)
    {
        animationLabel.text = [NSString stringWithFormat:@"%i Xp",cuanto];
    }
    else if (queTipo==3)
    {
        animationLabel.text = @"Couldn't sell anything!";
    }
    else if (queTipo==4)
    {
        animationLabel.text = [NSString stringWithFormat:@"%i Candy",cuanto];
    }
    else
    {
        animationLabel.text = @"Ad's didn't work!";
    }
    animationLabel.center = CGPointMake(randomX, randomY);
    
    [UIView animateWithDuration:6.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         animationLabel.center = CGPointMake(randomX, randomY-200);
                     }
                     completion:nil ];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         animationLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:4.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              animationLabel.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
}

-(void)refreshInterfaceValues
{
    money.text = [NSString stringWithFormat:@"Money: %li",(long)[GameSaveState sharedGameData].money];
    crystal.text = [NSString stringWithFormat:@"Candy: %li",(long)[GameSaveState sharedGameData].crystal];
}

-(void)startTimer
{
    for (int i=0; i<20; i++) {
        if ([[ClientsAtHome sharedClientData].peopleOnOrOff[i] isEqualToString:@"EMPEZO"])
        {
            NSDictionary *rowData = people[i];
            int tiempoTotal = [rowData[@"Time"] intValue]*60;
            
            if (![[ClientsAtHome sharedClientData].peopleStartDate[i] isKindOfClass:[NSNumber class]]) {
                [[ClientsAtHome sharedClientData].peopleStartDate replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:CACurrentMediaTime()]];
            }
            
            float currentDate = CACurrentMediaTime();
            float pastDate = [[ClientsAtHome sharedClientData].peopleStartDate[i] floatValue];
            float secondsBetween = currentDate-pastDate;
            
            //NSDate *currentDate = [NSDate date];
            //NSDate *pastDate = [ClientsAtHome sharedClientData].peopleStartDate[i];
            
            //NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:pastDate];
            
            int time = tiempoTotal-(secondsBetween);
            
            if (time>tiempoTotal) {
                [[ClientsAtHome sharedClientData].peopleStartDate replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:CACurrentMediaTime()]];
                currentDate = CACurrentMediaTime();
                pastDate = [[ClientsAtHome sharedClientData].peopleStartDate[i] floatValue];
                secondsBetween = currentDate-pastDate;
                time = tiempoTotal-(secondsBetween);
            }
            
            NSString *tiempoFaltante = [self changeToHrMinSec:time];
            UILabel *tiempo = timerLabelArray[i];
            tiempo.textAlignment = NSTextAlignmentCenter;
            tiempo.font = [UIFont fontWithName:@"AllerDisplay" size:18];
            tiempo.text = tiempoFaltante;
            tiempo.shadowColor = [UIColor redColor];
            tiempo.shadowOffset = CGSizeMake(1, 1);
            
            if (time<=0) {
                [[ClientsAtHome sharedClientData].peopleOnOrOff replaceObjectAtIndex:i withObject:@"TERMINO"];
                [[ClientsAtHome sharedClientData].peopleStartDate replaceObjectAtIndex:i withObject:@"NONE"];
                UIButton *cualBoton = collectButtonArray[i];
                cualBoton.hidden = NO;
                tiempo.hidden = YES;
                tiempo.shadowColor = [UIColor clearColor];
                tiempo.shadowOffset = CGSizeMake(0, 0);
            }
        }
    }
}

- (NSString *)changeToHrMin:(int)tiempoTotal
{
    int hours = floor(tiempoTotal/60);
    int minutes = round(tiempoTotal - hours * 60);
    
    if (hours!=0) {
        return [NSString stringWithFormat:@"%ihr %imin",hours,minutes];
    }
    else
    {
        return [NSString stringWithFormat:@"%imin",minutes];
    }
}

- (NSString *)changeToHrMinSec:(int)tiempoTotal
{
    int hours = floor(tiempoTotal/3600);
    int minutes = floor((tiempoTotal - hours * 3600)/60);
    int seconds = round(tiempoTotal-hours*3600-minutes*60);
    
    if (hours!=0) {
        return [NSString stringWithFormat:@"%ihr %imin %isec",hours,minutes,seconds];
    }
    else if (minutes!=0) {
        return [NSString stringWithFormat:@"%imin %isec",minutes,seconds];
    }
    else
    {
        return [NSString stringWithFormat:@"%isec",seconds];
    }
}

- (int)cualSitioEs:(UIButton *)sender sumarONo:(int)siONo
{
    NSString *cualSitio = [[ClientsAtHome sharedClientData].placeSentTo objectAtIndex:sender.tag];
    
    NSArray *nameArray = [NSArray arrayWithObjects:
                 @"Sealem",
                 @"Kingapolis",
                 @"New Town",
                 @"San Bernard",
                 @"Senferd",
                 @"Well Field",
                 @"Cashington",
                 @"Albachurch",
                 @"Baldas",
                 @"Maroni",
                 nil];
    
    int cual = 87;
    
    for (int i=0; i<10; i++)
    {
        if ([nameArray[i] isEqualToString:cualSitio])
        {
            cual = i;
        }
    }
    if (siONo==1&&cual!=87)
    {
        int cuantasVeces = [[ClientsAtHome sharedClientData].timesSentToEachPlace[cual] intValue];
        cuantasVeces++;
        
        [[ClientsAtHome sharedClientData].timesSentToEachPlace replaceObjectAtIndex:cual withObject:[NSNumber numberWithInt:cuantasVeces]];
    }
    return cual;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeFromContracts"]) {
        for (int i=0; i<20; i++) {
            if ([[ClientsAtHome sharedClientData].peopleOnOrOff[i] isEqualToString:@"NONE"]) {
                [[ClientsAtHome sharedClientData].placeSentTo replaceObjectAtIndex:i withObject:@"NONE"];
            }
        }
    }
}

- (IBAction)unwindToContracts:(UIStoryboardSegue*)unwindSegue
{
    for (int i=0; i<20; i++) {
        UIButton *locationButto = locationButtonArray[i];
        if ([[ClientsAtHome sharedClientData].placeSentTo[i] isEqualToString:@"NONE"]) {
            [locationButto setTitle:[NSString stringWithFormat:@"Send to:"] forState:UIControlStateNormal];
        }
        else
        {
            NSString *cualSitio = [[ClientsAtHome sharedClientData].placeSentTo objectAtIndex:i];
            [locationButto setTitle:cualSitio forState:UIControlStateNormal];
        }
    }
    
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [countDownTimer invalidate];
    [super viewWillDisappear:animated];
}

@end
