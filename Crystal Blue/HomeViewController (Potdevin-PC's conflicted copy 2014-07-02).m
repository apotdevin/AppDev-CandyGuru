//
//  HomeViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "HomeViewController.h"
#import "ClientViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize progressView;

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
    [self initializeInterface];
    [self startGamePlay];
    [self setupFreezers];
    [self freezerTimers];
    
    customerTimer = [NSTimer scheduledTimerWithTimeInterval:CUSTOMER_TIME target:self selector:@selector(randomCustomer) userInfo:nil repeats:YES];
    totalTimePlayedTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(showTotalTimePlayed) userInfo:nil repeats:YES];
    cookingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cookingSeconds) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actualizarPosiciones
{
    couch.center = CGPointMake(1210+scroller.contentOffset.x*-0.1, 426);
    mesa.center = CGPointMake(1550+scroller.contentOffset.x*-0.2, 520);
    contracts.center = CGPointMake(1550+scroller.contentOffset.x*-0.2, 480);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self actualizarPosiciones];
    
    [[NSUserDefaults standardUserDefaults] setInteger:scroller.contentOffset.x forKey:@"LastPosition"];
    
}

- (IBAction)button:(UIButton *)sender
{
    [self increaseXp:350];
    [self changeMoney:1000];
    [self changeCrystal:500];
}

