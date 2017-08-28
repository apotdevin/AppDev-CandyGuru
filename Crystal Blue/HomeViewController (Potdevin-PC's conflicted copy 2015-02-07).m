//
//  HomeViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "HomeViewController.h"
#import "ClientViewController.h"
#import "DangerClientViewController.h"
#import "CrystalAppDelegate.h"
#import "ClientsAtHome.h"
#import "BannerHelper.h"
#import "SoundHelper.h"
#import "RMStore.h"
#import <FacebookSDK/FacebookSDK.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize progressView;

- (void)viewDidLoad
{
    [self requestProductInfo];
    [BannerHelper sharedAd];
    
    [[GameCenterHelper sharedGC] authenticateLocalUserOnViewController:self];
    [GameSaveState sharedGameData].showCustomerHome=1;
    
    [self initializeInterface];
    [self startGamePlay];
    
    customerTimer = [NSTimer scheduledTimerWithTimeInterval:CUSTOMER_TIME target:self selector:@selector(randomCustomer) userInfo:nil repeats:YES];
    totalTimePlayedTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(showTotalTimePlayed) userInfo:nil repeats:YES];
    cookingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cookingSeconds) userInfo:nil repeats:YES];
    dangerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dangerSeconds) userInfo:nil repeats:YES];
    saveTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(automaticSave) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** Refreshes image positions when the user scrolls the screen
 */
- (void)actualizarPosiciones
{
    if ([GameSaveState sharedGameData].screenSize==0)
    {
        couch.center = CGPointMake(1210+scroller.contentOffset.x*-0.1, 426);
        mesa.center = CGPointMake(1450+scroller.contentOffset.x*-0.2, 520);
        contracts.center = CGPointMake(1550+scroller.contentOffset.x*-0.2, 480);
    }
}
/** Retrieves in app purchase products from the server
 */
- (void)requestProductInfo
{
    if ([[RMStore defaultStore]canMakePayments]) {
        NSSet *products = [NSSet setWithArray:@[@"anthonypotdevin.crystalblue.1000cash",
                                                @"anthonypotdevin.crystalblue.10000cash",
                                                @"anthonypotdevin.crystalblue.100000cash",
                                                @"anthonypotdevin.crystalblue.1000000cash",
                                                @"anthonypotdevin.crystalblue.5tickets",
                                                @"anthonypotdevin.crystalblue.20tickets",
                                                @"anthonypotdevin.crystalblue.40tickets",
                                                @"anthonypotdevin.crystalblue.removebanners"]];
        [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            NSLog(@"Products loaded");
            [GameSaveState sharedGameData].loadedProducts=1;
        } failure:^(NSError *error) {
            NSLog(@"RMSTORE: Something went wrong");
            [GameSaveState sharedGameData].loadedProducts=0;
        }];
    }
}

/** Shows or hides the available customer icon depending on the position of the screen and if there are any customers
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int cuantos = 0;
    for (int i=0; i<10; i++) {
        int clientePrendido = [[ClientsAtHome sharedClientData].infoClientes[i]intValue];
        if (clientePrendido!=123)
        {
            cuantos++;
        }
    }
    if (scroller.contentOffset.x>=1150) {
        availableCustomer.hidden = YES;
    }
    else if (cuantos==0) {
        availableCustomer.hidden = YES;
    }
    else
    {
        availableCustomer.hidden = NO;
    }
    
    [self actualizarPosiciones];
    [ClientsAtHome sharedClientData].homeViewPosition = scroller.contentOffset.x;
}

/** Places all of the elements of the home view screen
 */