- (void)initializeInterface
{
    //Scroller initialization
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"LastPosition"]!=0) {
        int screenPosition = [[NSUserDefaults standardUserDefaults] integerForKey:@"LastPosition"];
        
        [scroller setContentOffset:CGPointMake(screenPosition, 0)];
        [self actualizarPosiciones];
        
    }
    
    scroller.delegate=self;
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(1600, 568)];
    
    //Custom ProgressBar initialization
    
    self.progressView.trackColor = [UIColor clearColor];
    self.progressView.startAngle = (M_PI)/2.0;
    
    //Font Initialization
    lab.Font=[UIFont fontWithName:@"28 Days Later" size:42];
    [contracts setFont:[UIFont fontWithName:@"28 Days Later" size:42]];
    [shop setFont:[UIFont fontWithName:@"28 Days Later" size:42]];
    
    [xpLabel setFont:[UIFont fontWithName:@"28 Days Later" size:12]];
    [xpNeededLabel setFont:[UIFont fontWithName:@"28 Days Later" size:12]];
    [levelLabel setFont:[UIFont fontWithName:@"28 Days Later" size:20]];
    
    [moneyLabel setTextColor:[UIColor whiteColor]];
    [crystalLabel setTextColor:[UIColor whiteColor]];
    
    UIImageView *statsBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"statsWindow"]];
    statsBackground.frame = CGRectMake(645, 85, 310, 370);
    [scroller addSubview:statsBackground];
    
    UILabel *statsLabel = [[UILabel alloc]init];
    statsLabel.frame = CGRectMake(645, 85, 310, 30);
    statsLabel.textAlignment = NSTextAlignmentCenter;
    statsLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    statsLabel.text = @"...Game Stats...";
    //statsLabel.textColor = [UIColor whiteColor];
    [scroller addSubview:statsLabel];
    
    UIButton *easterEggButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [easterEggButton addTarget:self action:@selector(easterEggButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    easterEggButton.frame = CGRectMake(241, 184, 50, 30);
    easterEggButton.titleLabel.textColor = [UIColor whiteColor];
    [scroller addSubview:easterEggButton];
    
    totalTimeLabel = [[UILabel alloc]init];
    totalTimeLabel.frame = CGRectMake(650, 100, 300, 300);
    totalTimeLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    //totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    totalTimeLabel.numberOfLines = 20;
    [scroller addSubview:totalTimeLabel];
    [self showTotalTimePlayed];
    
    animationCrystal = [[UILabel alloc]init];
    animationCrystal.frame = CGRectMake(0, 0, 160, 50);
    animationCrystal.textColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    [self.view addSubview:animationCrystal];
    
    animationXp = [[UILabel alloc]init];
    animationXp.frame = CGRectMake(0, 0, 120, 50);
    [self.view addSubview:animationXp];
}

- (void)startGamePlay
{
    
    dangerLocation = [[NSMutableArray alloc]init];
    freezerPrendidosArray = [[NSMutableArray alloc]init];
    freezerTimerArray = [[NSMutableArray alloc]init];
    freezerButtonArray = [[NSMutableArray alloc]init];
    freezerTimeLabelArray = [[NSMutableArray alloc]init];
    freezerDateArray = [[NSMutableArray alloc]init];
    freezerImagesArray = [[NSMutableArray alloc]init];
    
    levelXp = [NSArray arrayWithObjects:
                        @100,
                        @500,
                        @1000,
                        @1500,
                        @2000,
                        @3000,
                        @4500,
                        @7000,
                        @8500,
                        @10000,
                        @12000,
                        @14000,
                        @16000,
                        @18000,
                        @20000,
                        @26000,
                        @32000,
                        @38000,
                        @44000,
                        @50000,
                        nil];
    
    [self iniciarClientes];
    
    //Si es la primera vez
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstView"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstView"];
        
        UIColor *tintColor = [UIColor colorWithRed:0.404 green:0.835 blue:0.969 alpha:0.7];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"currentProgressColor"];
        
        animationXp.textColor = tintColor;
        
        //User Game
        xp = 0;
        level = 1;
        purity = 10;
        money = 10000;
        crystal = 0;
        pills = 6;
        matchbox = 1;
        aluminum = 0;
        whitePowder = 10;
        redPowder = 10;
        liquidCrystal = 20;
        currentFreezers = 1;
        
        //Contracts
        currentSeller = 0;
        currentBully = 0;
        currentLawyer = 0;
        currentSpy = 0;
        
        //Stats
        totalCustomersAttended = 0;
        totalCrystal = 0;
        totalCrystalMade = 0;
        totalLiquidCrystal = 0;
        totalCustomersNotAttended = 0;
        totalRedPowder = 0;
        totalWhitePowder = 0;
        totalGreyPowder = 0;
        totalPills = 0;
        totalMatchboxes = 0;
        totalAluminum = 0;
        
        //Lab Settings
        currentLabBackground = 1;
        currentLabSetting = 1;
        currentGlass = 1;
        currentBowl = 1;
        currentPot = 1;
        currentDecantor = 1;
        currentExtractor = 1;
        currentBeaker = 1;
        currentMixer = 1;
        currentDistilator = 1;
        
        //Technology
        currentCrystalColor = 1;
        
        //Clientes Desactivados
        infoClientes = [[NSMutableArray alloc]init];
        for (int i=0; i<10; i++) {
            [infoClientes addObject:@0];
        }
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        [standard setObject:infoClientes forKey:@"infoClientes"];
        
        [standard setInteger:xp forKey:@"currentXp"];
        [standard setInteger:level forKey:@"currentLevel"];
        [standard setInteger:purity forKey:@"currentPurity"];
        [standard setInteger:money forKey:@"currentMoney"];
        [standard setInteger:crystal forKey:@"currentCrystal"];
        [standard setInteger:pills forKey:@"currentPills"];
        [standard setInteger:matchbox forKey:@"currentMatchbox"];
        [standard setInteger:aluminum forKey:@"currentAluminum"];
        [standard setInteger:whitePowder forKey:@"currentWhitePowder"];
        [standard setInteger:redPowder forKey:@"currentRedPowder"];
        [standard setInteger:liquidCrystal forKey:@"currentLiquidCrystal"];
        [standard setInteger:currentFreezers forKey:@"currentFreezers"];
        
        [standard setInteger:currentSeller forKey:@"currentSeller"];
        [standard setInteger:currentBully forKey:@"currentBully"];
        [standard setInteger:currentLawyer forKey:@"currentLawyer"];
        [standard setInteger:currentSpy forKey:@"currentSpy"];
        
        [standard setInteger:totalCustomersAttended forKey:@"totalCustomersAttended"];
        [standard setInteger:totalCrystal forKey:@"totalCrystalSold"];
        [standard setInteger:totalCrystalMade forKey:@"totalCrystalMade"];
        [standard setInteger:totalLiquidCrystal forKey:@"totalLiquidCrystal"];
        [standard setInteger:totalCustomersNotAttended forKey:@"totalCustomersNotAttended"];
        [standard setInteger:totalRedPowder forKey:@"totalRedPowder"];
        [standard setInteger:totalWhitePowder forKey:@"totalWhitePowder"];
        [standard setInteger:totalGreyPowder forKey:@"totalGreyPowder"];
        [standard setInteger:totalPills forKey:@"totalPills"];
        [standard setInteger:totalMatchboxes forKey:@"totalMatchboxes"];
        [standard setInteger:totalAluminum forKey:@"totalAluminum"];
        
        [standard setInteger:currentLabBackground forKey:@"currentLabBackground"];
        [standard setInteger:currentLabSetting forKey:@"currentLabSetting"];
        [standard setInteger:currentGlass forKey:@"currentGlass"];
        [standard setInteger:currentBowl forKey:@"currentBowl"];
        [standard setInteger:currentPot forKey:@"currentPot"];
        [standard setInteger:currentDecantor forKey:@"currentDecantor"];
        [standard setInteger:currentExtractor forKey:@"currentExtractor"];
        [standard setInteger:currentBeaker forKey:@"currentBeaker"];
        [standard setInteger:currentMixer forKey:@"currentMixer"];
        [standard setInteger:currentDistilator forKey:@"currentDistilator"];
        [standard setInteger:currentCrystalColor forKey:@"currentCrystalColor"];
        
        [standard setInteger:0 forKey:@"currentShopList"];
        [standard setInteger:0 forKey:@"musicOnOrOff"];
        
        [self iniciarDangerArray];
        [self iniciarFreezerArray];
        
        [self asignarValoresDeHome];
        [self showTotalTimePlayed];
        [standard synchronize];
        
    }
    //Si NO es la primera vez
    else
    {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentProgressColor"];
        UIColor *tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        
        animationXp.textColor = tintColor;
        
        [self refreshProgress];
        [self revisarSiHayClientes];
        [self showTotalTimePlayed];
        
    }
}

- (void)iniciarDangerArray
{
    NSMutableArray *valoresDanger = [[NSMutableArray alloc]init];
    [valoresDanger addObject:[NSNumber numberWithInt:90]];
    [valoresDanger addObject:[NSNumber numberWithInt:70]];
    [valoresDanger addObject:[NSNumber numberWithInt:50]];
    [valoresDanger addObject:[NSNumber numberWithInt:100]];
    [valoresDanger addObject:[NSNumber numberWithInt:100]];
    [valoresDanger addObject:[NSNumber numberWithInt:90]];
    [valoresDanger addObject:[NSNumber numberWithInt:80]];
    [valoresDanger addObject:[NSNumber numberWithInt:100]];
    [valoresDanger addObject:[NSNumber numberWithInt:90]];
    
    for (int i = 0; i<10; i++)
    {
        [dangerLocation addObject:@1000];
    }
    
    [dangerLocation replaceObjectAtIndex:7 withObject:[NSNumber numberWithInt:0]];
    
    cuantosGuardados = 0;
    while (cuantosGuardados<9) {
        
        int random = arc4random()%10;
        int number = [dangerLocation[random] intValue];
        if (number==1000)
        {
            int numero = [[valoresDanger objectAtIndex:cuantosGuardados] intValue];
            [dangerLocation replaceObjectAtIndex:random withObject:[NSNumber numberWithInt:numero]];
            cuantosGuardados++;
        }
    }
    
    NSMutableArray *dangerMultiplier = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++) {
        if ([dangerLocation[i]intValue]==100) {
            [dangerMultiplier addObject:[NSNumber numberWithInt:6]];
        }
        else if ([dangerLocation[i]intValue]==90) {
            [dangerMultiplier addObject:[NSNumber numberWithInt:5]];
        }
        else if ([dangerLocation[i]intValue]==80) {
            [dangerMultiplier addObject:[NSNumber numberWithInt:4]];
        }
        else if ([dangerLocation[i]intValue]==70) {
            [dangerMultiplier addObject:[NSNumber numberWithInt:3]];
        }
        else if ([dangerLocation[i]intValue]==50) {
            [dangerMultiplier addObject:[NSNumber numberWithInt:2]];
        }
        else if ([dangerLocation[i]intValue]==0) {
            [dangerMultiplier addObject:[NSNumber numberWithInt:1]];
        }
    }
    
    NSMutableArray *timesSentToEachPlace = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        [timesSentToEachPlace addObject:[NSNumber numberWithInt:0]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:timesSentToEachPlace forKey:@"timesSentToEachPlace"];
    [[NSUserDefaults standardUserDefaults] setObject:dangerMultiplier forKey:@"dangerMultiplier"];
    [[NSUserDefaults standardUserDefaults] setObject:dangerLocation forKey:@"dangerLocationValue"];
}

- (void)iniciarFreezerArray
{
    for (int i=0; i<7; i++)
    {
        [freezerPrendidosArray addObject:@"NO"];
    }
    for (int i=0; i<18; i++) {
        [freezerTimerArray addObject:@"APAGADO"];
        [freezerDateArray addObject:@"NO"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:freezerPrendidosArray forKey:@"freezerPrendidosArray"];
    [[NSUserDefaults standardUserDefaults] setObject:freezerTimerArray forKey:@"freezerTimerArray"];
    [[NSUserDefaults standardUserDefaults] setObject:freezerDateArray forKey:@"freezerDateArray"];
    
}

- (void)iniciarClientes
{
    clientes = [[NSMutableArray alloc]init];
    infoZone = [[NSMutableArray alloc]init];
    altura = [[NSMutableArray alloc]init];
    tiemposClientes = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++) {
        UIButton *cliente = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cliente setTag:i];
        [cliente addTarget:self action:@selector(clientButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cliente setFrame:CGRectMake(1700, 250, 50, 50)];
        
        [scroller addSubview:cliente];
        [clientes addObject:cliente];
    }
    
    for (int i=0; i<4; i++) {
        [infoZone addObject:@0];
    }
    
    [altura addObject:@138];
    [altura addObject:@213];
    [altura addObject:@288];
    [altura addObject:@363];
    
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    [tiemposClientes addObject:@10];
    
}