- (void)initializeInterface
{
    //Scroller initialization
    [scroller setContentOffset:CGPointMake([ClientsAtHome sharedClientData].homeViewPosition, 0)];
    [self actualizarPosiciones];
    
    scroller.delegate=self;
    [scroller setScrollEnabled:YES];
    
    if ([GameSaveState sharedGameData].screenSize==0) {
        [scroller setContentSize:CGSizeMake(1600, 568)];
        imageZoom = 1;
        freezerZoom = 1;
        clientZoom = 1;
        screenClientHeight = 0;
        screenClient = 0;
    }
    else if ([GameSaveState sharedGameData].screenSize==1)
    {
        [scroller setContentSize:CGSizeMake(1600, 480)];
        imageZoom = 1;
        freezerZoom = 1;
        clientZoom = 1;
        screenClientHeight = 0;
        screenClient = 0;
    }
    else if ([GameSaveState sharedGameData].screenSize==2)
    {
        [scroller setContentSize:CGSizeMake(1600, 667)];
        imageZoom=1.4;
        freezerZoom = 1.2;
        screenFreezerHeight = 215;
        clientZoom = 2;
        screenClientHeight = 63;
        screenClient = 30;
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        [scroller setContentSize:CGSizeMake(1600, 736)];
        imageZoom=1.4;
        freezerZoom = 1.3;
        screenFreezerHeight = 335;
        clientZoom = 3.2;
        screenClientHeight = 100;
        screenClient = 35;
    }
    
    //Custom ProgressBar initialization
    
    self.progressView.trackColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    self.progressView.startAngle = (M_PI)/2.0;
    
    //Font Initialization
    lab.Font=[UIFont fontWithName:@"28 Days Later" size:42*imageZoom];
    [contracts setFont:[UIFont fontWithName:@"28 Days Later" size:42*imageZoom]];
    [shop setFont:[UIFont fontWithName:@"28 Days Later" size:42*imageZoom]];
    
    [xpLabel setFont:[UIFont fontWithName:@"28 Days Later" size:12*imageZoom]];
    [xpNeededLabel setFont:[UIFont fontWithName:@"28 Days Later" size:12*imageZoom]];
    [levelLabel setFont:[UIFont fontWithName:@"28 Days Later" size:32*imageZoom]];
    
    [moneyLabel setTextColor:[UIColor whiteColor]];
    [crystalLabel setTextColor:[UIColor whiteColor]];
    [moneyLabel setFont:[UIFont fontWithName:@"28 Days Later" size:16*imageZoom]];
    [purityLabel setFont:[UIFont fontWithName:@"28 Days Later" size:16*imageZoom]];
    [crystalLabel setFont:[UIFont fontWithName:@"28 Days Later" size:16*imageZoom]];
    [liquidCrystalLabel setFont:[UIFont fontWithName:@"28 Days Later" size:12*imageZoom]];
    boostButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:16*imageZoom];
    [boostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [boostButton setBackgroundImage:[UIImage imageNamed:@"FreezerControlOFF"] forState:UIControlStateNormal];
    amountOfTickets.text = [NSString stringWithFormat:@"Gold Bars:\n%i\n\n(Buy more)",(int)[GameSaveState sharedGameData].tickets];
    amountOfTickets.font = [UIFont fontWithName:@"28 Days Later" size:16*imageZoom];
    
    UIImageView *statsBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"statsWindow"]];
    statsBackground.frame = CGRectMake(645, 85, 310, 370);
    [scroller addSubview:statsBackground];
    
    UILabel *statsLabel = [[UILabel alloc]init];
    statsLabel.frame = CGRectMake(645, 85, 310, 30);
    statsLabel.textAlignment = NSTextAlignmentCenter;
    statsLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    statsLabel.text = @"...Game Stats...";
    [scroller addSubview:statsLabel];
    
    UIButton *easterEggButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [easterEggButton addTarget:self action:@selector(easterEggButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    easterEggButton.frame = CGRectMake(241, 184, 50, 30);
    [scroller addSubview:easterEggButton];
    
    totalTimeLabel = [[UILabel alloc]init];
    totalTimeLabel.frame = CGRectMake(650, 90, 310, 370-65*[GameSaveState sharedGameData].screenSize);
    totalTimeLabel.font = [UIFont fontWithName:@"28 Days Later" size:(16-3*[GameSaveState sharedGameData].screenSize)];
    totalTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    totalTimeLabel.numberOfLines = 30;
    [scroller addSubview:totalTimeLabel];
    [self showTotalTimePlayed];
    
    animationCrystal = [[UILabel alloc]init];
    animationCrystal.frame = CGRectMake(0, 0, 160, 50);
    animationCrystal.textColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    [self.view addSubview:animationCrystal];
    
    animationXp = [[UILabel alloc]init];
    animationXp.frame = CGRectMake(0, 0, 120, 50);
    [self.view addSubview:animationXp];
    
    [dangerClientButton addTarget:self action:@selector(dangerClientButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [dangerClientButton setTitle:@"60 sec" forState:UIControlStateNormal];
    dangerClientButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:16*imageZoom];
    dangerClientButton.hidden = YES;
    [dangerClientButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:dangerClientButton];
    
    purityLabel.frame = CGRectMake(230, 10, 90, 70);
    purityLabel.lineBreakMode = NSLineBreakByWordWrapping;
    purityLabel.numberOfLines = 2;
    purityLabel.textAlignment = NSTextAlignmentCenter;
    
    clientes = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        UIButton *cliente = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cliente setTag:i];
        [cliente addTarget:self action:@selector(clientButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cliente setFrame:CGRectMake(1700, 250, (100-20*[GameSaveState sharedGameData].screenSize)*clientZoom, (100-20*[GameSaveState sharedGameData].screenSize)*clientZoom)];
        [cliente setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ClientIcon%i",i]] forState:UIControlStateNormal];
        
        [scroller addSubview:cliente];
        [clientes addObject:cliente];
    }
    
    NSString *queColorDeCrystal = [NSString stringWithFormat:@"flavor%i",(int)[GameSaveState sharedGameData].currentCrystalColor-1];
    crystalImage.image = [UIImage imageNamed:queColorDeCrystal];
    
    for (int i=1; i<7; i++) {
        if ([GameSaveState sharedGameData].currentFreezers>3*(i-1)) {
            completeFreezers=i;
        }
    }
    freezerButtonArray = [[NSMutableArray alloc]init];
    freezerTimeLabelArray = [[NSMutableArray alloc]init];
    freezerImagesArray = [[NSMutableArray alloc]init];
    
    if (completeFreezers==1) {
        [boostButton setTitle:[NSString stringWithFormat:@"Boost Freezers for %imin! (1 Gold Bar)",(int)TIEMPO_BOOST] forState:UIControlStateNormal];
    }
    else
    {
        [boostButton setTitle:[NSString stringWithFormat:@"Boost Freezers for %imin! (%i Gold Bars)",(int)TIEMPO_BOOST,(int)completeFreezers] forState:UIControlStateNormal];
    }
    
    [self setupFreezerImages];
    [self setupfreezerTimers];
    
    [self refreshFreezerImage];
    [self updateFreezerButtonAndLabel];
    
    // Changes position of certain buttons and labels when device is an iphone 4
    if ([GameSaveState sharedGameData].screenSize==1)
    {
        shop.center = CGPointMake(360, 226-68);
        contracts.center = CGPointMake(1320, 474-88);
        lab.center = CGPointMake(130, 228-68);
        
        couch.center = CGPointMake(1080, 426-88);
        mesa.center = CGPointMake(1220, 520-88);
        computador.center = CGPointMake(472, 227-68);
        
        background.frame = CGRectMake(0, -68, 1600, 568);
        
        labButton.center = CGPointMake(48, 285-68);
        shopButton.center = CGPointMake(450, 226-68);
        contractsButton.center = CGPointMake(1325, 505-113);
        mapButton.frame = CGRectMake(0, 0, 176, 103);
        mapButton.center = CGPointMake(1329, 165-28);
        
        statsBackground.frame = CGRectMake(645, 85, 310, 370-68);
        
        easterEggButton.frame = CGRectMake(241, 184-68, 50, 30);
        
        boostButton.center = CGPointMake(388, 285-64);
        amountOfTickets.frame = CGRectMake(0, 0, 100, 100);
        buyMoreGoldButton.frame = CGRectMake(0, 0, 100, 100);
        amountOfTickets.center = CGPointMake(1120, 167-28);
        buyMoreGoldButton.center = CGPointMake(1120, 167-28);
    }
    
    else if ([GameSaveState sharedGameData].screenSize!=1&&[GameSaveState sharedGameData].screenSize!=0)
    {
        CGSize screenbounds = [[UIScreen mainScreen] bounds].size;
        CGFloat screendivided6 = (screenbounds.width-15)/6;
        
        background.frame = CGRectMake(0, 0, 1600, screenbounds.height);
        
        left.frame = CGRectMake(screendivided6-57, screenbounds.height-80, 50*imageZoom, 50*imageZoom);
        labIcon.frame = CGRectMake(screendivided6*2-57, screenbounds.height-80, 50*imageZoom, 50*imageZoom);
        shopIcon.frame = CGRectMake(screendivided6*3-57, screenbounds.height-80, 50*imageZoom, 50*imageZoom);
        pauseIcon.frame = CGRectMake(screendivided6*4-57, screenbounds.height-80, 50*imageZoom, 50*imageZoom);
        contractsIcon.frame = CGRectMake(screendivided6*5-57, screenbounds.height-80, 50*imageZoom, 50*imageZoom);
        rightIcon.frame = CGRectMake(screendivided6*6-57, screenbounds.height-80, 50*imageZoom, 50*imageZoom);
        
        progressView.frame = CGRectMake(10, 10, 70*imageZoom, 70*imageZoom);
        topPanelColor.frame = CGRectMake(screenbounds.width/2-75, 10, 150, 70);
        crystalImage.frame = CGRectMake(screenbounds.width-(70*imageZoom)-10, 10, 70*imageZoom, 70*imageZoom);
        
        levelLabel.frame = CGRectMake(0, 3, 70*imageZoom, 33*imageZoom);
        xpLabel.frame = CGRectMake(0, 27*imageZoom, 70*imageZoom, 23*imageZoom);
        xpNeededLabel.frame = CGRectMake(0, 38*imageZoom, 70*imageZoom, 22*imageZoom);
        
        purityLabel.frame = CGRectMake(screenbounds.width-90*imageZoom, 0, 90*imageZoom, 90*imageZoom);
        
        moneyLabel.frame = CGRectMake(screenbounds.width/2-150*imageZoom/2, 6, 150*imageZoom, 30*imageZoom);
        liquidCrystalLabel.frame = CGRectMake(screenbounds.width/2-150*imageZoom/2, 25, 150*imageZoom, 30*imageZoom);
        crystalLabel.frame = CGRectMake(screenbounds.width/2-150*imageZoom/2, 45, 150*imageZoom, 30*imageZoom);
        
        couch.frame = CGRectMake(580, screenbounds.height-415, 1043, 299*imageZoom);
        mesa.frame = CGRectMake(720, screenbounds.height-95*imageZoom, 650*imageZoom, 95*imageZoom);
        
        labButton.frame = CGRectMake(0, 0, 68, 344*imageZoom);
        shopButton.frame = CGRectMake(0, 0, 233, 69*imageZoom);
        contractsButton.frame = CGRectMake(0, 0, 336, 59*imageZoom);
        
        if ([GameSaveState sharedGameData].screenSize==2)
        {
            labButton.center = CGPointMake(40, screenbounds.height-230*imageZoom);
            shopButton.center = CGPointMake(433, screenbounds.height-300*imageZoom);
            contractsButton.center = CGPointMake(1220, screenbounds.height-110*imageZoom);
            
            boostButton.frame = CGRectMake(0, 0, 300*imageZoom, 40);
            boostButton.center = CGPointMake(380, 338);
            
            shop.center = CGPointMake(347, 260);
            contracts.frame = CGRectMake(0, 0, 247*imageZoom, 59*imageZoom);
            contracts.center = CGPointMake(1226, 535);
            
            computador.frame = CGRectMake(370, screenbounds.height-455, 116*imageZoom, 66*imageZoom);
            easterEggButton.frame = CGRectMake(241, 225, 50, 30);
            
            totalTimeLabel.font = [UIFont fontWithName:@"28 Days Later" size:(16-3*[GameSaveState sharedGameData].screenSize)*(0.4+imageZoom)];
            
            totalTimeLabel.frame = CGRectMake(650, 155, 310, (370-65*[GameSaveState sharedGameData].screenSize)*(0.2+imageZoom));
            
            statsBackground.frame = CGRectMake(645, 115, 310, (370-68)*(imageZoom));
        }
        else if ([GameSaveState sharedGameData].screenSize==3)
        {
            labButton.center = CGPointMake(40, screenbounds.height-250*imageZoom);
            shopButton.center = CGPointMake(433, screenbounds.height-330*imageZoom);
            contractsButton.center = CGPointMake(1220, screenbounds.height-110*imageZoom);
            
            boostButton.frame = CGRectMake(0, 0, 300*imageZoom, 40);
            boostButton.center = CGPointMake(375, 368);
            
            shop.center = CGPointMake(347, 295);
            contracts.frame = CGRectMake(0, 0, 247*imageZoom, 59*imageZoom);
            contracts.center = CGPointMake(1226, 595);
            
            computador.frame = CGRectMake(370, screenbounds.height-490, 116*imageZoom, 66*imageZoom);
            easterEggButton.frame = CGRectMake(241, 250, 50, 30);
            
            totalTimeLabel.font = [UIFont fontWithName:@"28 Days Later" size:(16-3*[GameSaveState sharedGameData].screenSize)*(1.3+imageZoom)];
            
            totalTimeLabel.frame = CGRectMake(650, 160, 310, (370-65*[GameSaveState sharedGameData].screenSize)*(1+imageZoom));
            
            statsBackground.frame = CGRectMake(645, 115, 310, (370-68)*(0.15+imageZoom));
        }
        
        availableCustomer.frame = CGRectMake(0, 0, 50*imageZoom, 50*imageZoom);
        availableCustomer.center = CGPointMake(screenbounds.width-40, screenbounds.height-120);
        
        dangerClientButton.frame = CGRectMake(0, 0, 70*imageZoom, 70*imageZoom);
        dangerClientButton.center = CGPointMake(screenbounds.width/2, screenbounds.height-130);
        
        statsLabel.frame = CGRectMake(645, 125, 310, 30);
    }
    
    randomPresentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [randomPresentButton addTarget:self action:@selector(randomPresentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    randomPresentButton.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    randomPresentButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    randomPresentButton.titleLabel.numberOfLines = 3;
    randomPresentButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:36*imageZoom];
    [randomPresentButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    [randomPresentButton setBackgroundColor:[UIColor blackColor]];
    randomPresentButton.alpha = 0.8;
    
    [self.view addSubview:randomPresentButton];
    
    NSString *cualImagenParaTutorial =@"";
    
    if ([GameSaveState sharedGameData].screenSize==1)
    {
        cualImagenParaTutorial =@"Iphone4Tutorial";
    }
    else if ([GameSaveState sharedGameData].screenSize==0)
    {
        cualImagenParaTutorial =@"Iphone5Tutorial";
    }
    else if ([GameSaveState sharedGameData].screenSize==2)
    {
        cualImagenParaTutorial =@"Iphone6Tutorial";
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        cualImagenParaTutorial =@"Iphone6PlusTutorial";
    }
    
    tutorialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tutorialButton addTarget:self action:@selector(tutorialButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    tutorialButton.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    [tutorialButton setBackgroundImage:[UIImage imageNamed:cualImagenParaTutorial] forState:UIControlStateNormal];
    tutorialButton.hidden = YES;
    [self.view addSubview:tutorialButton];
}

/** Starts the game by asigning the game variables or loading old ones from NSUserDefaults
 */
- (void)startGamePlay
{
    for (int i=0; i<10; i++)
    {
        NSInteger cuanto = [[ClientsAtHome sharedClientData].valoresDangerOriginal[i] intValue]/10;
        NSInteger reducido = [[ClientsAtHome sharedClientData].valoresDangerOriginal[i] intValue]-(cuanto*[GameSaveState sharedGameData].currentSpy);
        [[ClientsAtHome sharedClientData].valoresDangerEnRegion replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:reducido]];
    }
    
    levelXp = [NSArray arrayWithObjects:
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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstView"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstView"];
        tutorialButton.hidden = NO;
        
        UIColor *tintColor = [UIColor colorWithRed:0.404 green:0.835 blue:0.969 alpha:1];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"currentProgressColor"];
        
        animationXp.textColor = tintColor;
        
        //Sound
        soundOnOrOff = 0;
        
        [[NSUserDefaults standardUserDefaults] setInteger:soundOnOrOff forKey:@"soundOnOrOff"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentShopList"];
        
        [self asignarValoresDeHome];
        [self showTotalTimePlayed];
    }
    //Si NO es la primera vez
    else
    {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentProgressColor"];
        UIColor *tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        
        animationXp.textColor = tintColor;
        
        if ([ClientsAtHome sharedClientData].dangerClientOnOrOff==1) {
            dangerClientButton.hidden = NO;
        }
        
        [self asignarValoresDeHome];
        [self showTotalTimePlayed];
        
        [self revisarSiHayClientes];
    }
    [self showRandomPresent];
}

/** Refreshes the labels on the home screen
 */
- (void)asignarValoresDeHome
{
    NSInteger level = [GameSaveState sharedGameData].level;
    NSInteger xp = [GameSaveState sharedGameData].xp;
    NSInteger amountXpForLevel;
    if (level<=20) {
        amountXpForLevel = [[levelXp objectAtIndex:level-1]integerValue];
    }
    else if (level>20)
    {
        amountXpForLevel = 55000+(5000+1000*(level-21))*(level-21);
    }
    [xpLabel setText:[NSString stringWithFormat:@"%li",(long)xp]];
    [xpNeededLabel setText:[NSString stringWithFormat:@"%li",(long)amountXpForLevel]];
    float amountOfProgress = (double)xp/amountXpForLevel;
    [progressView setProgress: amountOfProgress];
    [levelLabel setText:[NSString stringWithFormat:@"%i",(int)level]];
    
    NSInteger moneyPrue = [GameSaveState sharedGameData].money;
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *results = [formatter stringFromNumber:[NSNumber numberWithInteger:moneyPrue]];
    
    if (moneyPrue==2000000000) {
        [moneyLabel setText:[NSString stringWithFormat:@"Money: FULL!!"]];
    }
    else
    {
        [moneyLabel setText:[NSString stringWithFormat:@"Money: %@",results]];
    }
    
    float purityDecimal = (float)[GameSaveState sharedGameData].purity/100;
    
    [purityLabel setText:[NSString stringWithFormat:@"Sweetness:\n%1.1f%%",purityDecimal]];
    [crystalLabel setText:[NSString stringWithFormat:@"Candy: %li",(long)[GameSaveState sharedGameData].crystal]];
    [liquidCrystalLabel setText:[NSString stringWithFormat:@"Soft Candy: %li",(long)[GameSaveState sharedGameData].liquidCrystal]];
}

/** Shows a random present every certain time
 */
-(void)showRandomPresent
{
    int hours = 8;
    NSDate *pastDate = [ClientsAtHome sharedClientData].appLaunchDate;
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secondsBetween = [currentDate timeIntervalSinceDate:pastDate];
    NSLog(@"Seconds:%i Needs:%i",(int)secondsBetween,60*60*hours);
    if (secondsBetween>=60*60*hours) {
        [ClientsAtHome sharedClientData].appLaunchDate = currentDate;
        [ClientsAtHome sharedClientData].randomPresent = 1;
    }
    
    if ([ClientsAtHome sharedClientData].randomPresent==0) {
        randomPresentButton.hidden = YES;
    }
    else
    {
        randomPresentButton.hidden = NO;
        NSArray *presents = [NSArray arrayWithObjects:
                             @"Random Present!\n\n+2 Liquid Candys!",
                             @"Random Present!\n\n+10 Candys!",
                             @"Random Present!\n\n+1 Gold Bar!",
                             @"Random Present!\n\n+6 Sugar Cubes!",
                             @"Random Present!\n\n+1 Red Flavor Cube",
                             @"Random Present!\n\n+1 Silver Sugar",
                             @"Random Present!\n\n+600 cash!",
                             nil];
        cualRandomPresent = arc4random_uniform((int)presents.count);
        [randomPresentButton setTitle:[NSString stringWithFormat:@"%@",presents[cualRandomPresent]] forState:UIControlStateNormal];
    }
}

/** Refreshes all of the current in game stats on the home view
 */
- (void)showTotalTimePlayed
{
    NSInteger totalTime = [GameSaveState sharedGameData].totalTime;
    [[GameCenterHelper sharedGC] playTimeAchievements];
    
    int days = floor(totalTime/43200);
    int hours = floor((totalTime-days*43200)/3600);
    int minutes = floor((totalTime - hours*3600-days*43200)/60);
    
    NSString *time;
    
    if (days!=0)
    {
        time = [NSString stringWithFormat:@"%i days %i hr %i min",days,hours,minutes];
    }
    else if (hours!=0)
    {
        time = [NSString stringWithFormat:@"%i hr %i min",hours,minutes];
    }
    else
    {
        time = [NSString stringWithFormat:@"%i min",minutes];
    }
    
    NSInteger totalCustomersAttended = [GameSaveState sharedGameData].totalCustomersAttended;
    NSInteger totalCustomersIgnored = [GameSaveState sharedGameData].totalCustomersIgnored;
    NSInteger totalCrystalSold = [GameSaveState sharedGameData].totalCrystalSold;
    NSInteger totalCrystalMade = [GameSaveState sharedGameData].totalCrystalMade;
    NSInteger totalLiquidCrystal = [GameSaveState sharedGameData].totalLiquidCrystal;
    NSInteger totalCustomersNotAttended = [GameSaveState sharedGameData].totalCustomersNotAttended;
    NSInteger totalRedPowder = [GameSaveState sharedGameData].totalRedPowder;
    NSInteger totalWhitePowder = [GameSaveState sharedGameData].totalWhitePowder;
    NSInteger totalGreyPowder = [GameSaveState sharedGameData].totalGreyPowder;
    NSInteger totalPills = [GameSaveState sharedGameData].totalPills;
    NSInteger totalMatchboxes = [GameSaveState sharedGameData].totalMatchboxes;
    NSInteger totalAluminum = [GameSaveState sharedGameData].totalAluminum;
    NSInteger totalXpGained = [GameSaveState sharedGameData].totalXpGained;
    NSInteger totalMoneyMade = [GameSaveState sharedGameData].totalMoneyMade;
    
    totalTimeLabel.text = [NSString stringWithFormat:@"Total time played: %@\n\nTotal Money Made: %i\nTotal Xp Gained: %i\n\nCustomers attended: %i\nCustomers NOT attended: %i\nCustomers Ignored: %i\n\nCandy Sold: %i\n\nCandy made: %i\nSoft Candy made: %i\nRed Powder made: %i\nWhite Powder made: %i\nGrey Powder made: %i\n\nSugar Cubes bought: %i\nRed Flavor Cubes bought: %i\nSilver Sugar bought: %i",time,(int)totalMoneyMade,(int)totalXpGained,(int)totalCustomersAttended,(int)totalCustomersNotAttended,(int)totalCustomersIgnored,(int)totalCrystalSold,(int)totalCrystalMade,(int)totalLiquidCrystal,(int)totalRedPowder,(int)totalWhitePowder,(int)totalGreyPowder,(int)totalPills,(int)totalMatchboxes,(int)totalAluminum];
}

/** Places the images of the freezers on the home screen
 */
- (void)setupFreezerImages
{
    int screenSize = (int)[GameSaveState sharedGameData].screenSize;
    
    NSArray *xCenter = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:150],
                        [NSNumber numberWithInt:230],
                        [NSNumber numberWithInt:245],
                        [NSNumber numberWithInt:420],
                        [NSNumber numberWithInt:405],
                        [NSNumber numberWithInt:565]
                        , nil];
    
    NSArray *yCenter = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:437-68*screenSize+screenFreezerHeight],
                        [NSNumber numberWithInt:435-68*screenSize+screenFreezerHeight],
                        [NSNumber numberWithInt:434-68*screenSize+screenFreezerHeight],
                        [NSNumber numberWithInt:433-68*screenSize+screenFreezerHeight],
                        [NSNumber numberWithInt:434-68*screenSize+screenFreezerHeight],
                        [NSNumber numberWithInt:433-68*screenSize+screenFreezerHeight]
                        , nil];
    
    NSArray *widthFreezer = [NSArray arrayWithObjects:[NSNumber numberWithDouble:144.5],
                              [NSNumber numberWithDouble:131],
                              [NSNumber numberWithDouble:261.5],
                              [NSNumber numberWithDouble:146],
                              [NSNumber numberWithDouble:279.5],
                              [NSNumber numberWithDouble:123.5],
                             nil];
    
    NSArray *heightFreezer = [NSArray arrayWithObjects:[NSNumber numberWithDouble:268.5*freezerZoom],
                              [NSNumber numberWithDouble:271.5*freezerZoom],
                              [NSNumber numberWithDouble:271.5*freezerZoom],
                              [NSNumber numberWithDouble:274.5*freezerZoom],
                              [NSNumber numberWithDouble:271.5*freezerZoom],
                              [NSNumber numberWithDouble:273*freezerZoom],
                              nil];
    
    for (int i=0; i<6; i++)
    {
        UIImageView *freezer = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%iOpenFreezer",i+1]]];
        freezer.frame = CGRectMake(0, 0, [[widthFreezer objectAtIndex:i] doubleValue], [[heightFreezer objectAtIndex:i] doubleValue]);
        NSString *cualFreezer;
        if ([[ClientsAtHome sharedClientData].completeFreezersOnOrOff[i] isEqualToString:@"NO"]) {
            cualFreezer = [NSString stringWithFormat:@"%iOpenFreezer",i+1];
        }
        else
        {
            cualFreezer = [NSString stringWithFormat:@"%iClosedFreezer",i+1];
        }
        [freezer setImage:[UIImage imageNamed:cualFreezer]];
        freezer.center = CGPointMake([[xCenter objectAtIndex:i] intValue],[[yCenter objectAtIndex:i]intValue]);
        freezer.hidden = YES;
        [freezerImagesArray addObject:freezer];
        [scroller addSubview:freezer];
    }
}