- (void)setupFreezers
{
    for (int i=0; i<7; i++)
    {
        UIImageView *freezer = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%iOpenFreezer",i+1]]];
        freezer.tag = i;
        [freezerImagesArray addObject:freezer];
    }
    
    int completeFreezers = 1;
    
    for (int i=1; i<7; i++) {
        if (currentFreezers>3*(i-1)) {
            completeFreezers=i;
        }
    }
    
    NSArray *xCenter = [NSArray arrayWithObjects:
                      [NSNumber numberWithInt:150],
                      [NSNumber numberWithInt:230],
                      [NSNumber numberWithInt:245],
                      [NSNumber numberWithInt:420],
                      [NSNumber numberWithInt:405],
                      [NSNumber numberWithInt:565]
                      , nil];
    
    NSArray *yCenter = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:437],
                        [NSNumber numberWithInt:435],
                        [NSNumber numberWithInt:434],
                        [NSNumber numberWithInt:433],
                        [NSNumber numberWithInt:434],
                        [NSNumber numberWithInt:433]
                        , nil];
    
    for (int i=0; i<completeFreezers; i++) {
        
        NSString *cualFreezer;
        
        if ([freezerPrendidosArray[i] isEqualToString:@"NO"]) {
            cualFreezer = [NSString stringWithFormat:@"%iOpenFreezer",i+1];
        }
        else
        {
            cualFreezer = [NSString stringWithFormat:@"%iClosedFreezer",i+1];
        }
        
        UIImageView *freezer = freezerImagesArray[i];
        [freezer setImage:[UIImage imageNamed:cualFreezer]];
        freezer.center = CGPointMake([[xCenter objectAtIndex:i] intValue],[[yCenter objectAtIndex:i]intValue]);
        [scroller addSubview:freezer];
        
    }
    
    for (int i=0; i<18; i++) {
        
        UIButton *timer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        timer.tag = i;
        [timer setTitle:@"Freeze!" forState:UIControlStateNormal];
        timer.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
        timer.tintColor = [UIColor whiteColor];
        [timer addTarget:self action:@selector(freezeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [freezerButtonArray addObject:timer];
        
        UILabel *totalTime = [[UILabel alloc] init];
        totalTime.text = @"5min";
        totalTime.textAlignment = NSTextAlignmentCenter;
        totalTime.font = [UIFont fontWithName:@"28 Days Later" size:16];
        totalTime.textColor = [UIColor whiteColor];
        [freezerTimeLabelArray addObject:totalTime];
    }
    
}

- (void)freezerTimers
{
    for (int i=0; i<currentFreezers; i++) {
        
        int x=0;
        int y=0;
        
        if (i<=2) {
            x = 80;
            y = 340;
        }
        else if (i>2&&i<=5)
        {
            x = 170;
            y = 220;
        }
        else if (i>5&&i<=8)
        {
            x = 260;
            y = 100;
        }
        else if (i>8&&i<=11)
        {
            x = 350;
            y = -20;
        }
        else if (i>11&&i<=14)
        {
            x = 440;
            y = -140;
        }
        else
        {
            x = 530;
            y = -260;
        }
        
        UIButton *button = freezerButtonArray[i];
        button.frame = CGRectMake(x, y+40*i, 100, 30);
        [scroller addSubview:button];
        
        UILabel *label = freezerTimeLabelArray[i];
        label.frame = CGRectMake(x, y+40*i, 100, 30);
        [scroller addSubview:label];
        
        if ([freezerTimerArray[i] isEqualToString:@"APAGADO"])
        {
            label.hidden = YES;
            button.hidden = NO;
        }
        else
        {
            label.hidden = NO;
            button.hidden = YES;
            
            NSDate *presentDate = [NSDate date];
            NSDate *pastDate = freezerDateArray[i];
            
            NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:pastDate];
            int time = TIEMPO_FREEZER-secondsBetween;
            
            NSString *tiempo = [self changeToHrMinSec:time];
            
            if (time<=0) {
                tiempo = @"0sec";
            }
            
            label.text = tiempo;
            
        }
    }
}