/** Places the freezer time labels on the home screen
 */
- (void)setupfreezerTimers
{
    int screenSize = (int)[GameSaveState sharedGameData].screenSize;
    
    for (int i=0; i<18; i++) {
        
        int x=0;
        int y=0;
        int adjustment = 0;
        if ([GameSaveState sharedGameData].screenSize==2){adjustment=1;}
        else if ([GameSaveState sharedGameData].screenSize==3){adjustment=1;}
        
        if (i<=2) {
            x = 80;
            y = 340-68*screenSize+screenFreezerHeight-(30*adjustment);
        }
        else if (i>2&&i<=5)
        {
            x = 170;
            y = 220-68*screenSize+screenFreezerHeight-(90*adjustment);
        }
        else if (i>5&&i<=8)
        {
            x = 260;
            y = 100-68*screenSize+screenFreezerHeight-(150*adjustment);
        }
        else if (i>8&&i<=11)
        {
            x = 350;
            y = -20-68*screenSize+screenFreezerHeight-(210*adjustment);
        }
        else if (i>11&&i<=14)
        {
            x = 440;
            y = -140-68*screenSize+screenFreezerHeight-(270*adjustment);
        }
        else
        {
            x = 530;
            y = -260-68*screenSize+screenFreezerHeight-(330*adjustment);
        }
        
        UIButton *timer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        timer.tag = i;
        [timer setTitle:@"Freeze!" forState:UIControlStateNormal];
        timer.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:16*imageZoom];
        timer.tintColor = [UIColor whiteColor];
        [timer addTarget:self action:@selector(freezeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        timer.frame = CGRectMake(x, y+(40+(20*adjustment))*i, 100, 30);
        timer.hidden = YES;
        [freezerButtonArray addObject:timer];
        [scroller addSubview:timer];
        
        UILabel *totalTime = [[UILabel alloc] init];
        totalTime.text = @"5min";
        totalTime.textAlignment = NSTextAlignmentCenter;
        totalTime.font = [UIFont fontWithName:@"28 Days Later" size:16*imageZoom];
        totalTime.textColor = [UIColor whiteColor];
        totalTime.frame = CGRectMake(x, y+(40+(20*adjustment))*i, 100, 30);
        totalTime.hidden = YES;
        [freezerTimeLabelArray addObject:totalTime];
        [scroller addSubview:totalTime];
    }
}

/** Updates the freeser button and labels on the home screen
 */
- (void)updateFreezerButtonAndLabel
{
    for (int i=0; i<18; i++)
    {
        UIButton *button = freezerButtonArray[i];
        UILabel *label = freezerTimeLabelArray[i];
        
        if (i<[GameSaveState sharedGameData].currentFreezers) {
            if ([[ClientsAtHome sharedClientData].individualTraysOnOrOff[i] isEqualToString:@"APAGADO"])
            {
                label.hidden = YES;
                button.hidden = NO;
            }
            else
            {
                label.hidden = NO;
                button.hidden = YES;
                
                NSDate *presentDate = [NSDate date];
                NSDate *pastDate = [ClientsAtHome sharedClientData].individualTrayDates[i];
                
                NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:pastDate];
                int time = TIEMPO_FREEZER-secondsBetween;
                
                NSString *tiempo = [self changeToHrMinSec:time];
                
                if (time<=0) {
                    tiempo = @"0sec";
                }
                
                label.text = tiempo;
                
            }
        }
        else
        {
            label.hidden = YES;
            button.hidden = YES;
        }
    }
}

/** Refreshes the freezer image based on if it is on or off
 */
- (void)refreshFreezerImage
{
    for (int i=0; i<6; i++)
    {
        UIImageView *freezer = freezerImagesArray[i];
        if (i<completeFreezers) {
            freezer.hidden = NO;
            NSString *cualFreezer;
            
            if ([[ClientsAtHome sharedClientData].completeFreezersOnOrOff[i] isEqualToString:@"NO"]) {
                cualFreezer = [NSString stringWithFormat:@"%iOpenFreezer",i+1];
            }
            else
            {
                cualFreezer = [NSString stringWithFormat:@"%iClosedFreezer",i+1];
            }
            
            [freezer setImage:[UIImage imageNamed:cualFreezer]];
        }
        else
        {
            freezer.hidden = YES;
        }
    }
}

/** Changes the state of the freezer based on the trays that are freezing inside of it
 */
- (void)changeFreezerCompletion:(NSInteger)cualBoton
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
    NSInteger cual = abs((int)cualBoton)-1;
    
    for (int i=0; i<18; i=i+3)
    {
        if (quitarOPoner==1) {
            if (cual==i||cual==i+1||cual==i+2)
            {
                [[ClientsAtHome sharedClientData].completeFreezersOnOrOff replaceObjectAtIndex:i/3 withObject:@"YES"];
            }
        }
        else
        {
            if ([[ClientsAtHome sharedClientData].individualTraysOnOrOff[i]isEqualToString:@"APAGADO"]&&[[ClientsAtHome sharedClientData].individualTraysOnOrOff[i+1]isEqualToString:@"APAGADO"]&&[[ClientsAtHome sharedClientData].individualTraysOnOrOff[i+2]isEqualToString:@"APAGADO"])
            {
                [[ClientsAtHome sharedClientData].completeFreezersOnOrOff replaceObjectAtIndex:i/3 withObject:@"NO"];
            }
        }
        
    }
    [self refreshFreezerImage];
}