- (void)refreshFreezerImage
{
    int completeFreezers = 1;
    
    for (int i=1; i<7; i++) {
        if (currentFreezers>3*(i-1)) {
            completeFreezers=i;
        }
    }
    
    for (int i=0; i<completeFreezers; i++) {
        
        NSString *cualFreezer;
        
        if ([freezerPrendidosArray[i] isEqualToString:@"NO"]) {
            cualFreezer = [NSString stringWithFormat:@"%iOpenFreezer",i+1];
        }
        else
        {
            cualFreezer = [NSString stringWithFormat:@"%iClosedFreezer",i+1];
        }
        
        UIImageView *freezer = freezerImagesArray[i];
        [freezer setImage:[UIImage imageNamed:cualFreezer]];
        
    }
}

- (void)changeFreezerCompletion:(int)cualBoton
{
    int quitarOPoner;
    if (cualBoton>0)
    {
        quitarOPoner=1;
    }
    else
    {
        quitarOPoner=2;
    }
    int cual = abs(cualBoton)-1;
    
    for (int i=0; i<18; i=i+3)
    {
        if (quitarOPoner==1) {
            if (cual==i||cual==i+1||cual==i+2)
            {
                [freezerPrendidosArray replaceObjectAtIndex:i/3 withObject:@"YES"];
            }
        }
        else
        {
            
            
            if ([freezerTimerArray[i]isEqualToString:@"APAGADO"]&&[freezerTimerArray[i+1]isEqualToString:@"APAGADO"]&&[freezerTimerArray[i+2]isEqualToString:@"APAGADO"])
            {
                [freezerPrendidosArray replaceObjectAtIndex:i/3 withObject:@"NO"];
            }
        }
        
    }
    [self refreshFreezerImage];
}

- (void)refreshProgress
{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    
    xp = [standard integerForKey:@"currentXp"];
    level = [standard integerForKey:@"currentLevel"];
    purity = [standard integerForKey:@"currentPurity"];
    money = [standard integerForKey:@"currentMoney"];
    crystal = [standard integerForKey:@"currentCrystal"];
    liquidCrystal = [standard integerForKey:@"currentLiquidCrystal"];
    pills = [standard integerForKey:@"currentPills"];
    matchbox = [standard integerForKey:@"currentMatchbox"];
    aluminum = [standard integerForKey:@"currentAluminum"];
    currentFreezers = [standard integerForKey:@"currentFreezers"];
    
    currentSeller = [standard integerForKey:@"currentSeller"];
    currentBully = [standard integerForKey:@"currentBully"];
    currentLawyer = [standard integerForKey:@"currentLawyer"];
    currentSpy = [standard integerForKey:@"currentSpy"];
    
    totalCustomersAttended = [standard integerForKey:@"totalCustomersAttended"];
    totalCrystal = [standard integerForKey:@"totalCrystalSold"];
    totalCrystalMade = [standard integerForKey:@"totalCrystalMade"];
    totalLiquidCrystal = [standard integerForKey:@"totalLiquidCrystal"];
    totalCustomersNotAttended = [standard integerForKey:@"totalCustomersNotAttended"];
    totalRedPowder = [standard integerForKey:@"totalRedPowder"];
    totalWhitePowder = [standard integerForKey:@"totalWhitePowder"];
    totalGreyPowder = [standard integerForKey:@"totalGreyPowder"];
    totalPills = [standard integerForKey:@"totalPills"];
    totalMatchboxes = [standard integerForKey:@"totalMatchboxes"];
    totalAluminum = [standard integerForKey:@"totalAluminum"];
    
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
    
    dangerLocation = [NSMutableArray arrayWithArray:[standard objectForKey:@"dangerLocation"]];
    infoClientes = [NSMutableArray arrayWithArray:[standard objectForKey:@"infoClientes"]];
    
    freezerPrendidosArray = [NSMutableArray arrayWithArray:[standard objectForKey:@"freezerPrendidosArray"]];
    freezerTimerArray = [NSMutableArray arrayWithArray:[standard objectForKey:@"freezerTimerArray"]];
    freezerDateArray = [NSMutableArray arrayWithArray:[standard objectForKey:@"freezerDateArray"]];
    
    [self asignarValoresDeHome];
}