/** Runs on a timer that changes all of the time labels on the home view.
 */
- (void)cookingSeconds
{
    for (int i=0; i<18; i++)
    {
        if ([[ClientsAtHome sharedClientData].individualTraysOnOrOff[i] isEqualToString:@"PRENDIDO"])
        {
            NSDate *presentDate = [NSDate date];
            NSDate *pastDate = [ClientsAtHome sharedClientData].individualTrayDates[i];
            
            NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:pastDate];
            int time = TIEMPO_FREEZER-(secondsBetween*(1+(3*[ClientsAtHome sharedClientData].boostActivated)));
            
            if (time>=0) {
                NSString *tiempo = [self changeToHrMinSec:time];
                
                UILabel *cual = freezerTimeLabelArray[i];
                cual.text = tiempo;
            }
            else
            {
                [self showTotalTimePlayed];
                
                NSInteger cuantoCrystal = arc4random_uniform(6)+9+[GameSaveState sharedGameData].level;
                NSLog(@"fridge hizo: %i",(int)cuantoCrystal);
                
                [GameSaveState sharedGameData].crystal+=cuantoCrystal;
                [GameSaveState sharedGameData].totalCrystalMade+=cuantoCrystal;
                [[GameCenterHelper sharedGC] makeCrystalAchievements];
                [[GameSaveState sharedGameData] changeXp:2*[GameSaveState sharedGameData].level];
                [GameSaveState sharedGameData].totalXpGained+=2*[GameSaveState sharedGameData].level;
                
                [[SoundHelper sharedSoundInstance] playSound:5];
                [self animateChange:(int)cuantoCrystal cual:1];
                [self animateChange:2*(int)[GameSaveState sharedGameData].level cual:2];
                
                [crystalLabel setText:[NSString stringWithFormat:@"Candy: %li",(long)[GameSaveState sharedGameData].crystal]];
                
                [[ClientsAtHome sharedClientData].individualTraysOnOrOff replaceObjectAtIndex:i withObject:@"APAGADO"];
                [[ClientsAtHome sharedClientData].individualTrayDates replaceObjectAtIndex:i withObject:@"NO"];
                
                UIButton *button = freezerButtonArray[i];
                UILabel *label = freezerTimeLabelArray[i];
                
                label.hidden = YES;
                button.hidden = NO;
                
                [self changeFreezerCompletion:-(i+1)];
                
                [self asignarValoresDeHome];
                [self showTotalTimePlayed];
                
            }
        }
    }
    
    if ([ClientsAtHome sharedClientData].boostActivated==1) {
        [boostButton setBackgroundImage:[UIImage imageNamed:@"FreezerControlON"] forState:UIControlStateNormal];
        [boostButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        NSDate *presentDate = [NSDate date];
        NSDate *pastDate = [ClientsAtHome sharedClientData].boostLaunchDate;
        
        NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:pastDate];
        int time = (TIEMPO_BOOST*60)-secondsBetween;
        if (time>=0&&time<=TIEMPO_BOOST*60)
        {
            NSString *tiempo = [self changeToHrMinSec:time];
            [boostButton setTitle:tiempo forState:UIControlStateNormal];
        }
        else
        {
            [boostButton setBackgroundImage:[UIImage imageNamed:@"FreezerControlOFF"] forState:UIControlStateNormal];
            [boostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [ClientsAtHome sharedClientData].boostActivated=0;
            if (completeFreezers==1) {
                [boostButton setTitle:[NSString stringWithFormat:@"Boost Freezers for %imin! (1 Gold Bar)",(int)TIEMPO_BOOST] forState:UIControlStateNormal];
            }
            else
            {
                [boostButton setTitle:[NSString stringWithFormat:@"Boost Freezers for %imin! (%i Gold Bars)",(int)TIEMPO_BOOST,(int)completeFreezers] forState:UIControlStateNormal];
            }
        }
        
    }
}