- (void)asignarValoresDeHome
{
    int amountXpForLevel = [[levelXp objectAtIndex:level-1] intValue];
    [xpLabel setText:[NSString stringWithFormat:@"%d",xp]];
    [xpNeededLabel setText:[NSString stringWithFormat:@"%d",amountXpForLevel]];
    float amountOfProgress = (double)xp/amountXpForLevel;
    [progressView setProgress: amountOfProgress];
    [levelLabel setText:[NSString stringWithFormat:@"LVL. %d",level]];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *results = [formatter stringFromNumber:[NSNumber numberWithInteger:money]];
    
    if (money>=2000000000) {
        money = 2000000000;
        [moneyLabel setText:[NSString stringWithFormat:@"Money: FULL!!"]];
    }
    else
    {
        [moneyLabel setText:[NSString stringWithFormat:@"Money: %@",results]];
    }
    [purityLabel setText:[NSString stringWithFormat:@"Purity: %1.1f%%",purity]];
    [crystalLabel setText:[NSString stringWithFormat:@"Crystal: %d",crystal]];
    [liquidCrystalLabel setText:[NSString stringWithFormat:@"Liquid Crystal: %d",liquidCrystal]];
    [moneyLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [purityLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [crystalLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [liquidCrystalLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [moneyLabel setFont:[UIFont fontWithName:@"28 Days Later" size:16]];
    [purityLabel setFont:[UIFont fontWithName:@"28 Days Later" size:26]];
    [crystalLabel setFont:[UIFont fontWithName:@"28 Days Later" size:16]];
    [liquidCrystalLabel setFont:[UIFont fontWithName:@"28 Days Later" size:12]];
    
    purityLabel.frame = CGRectMake(230, 10, 90, 70);
    purityLabel.lineBreakMode = NSLineBreakByWordWrapping;
    purityLabel.numberOfLines = 2;
    purityLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)randomCustomer
{
    int i = arc4random_uniform(PROBA_CLIENTE);
    int j = arc4random_uniform(PROBA_POLICIA);
    
    if (i==0)
    {
        int j = arc4random_uniform(10);
        
        [self mostrarClientes:j];
        
    }
    if (j==0) {
        //activar policiaaaa
    }
    
}

- (void)showTotalTimePlayed
{
    int totalTime = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentTotalTime"];
    
    int days = floor(totalTime/43200);
    int hours = floor((totalTime-days*43200)/3600);
    int minutes = floor((totalTime - hours*3600-days*43200)/60);
    
    NSString *time;
    
    if (days!=0)
    {
        time = [NSString stringWithFormat:@"%idays %ihr %imin",days,hours,minutes];
    }
    else if (hours!=0)
    {
        time = [NSString stringWithFormat:@"%ihr %imin",hours,minutes];
    }
    else
    {
        time = [NSString stringWithFormat:@"%imin",minutes];
    }
    
    totalTimeLabel.text = [NSString stringWithFormat:@"Total time played: %@\n\nCustomers attended: %i\nCustomers NOT attended: %i\n\nCrystal Sold: %i\n\nCrystal made: %i\nLiquid Crystal made: %i\nRed Powder made: %i\nWhite Powder made: %i\nGrey Powder made: %i\n\nPills bought: %i\nMatchboxes bought: %i\nAluminum bought: %i",time,totalCustomersAttended,totalCustomersNotAttended,totalCrystal,totalCrystalMade,totalLiquidCrystal,totalRedPowder,totalWhitePowder,totalGreyPowder,totalPills,totalMatchboxes,totalAluminum];
}

- (void)cookingSeconds
{
    for (int i=0; i<18; i++)
    {
        if ([freezerTimerArray[i] isEqualToString:@"PRENDIDO"])
        {
            NSDate *presentDate = [NSDate date];
            NSDate *pastDate = freezerDateArray[i];
            
            NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:pastDate];
            int time = TIEMPO_FREEZER-secondsBetween;
            
            if (time>=0) {
                NSString *tiempo = [self changeToHrMinSec:time];
                
                UILabel *cual = freezerTimeLabelArray[i];
                cual.text = tiempo;
            }
            else
            {
                crystal=crystal+20;
                [self increaseXp:2*level];
                
                [self animateChange:20 cual:1];
                [self animateChange:2*level cual:2];
                
                [[NSUserDefaults standardUserDefaults] setInteger:crystal forKey:@"currentCrystal"];
                
                [crystalLabel setText:[NSString stringWithFormat:@"Crystal: %d",crystal]];
                
                [freezerTimerArray replaceObjectAtIndex:i withObject:@"APAGADO"];
                [freezerDateArray replaceObjectAtIndex:i withObject:@"NO"];
                
                [[NSUserDefaults standardUserDefaults]setObject:freezerDateArray forKey:@"freezerDateArray"];
                [[NSUserDefaults standardUserDefaults]setObject:freezerTimerArray forKey:@"freezerTimerArray"];
                
                UIButton *button = freezerButtonArray[i];
                UILabel *label = freezerTimeLabelArray[i];
                
                label.hidden = YES;
                button.hidden = NO;
                
                [self changeFreezerCompletion:-(i+1)];
                
                totalCrystalMade = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalCrystalMade"]+20;
                [[NSUserDefaults standardUserDefaults] setInteger:totalCrystalMade forKey:@"totalCrystalMade"];
                [self showTotalTimePlayed];
                
            }
            
        }
        
    }
    
}

- (void)mostrarClientes:(int)cual
{
    int clientePrendido = [[infoClientes objectAtIndex:cual] intValue];
    int randomZone = arc4random_uniform(4);
    int zonePrendida = [[infoZone objectAtIndex:randomZone] intValue];
    
    if (clientePrendido==0&&zonePrendida==0) {
        
        int alturaZone = [altura[randomZone]intValue];
        
        [infoClientes replaceObjectAtIndex:cual withObject:[NSNumber numberWithInt:randomZone]];
        [infoZone replaceObjectAtIndex:randomZone withObject:@1];
        [[NSUserDefaults standardUserDefaults]setObject:infoClientes forKey:@"infoClientes"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        UIButton *cualCliente = [clientes objectAtIndex:cual];
        cualCliente.frame = CGRectMake(1700, alturaZone, 50, 50);
        [cualCliente setTitle:[NSString stringWithFormat:@"%i",cual+1] forState:UIControlStateNormal];
        [cualCliente setBackgroundImage:[UIImage imageNamed:@"ProgressCircle"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.75 animations:^{cualCliente.center=CGPointMake(1550, alturaZone);}];
        
        //int duracionCliente = [tiemposClientes[cual]intValue];
        int duracionCliente = arc4random_uniform(5)+15;
        
        [self sonidoPuerta];
        
        NSArray *datos = [NSArray arrayWithObjects:[NSNumber numberWithInt:randomZone],[NSNumber numberWithInt:cual], nil];
        
        [self performSelector:@selector(quitarCliente:) withObject:datos afterDelay:duracionCliente];
    }
}

- (void)mostrarClientesYaActivos:(int)cual
{
    int zona = [infoClientes[cual]intValue];
    int alturaZone = [altura[zona]intValue];
    
    [infoZone replaceObjectAtIndex:zona withObject:@1];
    
    UIButton *cualCliente = [clientes objectAtIndex:cual];
    cualCliente.frame = CGRectMake(1525, alturaZone-25, 50, 50);
    [cualCliente setTitle:[NSString stringWithFormat:@"%i",cual+1] forState:UIControlStateNormal];
    [cualCliente setBackgroundImage:[UIImage imageNamed:@"ProgressCircle"] forState:UIControlStateNormal];
    
    //int duracionCliente = [tiemposClientes[cual]intValue];
    int duracionCliente = arc4random_uniform(5)+15;
    
    NSArray *datos = [NSArray arrayWithObjects:[NSNumber numberWithInt:zona],[NSNumber numberWithInt:cual], nil];
    
    [self performSelector:@selector(quitarCliente:) withObject:datos afterDelay:duracionCliente];
}

- (void)revisarSiHayClientes
{
    for (int i=0; i<10; i++) {
        int clientePrendido = [infoClientes[i]intValue];
        if (clientePrendido!=0) {
            [self mostrarClientesYaActivos:i];
        }
    }
}

- (void)quitarCliente:(NSArray *)sender
{
    int zona = [sender[0]intValue];
    int alturaZone = [altura[zona]intValue];
    int cual = [sender[1]intValue];
    
    [infoClientes replaceObjectAtIndex:cual withObject:@0];
    [infoZone replaceObjectAtIndex:zona withObject:@0];
    
    [[NSUserDefaults standardUserDefaults]setObject:infoClientes forKey:@"infoClientes"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIButton *cualCliente = [clientes objectAtIndex:cual];
    [UIView animateWithDuration:0.75 animations:^{cualCliente.center=CGPointMake(1700, alturaZone);}];
    
}

- (void)clientButtonPressed:(UIButton *)sender
{
    int cual = sender.tag;
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    ClientViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"clientVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.cual=cual+1;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)freezeButtonPressed:(UIButton *)sender
{
    if (liquidCrystal>=1) {
        
        [self sonidoFreezer];
        
        liquidCrystal=liquidCrystal-1;
        [[NSUserDefaults standardUserDefaults] setInteger:liquidCrystal forKey:@"currentLiquidCrystal"];
        [liquidCrystalLabel setText:[NSString stringWithFormat:@"Liquid Crystal: %d",liquidCrystal]];
        
        [freezerTimerArray replaceObjectAtIndex:sender.tag withObject:@"PRENDIDO"];
        [freezerDateArray replaceObjectAtIndex:sender.tag withObject:[NSDate date]];
        
        [[NSUserDefaults standardUserDefaults]setObject:freezerDateArray forKey:@"freezerDateArray"];
        [[NSUserDefaults standardUserDefaults]setObject:freezerTimerArray forKey:@"freezerTimerArray"];
        
        UIButton *button = freezerButtonArray[sender.tag];
        UILabel *label = freezerTimeLabelArray[sender.tag];
        
        label.hidden = NO;
        button.hidden = YES;
        
        NSString *tiempo = [self changeToHrMinSec:TIEMPO_FREEZER];
        
        label.text = tiempo;
        
        [self changeFreezerCompletion:sender.tag+1];
        
    }
    
    else
    {
        liquidCrystalLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
        liquidCrystalLabel.textColor = [UIColor redColor];
        
        [self performSelector:@selector(reverseAnimationLiquidCrystal) withObject:nil afterDelay:0.5];
    }
}
- (void)reverseAnimationLiquidCrystal
{
    liquidCrystalLabel.font = [UIFont fontWithName:@"28 Days Later" size:12];
    liquidCrystalLabel.textColor = [UIColor whiteColor];
}

- (void)increaseXp:(int)howMuch
{
    xp = xp+howMuch;
    [self checkLevel];
}

- (void)checkLevel
{
    int amountXpForLevel = [[levelXp objectAtIndex:level-1]intValue];
    
    if (xp>=amountXpForLevel)
    {
        if (level!=20) {
            level++;
            xp=xp-amountXpForLevel;
            
            if (level<19) {
                int amountXpForNextLevel = [[levelXp objectAtIndex:level]intValue];
                if (xp>amountXpForNextLevel)
                {
                    [self checkLevel];
                }
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"currentLevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:xp forKey:@"currentXp"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self asignarValoresDeHome];
}

- (void)changeMoney:(int)howMuch
{
    money = money+howMuch;
    
    if (money>=2000000000) {
        money = 2000000000;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:money forKey:@"currentMoney"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self asignarValoresDeHome];
}

- (void)changeCrystal:(int)howMuch
{
    crystal = crystal+howMuch;
    
    [[NSUserDefaults standardUserDefaults] setInteger:crystal forKey:@"currentCrystal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self asignarValoresDeHome];
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

- (void)animateChange:(int)cuanto cual:(int)cualLabel
{
    int randomX = arc4random_uniform(170)+75;
    int randomY = arc4random_uniform(100)+350;
    
    UILabel *animation;
    
    if (cualLabel==1) {
        animation = animationCrystal;
        animation.text = [NSString stringWithFormat:@"+%i Crystal",cuanto];
    }
    else
    {
        animation = animationXp;
        animation.text = [NSString stringWithFormat:@"+%i Xp",cuanto];
    }
    
    animation.textAlignment = NSTextAlignmentCenter;
    animation.font = [UIFont fontWithName:@"28 Days Later" size:30];
    animation.center = CGPointMake(randomX, randomY);
    
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         animation.center = CGPointMake(randomX, randomY-300);
                     }
                     completion:nil ];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         animation.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              animation.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
}

- (IBAction)contractsButton:(id)sender
{
    [self sonidoContracts];
}

- (IBAction)shopButton:(id)sender
{
    [self sonidoShop];
}

- (IBAction)labButton:(id)sender
{
    
}

- (IBAction)pauseButton:(id)sender
{
    
}

- (IBAction)contractsViewButton:(id)sender
{
    [self sonidoContracts];
    [[NSUserDefaults standardUserDefaults]setInteger:1170 forKey:@"LastPosition"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ContractsVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)labViewButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"LastPosition"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"labVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)shopViewButton:(id)sender
{
    [self sonidoShop];
    
    [[NSUserDefaults standardUserDefaults]setInteger:250 forKey:@"LastPosition"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"shopVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)mapButton:(id)sender
{
    
}

- (void)easterEggButtonPressed
{
    //Para Color Aleatorio de Barra
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.7];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"currentProgressColor"];
    
    [progressView setTintColor:color];
    animationXp.textColor = color;
}

- (IBAction)buttonLeft:(UIButton *)sender
{
    [scroller scrollRectToVisible:CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height) animated:YES];
}
- (IBAction)buttonRight:(UIButton *)sender
{
    [scroller scrollRectToVisible:CGRectMake(1400, 0, scroller.frame.size.width, scroller.frame.size.height) animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [totalTimePlayedTimer invalidate];
    [customerTimer invalidate];
    [cookingTimer invalidate];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)sonidoPuerta
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"knockknock" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

- (void)sonidoContracts
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"contractSound" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

- (void)sonidoFreezer
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"freezerSound" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

- (void)sonidoShop
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"shopSound" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}





























@end