/** Runs on a timer that changes the time on the danger label on the home view
 */
- (void)dangerSeconds
{
    NSInteger tiempoTotal = [GameSaveState sharedGameData].totalTime;
    
    if (tiempoTotal%(300-18*[GameSaveState sharedGameData].currentLawyer)==0&&
        [ClientsAtHome sharedClientData].dangerClientOnOrOff==0&&
        [GameSaveState sharedGameData].level>=5&&
        tiempoTotal>0)
    {
        int j = (int)arc4random_uniform(PROBA_POLICIA+(int)[GameSaveState sharedGameData].currentLawyer);
        NSLog(@"Sec Total:%i Min: %i Num Aleatorio: %i",(int)tiempoTotal,(int)tiempoTotal/60,j);
        if (j==[GameSaveState sharedGameData].currentLawyer) {
            
            [[SoundHelper sharedSoundInstance] playSound:8];
            [ClientsAtHome sharedClientData].dangerStartDate= [NSDate date];
            [ClientsAtHome sharedClientData].dangerClientOnOrOff=1;
            dangerClientButton.hidden = NO;
            
            [self randomDanger];
        }
    }
    
    if ([ClientsAtHome sharedClientData].dangerClientOnOrOff==1)
    {
        NSDate *presentDate = [NSDate date];
        
        NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:[ClientsAtHome sharedClientData].dangerStartDate];
        int time = 60-secondsBetween;
        
        if (time>5&&dangerChangerValue!=4) {
            [dangerClientButton setTitle:[NSString stringWithFormat:@"%i sec",time] forState:UIControlStateNormal];
            dangerChangerValue++;
        }
        else if (time>5&&dangerChangerValue==4)
        {
            [dangerClientButton setTitle:@"Press!" forState:UIControlStateNormal];
            dangerChangerValue=0;
        }
        else if (time<=5&&time>=0)
        {
            [[SoundHelper sharedSoundInstance] playSound:7];
            [dangerClientButton setTitle:[NSString stringWithFormat:@"Press! %i",time] forState:UIControlStateNormal];
            [dangerClientButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            dangerChangerValue=0;
        }
        else
        {
            dangerChangerValue=0;
            [dangerClientButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
            
            NSString *storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            DangerClientViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"dangerClientVC"];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.pressed=1;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

/** Selects a random danger to present to the user
 */
- (void)randomDanger
{
    NSMutableArray *possibleDangers = [[NSMutableArray alloc]init];
    [possibleDangers addObject:@0];
    [possibleDangers addObject:@1];
    [possibleDangers addObject:@2];
    [possibleDangers addObject:@3];
    [possibleDangers addObject:@4];
    [possibleDangers addObject:@5];
    [possibleDangers addObject:@6];
    [possibleDangers addObject:@7];
    [possibleDangers addObject:@8];
    [possibleDangers addObject:@9];
    
    if ([GameSaveState sharedGameData].currentLawyer==0) {
        [possibleDangers removeObject:@0];
    }
    if ([GameSaveState sharedGameData].currentSeller==0)
    {
        [possibleDangers removeObject:@1];
    }
    if ([GameSaveState sharedGameData].currentBully==0)
    {
        [possibleDangers removeObject:@2];
    }
    if ([GameSaveState sharedGameData].currentSpy==0)
    {
        [possibleDangers removeObject:@3];
    }
    if ([GameSaveState sharedGameData].crystal==0) {
        [possibleDangers removeObject:@6];
    }
    if ([GameSaveState sharedGameData].liquidCrystal==0) {
        [possibleDangers removeObject:@8];
    }
    if ([GameSaveState sharedGameData].currentFreezers==1)
    {
        [possibleDangers removeObject:@9];
    }
    
    NSInteger which = arc4random_uniform((int)possibleDangers.count);
    int selectedDanger = [[possibleDangers objectAtIndex:which] intValue];
    
    [ClientsAtHome sharedClientData].whichDanger = selectedDanger;
}

- (void)automaticSave
{
    [[GameSaveState sharedGameData] saveGame];
    [[ClientsAtHome sharedClientData] saveGame];
}

/** Runs on a timer and shows a random customer on the home view
 */
- (void)randomCustomer
{
    if ([GameSaveState sharedGameData].whichCustomerToShow!=0) {
        [self mostrarClientes:[GameSaveState sharedGameData].whichCustomerToShow];
        [GameSaveState sharedGameData].whichCustomerToShow=0;
    }
}

/** Shows the customers on the home view
 */
- (void)mostrarClientes:(NSInteger)cualCliente
{
    if (scroller.contentOffset.x<=1150) {
        availableCustomer.hidden = NO;
    }
    [[SoundHelper sharedSoundInstance] playSound:1];
    
    int cualZone = [[ClientsAtHome sharedClientData].infoClientes[cualCliente]intValue];
    int altura = (int)([ClientsAtHome sharedClientData].alturaZone+(100-20*[GameSaveState sharedGameData].screenSize)*cualZone+screenClientHeight*cualZone+screenClient);
    
    UIButton *cualButtonDeCliente = [clientes objectAtIndex:cualCliente];
    cualButtonDeCliente.center = CGPointMake(1700, altura);
    
    [UIView animateWithDuration:0.75 animations:^{cualButtonDeCliente.center=CGPointMake(1550, altura);}];
    int duracionCliente = arc4random_uniform(5)+15;
    [self performSelector:@selector(quitarCliente:) withObject:[NSNumber numberWithInteger:cualCliente] afterDelay:duracionCliente];
}

/** Checks to see if there are customers on screen
 */
- (void)revisarSiHayClientes
{
    for (int i=0; i<10; i++) {
        int clientePrendido = [[ClientsAtHome sharedClientData].infoClientes[i]intValue];
        if (clientePrendido!=123)
        {
            if (scroller.contentOffset.x<=1150) {
                availableCustomer.hidden = NO;
            }
            
            int cualZone = [[ClientsAtHome sharedClientData].infoClientes[i]intValue];
            int altura = (int)([ClientsAtHome sharedClientData].alturaZone+(100-20*[GameSaveState sharedGameData].screenSize)*cualZone+screenClientHeight*cualZone+screenClient);
            
            UIButton *cualCliente = [clientes objectAtIndex:i];
            cualCliente.center = CGPointMake(1550, altura);
            
            int duracionCliente = arc4random_uniform(5)+15;
            
            [self performSelector:@selector(quitarCliente:) withObject:[NSNumber numberWithInt:i] afterDelay:duracionCliente];
        }
    }
}

/** Checks to see if there are customers on screen when unwinding from other views
 */
- (void)revisarSiHayClientesActivos
{
    for (int i=0; i<10; i++) {
        int clientePrendido = [[ClientsAtHome sharedClientData].infoClientes[i]intValue];
        if (clientePrendido!=123)
        {
            if (scroller.contentOffset.x<=1150) {
                availableCustomer.hidden = NO;
            }
            
            int cualZone = [[ClientsAtHome sharedClientData].infoClientes[i]intValue];
            int altura = (int)([ClientsAtHome sharedClientData].alturaZone+(100-20*[GameSaveState sharedGameData].screenSize)*cualZone+screenClientHeight*cualZone+screenClient);
            
            UIButton *cualCliente = [clientes objectAtIndex:i];
            cualCliente.center = CGPointMake(1550, altura);
            
            int duracionCliente = arc4random_uniform(5)+10;
            [self performSelector:@selector(quitarCliente:) withObject:[NSNumber numberWithInt:i] afterDelay:duracionCliente];
        }
        else if (clientePrendido==123)
        {
            UIButton *cualButtonDeCliente = [clientes objectAtIndex:i];
            cualButtonDeCliente.center=CGPointMake(1700, 250);
        }
    }
    if ([ClientsAtHome sharedClientData].dangerClientOnOrOff==0) {
        dangerClientButton.hidden = YES;
    }
}

/** Removes a customer from the home view
 */
- (void)quitarCliente:(NSNumber*)sender
{
    [GameSaveState sharedGameData].totalCustomersIgnored++;
    [[GameCenterHelper sharedGC] ignoreCustomerAchievements];
    [self showTotalTimePlayed];
    
    int cualCliente = [sender intValue];
    int cualZone = [[[ClientsAtHome sharedClientData].infoClientes objectAtIndex:cualCliente] intValue];
    int altura = (int)([ClientsAtHome sharedClientData].alturaZone+(100-20*[GameSaveState sharedGameData].screenSize)*cualZone+screenClientHeight*cualZone+screenClient);
    
    UIButton *cualButtonDeCliente = [clientes objectAtIndex:cualCliente];
    [UIView animateWithDuration:0.75 animations:^{cualButtonDeCliente.center=CGPointMake(1700, altura);}];
    [self performSelector:@selector(quitarInfoCliente:) withObject:sender afterDelay:0.75];
}

/** Removes the customers info from arrays after it has already been removed from screen
 */
- (void)quitarInfoCliente:(NSNumber*)sender
{
    int cualCliente = [sender intValue];
    int cualZone = [[[ClientsAtHome sharedClientData].infoClientes objectAtIndex:cualCliente] intValue];
    
    [[ClientsAtHome sharedClientData].infoClientes replaceObjectAtIndex:cualCliente withObject:@123];
    [[ClientsAtHome sharedClientData].infoZone replaceObjectAtIndex:cualZone withObject:@123];
}

/** Shows the clients view controller when there pressed on
 */
- (void)clientButtonPressed:(UIButton *)sender
{
    NSInteger cual = sender.tag;
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    ClientViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"clientVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.cual=cual;
    [self presentViewController:vc animated:YES completion:nil];
}

/** Starts a freezer in the home view
 */
- (void)freezeButtonPressed:(UIButton *)sender
{
    if ([GameSaveState sharedGameData].liquidCrystal>=1) {
        
        [[SoundHelper sharedSoundInstance] playSound:3];
        
        [GameSaveState sharedGameData].liquidCrystal--;
        [liquidCrystalLabel setText:[NSString stringWithFormat:@"Soft Candy: %li",(long)[GameSaveState sharedGameData].liquidCrystal]];
        
        [[ClientsAtHome sharedClientData].individualTraysOnOrOff replaceObjectAtIndex:sender.tag withObject:@"PRENDIDO"];
        [[ClientsAtHome sharedClientData].individualTrayDates replaceObjectAtIndex:sender.tag withObject:[NSDate date]];
        
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
        [[SoundHelper sharedSoundInstance] playSound:9];
        liquidCrystalLabel.font = [UIFont fontWithName:@"28 Days Later" size:16*imageZoom];
        liquidCrystalLabel.textColor = [UIColor redColor];
        
        [self performSelector:@selector(reverseAnimationLiquidCrystal) withObject:nil afterDelay:0.5];
    }
}
- (void)reverseAnimationLiquidCrystal
{
    liquidCrystalLabel.font = [UIFont fontWithName:@"28 Days Later" size:12*imageZoom];
    liquidCrystalLabel.textColor = [UIColor whiteColor];
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
    CGSize screenbounds = [[UIScreen mainScreen] bounds].size;
    
    int randomX = (screenbounds.width/2-100)+arc4random_uniform(200);
    //int randomX = arc4random_uniform(170)+75;
    int randomY = arc4random_uniform(100)+350;
    
    UILabel *animation;
    
    if (cualLabel==1) {
        animation = animationCrystal;
        animation.text = [NSString stringWithFormat:@"+%i Candy",cuanto];
    }
    else
    {
        animation = animationXp;
        animation.text = [NSString stringWithFormat:@"+%i Xp",cuanto];
    }
    
    animation.textAlignment = NSTextAlignmentCenter;
    animation.font = [UIFont fontWithName:@"28 Days Later" size:30*imageZoom];
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
    [[SoundHelper sharedSoundInstance] playSound:2];
}

- (IBAction)shopButton:(id)sender
{
    [[SoundHelper sharedSoundInstance] playSound:4];
}

- (IBAction)labButton:(id)sender
{
    [[SoundHelper sharedSoundInstance] playSound:6];
}

- (IBAction)pauseButton:(id)sender
{
    [[GameCenterHelper sharedGC] checkAllAchievements];
}

- (IBAction)contractsViewButton:(id)sender
{
    [[SoundHelper sharedSoundInstance] playSound:2];
    [[NSUserDefaults standardUserDefaults]setInteger:1170 forKey:@"LastPosition"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ContractsVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)labViewButton:(id)sender
{
    [[SoundHelper sharedSoundInstance] playSound:6];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"LastPosition"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"labVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)shopViewButton:(id)sender
{
    [[SoundHelper sharedSoundInstance] playSound:4];
    [[NSUserDefaults standardUserDefaults]setInteger:250 forKey:@"LastPosition"];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"shopVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)boostButtonPressed:(UIButton *)sender
{
    if ([ClientsAtHome sharedClientData].boostActivated==0&&[GameSaveState sharedGameData].tickets>=completeFreezers)
    {
        [[SoundHelper sharedSoundInstance] playSound:10];
        [boostButton setBackgroundImage:[UIImage imageNamed:@"FreezerControlON"] forState:UIControlStateNormal];
        [boostButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [GameSaveState sharedGameData].tickets-=completeFreezers;
        amountOfTickets.text = [NSString stringWithFormat:@"Gold Bars:\n%i\n\n(Buy more)",(int)[GameSaveState sharedGameData].tickets];
        [ClientsAtHome sharedClientData].boostLaunchDate = [NSDate date];
        [ClientsAtHome sharedClientData].boostActivated = 1;
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        
    }
}

- (IBAction)buyMoreGoldButtonPressed:(id)sender
{
    [GameSaveState sharedGameData].currentShopList=3;
    [[SoundHelper sharedSoundInstance] playSound:4];
    [[NSUserDefaults standardUserDefaults]setInteger:1250 forKey:@"LastPosition"];
    
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
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"currentProgressColor"];
    
    [progressView setTintColor:color];
    animationXp.textColor = color;
    
    [self asignarValoresDeHome];
}

- (void)dangerClientButtonPressed
{
    [dangerClientButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DangerClientViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"dangerClientVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.pressed=0;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)randomPresentButtonPressed:(UIButton*)sender
{
    if (cualRandomPresent==0) {
        [GameSaveState sharedGameData].liquidCrystal+=2;
    }
    else if (cualRandomPresent==1)
    {
        [GameSaveState sharedGameData].crystal+=20;
    }
    else if (cualRandomPresent==2)
    {
        [GameSaveState sharedGameData].tickets+=1;
        amountOfTickets.text = [NSString stringWithFormat:@"Gold Bars:\n%i\n\n(Buy more)",(int)[GameSaveState sharedGameData].tickets];
    }
    else if (cualRandomPresent==3)
    {
        [GameSaveState sharedGameData].pills+=12;
    }
    else if (cualRandomPresent==4)
    {
        [GameSaveState sharedGameData].matchbox+=2;
    }
    else if (cualRandomPresent==5)
    {
        [GameSaveState sharedGameData].aluminum+=2;
    }
    else if (cualRandomPresent==6)
    {
        [[GameSaveState sharedGameData] changeMoney:600];
    }
    [self asignarValoresDeHome];
    
    sender.hidden = YES;
    [ClientsAtHome sharedClientData].randomPresent = 0;
}

- (void)tutorialButtonPressed:(UIButton*)sender
{
    sender.hidden = YES;
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

- (IBAction)unwindToHome:(UIStoryboardSegue*)unwindSegue
{
    if ([GameSaveState sharedGameData].loadedProducts==0) {
        [self requestProductInfo];
    }
    
    for (int i=1; i<7; i++) {
        if ([GameSaveState sharedGameData].currentFreezers>3*(i-1)) {
            completeFreezers=i;
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstView"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstView"];
        tutorialButton.hidden = NO;
        
        UIColor *tintColor = [UIColor colorWithRed:0.404 green:0.835 blue:0.969 alpha:1];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"currentProgressColor"];
        
        animationXp.textColor = tintColor;
        
        //Sound
        soundOnOrOff = 0;
        
        [[NSUserDefaults standardUserDefaults] setInteger:soundOnOrOff forKey:@"soundOnOrOff"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentShopList"];
    }
    
    if ([ClientsAtHome sharedClientData].boostActivated==0) {
        [boostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [boostButton setBackgroundImage:[UIImage imageNamed:@"FreezerControlOFF"] forState:UIControlStateNormal];
        if (completeFreezers==1) {
            [boostButton setTitle:[NSString stringWithFormat:@"Boost Freezers for %imin! (1 Gold Bar)",(int)TIEMPO_BOOST] forState:UIControlStateNormal];
        }
        else
        {
            [boostButton setTitle:[NSString stringWithFormat:@"Boost Freezers for %imin! (%i Gold Bars)",(int)TIEMPO_BOOST,(int)completeFreezers] forState:UIControlStateNormal];
        }
    }
    
    [GameSaveState sharedGameData].showCustomerHome = 1;
    
    NSString *queColorDeCrystal = [NSString stringWithFormat:@"flavor%i",(int)[GameSaveState sharedGameData].currentCrystalColor-1];
    crystalImage.image = [UIImage imageNamed:queColorDeCrystal];
    
    amountOfTickets.text = [NSString stringWithFormat:@"Gold Bars:\n%i\n\n(Buy more)",(int)[GameSaveState sharedGameData].tickets];
    
    if ([GameSaveState sharedGameData].changeDanger==1) {
        for (int i=0; i<10; i++)
        {
            NSInteger cuanto = [[ClientsAtHome sharedClientData].valoresDangerOriginal[i] intValue]/10;
            NSInteger reducido = [[ClientsAtHome sharedClientData].valoresDangerOriginal[i] intValue]-(cuanto*[GameSaveState sharedGameData].currentSpy);
            [[ClientsAtHome sharedClientData].valoresDangerEnRegion replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:reducido]];
        }
        [GameSaveState sharedGameData].changeDanger=0;
    }
    
    [self asignarValoresDeHome];
    [self showTotalTimePlayed];
    [self refreshFreezerImage];
    [self updateFreezerButtonAndLabel];
    [self revisarSiHayClientesActivos];
    [self showRandomPresent];
    
    customerTimer = [NSTimer scheduledTimerWithTimeInterval:CUSTOMER_TIME target:self selector:@selector(randomCustomer) userInfo:nil repeats:YES];
    totalTimePlayedTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(showTotalTimePlayed) userInfo:nil repeats:YES];
    cookingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cookingSeconds) userInfo:nil repeats:YES];
    dangerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dangerSeconds) userInfo:nil repeats:YES];
    saveTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(automaticSave) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [GameSaveState sharedGameData].showCustomerHome = 0;
    
    for (int i =0; i<10; i++) {
        NSNumber *cualNumber = [NSNumber numberWithInt:i];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(quitarCliente:) object: cualNumber];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(quitarInfoCliente:) object: cualNumber];
    }
    
    [totalTimePlayedTimer invalidate];
    [customerTimer invalidate];
    [cookingTimer invalidate];
    [dangerTimer invalidate];
    [saveTimer invalidate];
}

@end