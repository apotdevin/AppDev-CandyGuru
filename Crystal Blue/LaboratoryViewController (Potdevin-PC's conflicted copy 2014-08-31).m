//
//  LaboratoryViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/4/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "LaboratoryViewController.h"
#import "CrystalAppDelegate.h"
#import "BannerHelper.h"

@interface LaboratoryViewController ()

@end

@implementation LaboratoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL valid = NO;
    BOOL productPurchased = [[NSUserDefaults standardUserDefaults] secureBoolForKey:@"anthonypotdevin.crystalblue.removebanners" valid:&valid];
    if (!valid)
    {
        [[NSUserDefaults standardUserDefaults] setSecureBool:NO forKey:@"anthonypotdevin.crystalblue.removebanners"];
        NSLog(@"INVALID removeAds!");
    }
    if (!productPurchased) {
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(160, screenBounds.size.height-25);
    }
    else
    {
        NSLog(@"Banner removed");
    }
    
    [self inicializarTodo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inicializarTodo
{
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1/[GameSaveState sharedGameData].testGame target:self selector:@selector(eachSecondTimer) userInfo:nil repeats:YES];
    
    NSString *cualFondo = [NSString stringWithFormat:@"%iLocation",(int)[GameSaveState sharedGameData].currentLabBackground];
    [imagenDeFondo setImage:[UIImage imageNamed:cualFondo]];
    
    fridgeWindow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labWindow"]];
    [self.view addSubview:fridgeWindow];
    
    cuantoMasCrystal=0;
    tiempoCocinar=0;
    maxLiquidCrystal=0;
    
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        cuantoMasCrystal=[GameSaveState sharedGameData].currentPot;
        tiempoCocinar=TIEMPO_COOK-1+[GameSaveState sharedGameData].currentPot;
        maxLiquidCrystal=2+([GameSaveState sharedGameData].currentDecantor*3);
    }
    else
    {
        cuantoMasCrystal=4+[GameSaveState sharedGameData].currentMixer;
        tiempoCocinar=TIEMPO_COOK+3+[GameSaveState sharedGameData].currentMixer;
        maxLiquidCrystal=14+([GameSaveState sharedGameData].currentDistilator*3);
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewLab"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewLab"];
    }
    else
    {
        
    }
    
    if ([GameSaveState sharedGameData].currentLabSetting==1)
    {
        [self setupFirstLab];
        fridgeWindow.frame = CGRectMake(3, 3, 130, 100);
    }
    else
    {
        [self setupSecondLab];
        fridgeWindow.frame = CGRectMake(3, 3, 130, 100);
    }
    if ([GameSaveState sharedGameData].currentLabBackground>=4&&[GameSaveState sharedGameData].currentLabBackground<=10)
    {
        [self setupExtractor];
        if ([GameSaveState sharedGameData].currentLabSetting==1)
        {
            fridgeWindow.frame = CGRectMake(3, 3, 130, 150);
        }
        else
        {
            fridgeWindow.frame = CGRectMake(3, 3, 130, 130);
        }
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back Home" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    [backButton setFrame:CGRectMake(10, 10, 120, 20)];
    backButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    backButton.titleLabel.shadowColor = [UIColor blackColor];
    [self.view addSubview:backButton];
    
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shopButton addTarget:self action:@selector(shopButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [shopButton setTitle:@"Shop" forState:UIControlStateNormal];
    [shopButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    shopButton.titleLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    [shopButton setFrame:CGRectMake(10, 32, 120, 20)];
    shopButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    shopButton.titleLabel.shadowColor = [UIColor blackColor];
    [self.view addSubview:shopButton];
    
    UILabel *cuantoMasLabel = [[UILabel alloc]init];
    cuantoMasLabel.font = [UIFont fontWithName:@"28 Days Later" size:15];
    cuantoMasLabel.textColor = [UIColor whiteColor];
    if (cuantoMasCrystal==1) {
        cuantoMasLabel.text = @"(+1)";
    }
    else
    {
        cuantoMasLabel.text = [NSString stringWithFormat:@"( 1  - %i )",(int)cuantoMasCrystal];
    }
    
    animationLabel = [[UILabel alloc]init];
    animationLabel.font = [UIFont fontWithName:@"28 Days Later" size:30];
    animationLabel.frame = CGRectMake(0, 0, 150, 100);
    animationLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1];
    animationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    animationLabel.numberOfLines = 2;
    [self.view addSubview:animationLabel];
    
    animationXp = [[UILabel alloc]init];
    animationXp.font = [UIFont fontWithName:@"28 Days Later" size:30];
    animationXp.frame = CGRectMake(0, 0, 300, 100);
    animationXp.textColor = [UIColor colorWithRed:0 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:animationXp];
    
    animationImageView = [[UIImageView alloc] init];
    NSString *cualAnimation;
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        cualAnimation = @"Smoke";
        animationImageView.frame = CGRectMake(105, 133, 130, 142);
        cuantoMasLabel.frame = CGRectMake(160, 275, 80, 115);
    }
    else
    {
        cualAnimation = @"Mixer";
        animationImageView.frame = CGRectMake(71, 204, 120, 132);
        cuantoMasLabel.frame = CGRectMake(115, 298, 80, 115);
    }
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i < 22; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%i%@",i,cualAnimation]]];
    }
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 2;
    [self.view addSubview:animationImageView];
    [self.view addSubview:cuantoMasLabel];
}

- (void)setupExtractor
{
    NSString *cualExtractor = [NSString stringWithFormat:@"Extractor%i",(int)[GameSaveState sharedGameData].currentExtractor];
    extractorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:cualExtractor]];
    [extractorImage setFrame:CGRectMake(145, -80, 70, 206)];
    [self.view addSubview:extractorImage];
    
    NSTimeInterval secondsBetween;
    NSDate *currentDate = [NSDate date];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewLab"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewLab"];
        [GameSaveState sharedGameData].pastDate = [NSDate date];
        secondsBetween = 0;
    }
    else
    {
        secondsBetween = [currentDate timeIntervalSinceDate:[GameSaveState sharedGameData].pastDate]*[GameSaveState sharedGameData].currentExtractor;
    }
    
    currentToxicity = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLabToxicity"];
    if (!currentToxicity) {
        currentToxicity = 0;
    }
    
    if (currentToxicity>=secondsBetween) {
        currentToxicity = currentToxicity - secondsBetween;
    }
    else
    {
        currentToxicity = 0;
    }
    
    extractorLabel = [[UILabel alloc]init];
    extractorLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    extractorLabel.textAlignment = NSTextAlignmentCenter;
    extractorLabel.text = [NSString stringWithFormat:@"Lab Toxicity: %i%%",(int)currentToxicity];
    extractorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    extractorLabel.numberOfLines = 2;
    extractorLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:extractorLabel];
    
    if ([GameSaveState sharedGameData].currentLabSetting==1)
    {
        extractorLabel.frame = CGRectMake(3, 100, 130, 60);
    }
    else
    {
        extractorLabel.frame = CGRectMake(3, 80, 130, 60);
    }
}

- (void)setupFirstLab
{
    pillsLabel = [[UILabel alloc] init];
    pillsLabel.frame = CGRectMake(8, 60, 120, 20);
    pillsLabel.text = [NSString stringWithFormat:@"Pills: %li",(long)[GameSaveState sharedGameData].pills];
    pillsLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [self.view addSubview:pillsLabel];
    
    matchboxLabel = [[UILabel alloc] init];
    matchboxLabel.frame = CGRectMake(8, 80, 120, 20);
    matchboxLabel.text = [NSString stringWithFormat:@"Matchboxes: %li",(long)[GameSaveState sharedGameData].matchbox];
    matchboxLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [self.view addSubview:matchboxLabel];
    
    heater = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Heater"]];
    heater.frame = CGRectMake(130, 340, 91, 46);
    [self.view addSubview:heater];
    
    glassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [glassButton addTarget:self action:@selector(glassButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [glassButton setBackgroundImage:[UIImage imageNamed:@"Glass"] forState:UIControlStateNormal];
    [glassButton setFrame:CGRectMake(5, 285, 90, 100)];
    [self.view addSubview:glassButton];
    
    bowlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bowlButton addTarget:self action:@selector(bowlButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bowlButton setBackgroundImage:[UIImage imageNamed:@"Bowl"] forState:UIControlStateNormal];
    [bowlButton setFrame:CGRectMake(60, 375, 74, 53)];
    [self.view addSubview:bowlButton];
    
    potButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [potButton addTarget:self action:@selector(potButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [potButton setBackgroundImage:[UIImage imageNamed:@"Pot"] forState:UIControlStateNormal];
    [potButton setFrame:CGRectMake(96, 250, 156, 115)];
    [self.view addSubview:potButton];
    
    decantorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Decantor"]];
    [decantorImage setFrame:CGRectMake(245, 265, 70, 142)];
    [self.view addSubview:decantorImage];
    
    glassLabel = [[UILabel alloc]init];
    glassLabel.frame = CGRectMake(0, 295, 100, 100);
    glassLabel.text = [NSString stringWithFormat:@"White\nPowder: %li",(long)[GameSaveState sharedGameData].whitePowder];
    glassLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    glassLabel.textColor = [UIColor whiteColor];
    glassLabel.lineBreakMode = NSLineBreakByWordWrapping;
    glassLabel.numberOfLines = 3;
    glassLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:glassLabel];
    
    bowlLabel = [[UILabel alloc]init];
    bowlLabel.frame = CGRectMake(40, 365, 114, 80);
    bowlLabel.text = [NSString stringWithFormat:@"Red\nPowder: %li",(long)[GameSaveState sharedGameData].redPowder];
    bowlLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    bowlLabel.textColor = [UIColor whiteColor];
    bowlLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bowlLabel.numberOfLines = 3;
    bowlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bowlLabel];
    
    potLabel = [[UILabel alloc]init];
    potLabel.frame = CGRectMake(135, 250, 80, 115);
    
    if ([GameSaveState sharedGameData].potActive!=0) {
        NSDate *presentDate = [NSDate date];
        NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:[GameSaveState sharedGameData].potDate];
        
        int potTimer = tiempoCocinar-secondsBetween;
        if (potTimer<=0) {
            potLabel.text = @"Done!";
        }
        else
        {
            [animationImageView startAnimating];
            potLabel.text = [NSString stringWithFormat:@"%isec",(int)potTimer];
        }
        
    }
    else
    {
        potLabel.text = @"Cook some Crystal!";
    }
    potLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    potLabel.textColor = [UIColor whiteColor];
    potLabel.lineBreakMode = NSLineBreakByWordWrapping;
    potLabel.numberOfLines = 2;
    potLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:potLabel];
    
    decantorLabel = [[UILabel alloc]init];
    decantorLabel.frame = CGRectMake(200, 350, 115, 115);
    decantorLabel.text = [NSString stringWithFormat:@"Liquid Crystal:\n%li/%i",(long)[GameSaveState sharedGameData].liquidCrystal,(int)maxLiquidCrystal];
    decantorLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    decantorLabel.textColor = [UIColor whiteColor];
    decantorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    decantorLabel.numberOfLines = 2;
    decantorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:decantorLabel];
    
}

-(void)setupSecondLab
{
    aluminumLabel = [[UILabel alloc]init];
    aluminumLabel.frame = CGRectMake(8, 60, 120, 20);
    aluminumLabel.text = [NSString stringWithFormat:@"Aluminium: %li",(long)[GameSaveState sharedGameData].aluminum];
    aluminumLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [self.view addSubview:aluminumLabel];
    
    mixerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mixerButton addTarget:self action:@selector(potButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [mixerButton setBackgroundImage:[UIImage imageNamed:@"Pot2"] forState:UIControlStateNormal];
    [mixerButton setFrame:CGRectMake(65, 275, 135, 100)];
    [self.view addSubview:mixerButton];
    
    beakerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [beakerButton addTarget:self action:@selector(beakerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [beakerButton setBackgroundImage:[UIImage imageNamed:@"Glass2"] forState:UIControlStateNormal];
    [beakerButton setFrame:CGRectMake(10, 315, 80, 105)];
    [self.view addSubview:beakerButton];
    
    distilatorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Destillator"]];
    [distilatorImage setFrame:CGRectMake(180, 265, 140, 140)];
    [self.view addSubview:distilatorImage];
    
    bowlLabel = [[UILabel alloc]init];
    bowlLabel.frame = CGRectMake(0, 325, 74, 100);
    bowlLabel.text = [NSString stringWithFormat:@"Grey\nPowder: %li",(long)[GameSaveState sharedGameData].greyPowder];
    bowlLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    bowlLabel.textColor = [UIColor whiteColor];
    bowlLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bowlLabel.numberOfLines = 2;
    bowlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bowlLabel];
    
    potLabel = [[UILabel alloc]init];
    potLabel.frame = CGRectMake(95, 270, 80, 115);
    if ([GameSaveState sharedGameData].potActive!=0) {
        NSDate *presentDate = [NSDate date];
        NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:[GameSaveState sharedGameData].potDate];
        
        int potTimer = tiempoCocinar-secondsBetween;
        if (potTimer<=0) {
            potLabel.text = @"Done!";
        }
        else
        {
            [animationImageView startAnimating];
            potLabel.text = [NSString stringWithFormat:@"%isec",(int)potTimer];
        }
        
    }
    else
    {
        potLabel.text = @"Cook some Crystal!";
    }
    potLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    potLabel.textColor = [UIColor whiteColor];
    potLabel.lineBreakMode = NSLineBreakByWordWrapping;
    potLabel.numberOfLines = 2;
    potLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:potLabel];
    
    decantorLabel = [[UILabel alloc]init];
    decantorLabel.frame = CGRectMake(190, 300, 115, 115);
    decantorLabel.text = [NSString stringWithFormat:@"Liquid Crystal:\n%li/%i",(long)[GameSaveState sharedGameData].liquidCrystal,(int)maxLiquidCrystal];
    decantorLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    decantorLabel.textColor = [UIColor whiteColor];
    decantorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    decantorLabel.numberOfLines = 2;
    decantorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:decantorLabel];
}

- (void)refreshInterfaceValues
{
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        pillsLabel.text = [NSString stringWithFormat:@"Pills: %li",(long)[GameSaveState sharedGameData].pills];
        matchboxLabel.text = [NSString stringWithFormat:@"Matchboxes: %li",(long)[GameSaveState sharedGameData].matchbox];
        glassLabel.text = [NSString stringWithFormat:@"White\nPowder: %li",(long)[GameSaveState sharedGameData].whitePowder];
        bowlLabel.text = [NSString stringWithFormat:@"Red\nPowder: %li",(long)[GameSaveState sharedGameData].redPowder];
    }
    else
    {
        aluminumLabel.text = [NSString stringWithFormat:@"Aluminium: %li",(long)[GameSaveState sharedGameData].aluminum];
        bowlLabel.text = [NSString stringWithFormat:@"Grey\nPowder: %li",(long)[GameSaveState sharedGameData].greyPowder];
    }
    decantorLabel.text = [NSString stringWithFormat:@"Liquid Crystal:\n%li/%i",(long)[GameSaveState sharedGameData].liquidCrystal,(int)maxLiquidCrystal];
}

- (void)eachSecondTimer
{
    //Pot timer---------------------------------------------------------------------------------------------
    int potTimer=1000;
    if ([GameSaveState sharedGameData].potActive==1)
    {
        NSDate *presentDate = [NSDate date];
        NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:[GameSaveState sharedGameData].potDate];
        
        potTimer = tiempoCocinar-(secondsBetween*[GameSaveState sharedGameData].testGame);
        potLabel.text = [NSString stringWithFormat:@"%isec",(int)potTimer];
    }
    if (potTimer<=0)
    {
        [self sonidoMoney];
        
        potLabel.text = @"Cook some Crystal!";
        
        [animationImageView stopAnimating];
        
        int randomCuantoMasCrystal = arc4random_uniform(((int)cuantoMasCrystal-1))+1;
        int faltante = maxLiquidCrystal-[GameSaveState sharedGameData].liquidCrystal;
        
        if (faltante<=randomCuantoMasCrystal) {
            randomCuantoMasCrystal = faltante;
        }
        
        [GameSaveState sharedGameData].liquidCrystal+=randomCuantoMasCrystal;
        [GameSaveState sharedGameData].totalLiquidCrystal+=randomCuantoMasCrystal;
        [[GameCenterHelper sharedGC] makeLiquidAchievements];
        
        [self animateChange:(int)randomCuantoMasCrystal cual:1];
        [self animateChange:2*(int)[GameSaveState sharedGameData].level cual:2];
        
        [[GameSaveState sharedGameData] changeXp:(2*[GameSaveState sharedGameData].level)];
        [GameSaveState sharedGameData].totalXpGained+=(2*[GameSaveState sharedGameData].level);
        
        [GameSaveState sharedGameData].potActive=0;
        [GameSaveState sharedGameData].potDate=[NSDate date];
        [self refreshInterfaceValues];
    }
        //Toxicity timer-----------------------------------------------------------------------------------------
    if (currentToxicity>[GameSaveState sharedGameData].currentExtractor&&[GameSaveState sharedGameData].currentLabBackground>=4&&[GameSaveState sharedGameData].currentLabBackground<=10)
    {
        currentToxicity = currentToxicity - ([GameSaveState sharedGameData].currentExtractor*[GameSaveState sharedGameData].testGame);
        extractorLabel.text = [NSString stringWithFormat:@"Lab Toxicity: %i%%",(int)currentToxicity];
        [[NSUserDefaults standardUserDefaults] setInteger:currentToxicity forKey:@"currentLabToxicity"];
        
        if (currentToxicity>50) {
            extractorLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
        }
        else
        {
            extractorLabel.textColor = [UIColor whiteColor];
        }
    }
    if (currentToxicity<[GameSaveState sharedGameData].currentExtractor) {
        currentToxicity = 0;
        extractorLabel.text = [NSString stringWithFormat:@"Lab Toxicity: %i%%",(int)currentToxicity];
        [[NSUserDefaults standardUserDefaults] setInteger:currentToxicity forKey:@"currentLabToxicity"];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)glassButtonPressed
{
    if ([GameSaveState sharedGameData].pills>=6) {
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"glassVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        pillsLabel.font = [UIFont fontWithName:@"28 Days Later" size:17];
        pillsLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reversePills) withObject:nil afterDelay:0.5];
    }
}

-(void)bowlButtonPressed
{
    if ([GameSaveState sharedGameData].matchbox>=1) {
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"bowlVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        matchboxLabel.font = [UIFont fontWithName:@"28 Days Later" size:17];
        matchboxLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseMatchbox) withObject:nil afterDelay:0.5];
    }
}

-(void)beakerButtonPressed
{
    if ([GameSaveState sharedGameData].aluminum>=1) {
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"beakerVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        aluminumLabel.font = [UIFont fontWithName:@"28 Days Later" size:17];
        aluminumLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseAluminum) withObject:nil afterDelay:0.5];
    }
}

-(void)backButtonPressed
{
    [self performSegueWithIdentifier:@"exitLabToHome" sender:self];
    //[GameSaveState sharedGameData].changingBetweenLabAndShop = 0;
}

-(void)shopButtonPressed
{
    [GameSaveState sharedGameData].currentShopList=0;
    
    /*if ([GameSaveState sharedGameData].changingBetweenLabAndShop == 0)
    {
        [GameSaveState sharedGameData].changingBetweenLabAndShop = 1;
        
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"shopVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [GameSaveState sharedGameData].changingBetweenLabAndShop = 0;
        [self performSegueWithIdentifier:@"exitLabToShop" sender:self];
    }*/
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"shopVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)refreshFromUnwind
{
    
}

-(IBAction)unwindToLab:(UIStoryboardSegue*)unwindSegue
{
    [self refreshInterfaceValues];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1/[GameSaveState sharedGameData].testGame target:self selector:@selector(eachSecondTimer) userInfo:nil repeats:YES];
}

-(void)potButtonPressed
{
    int puede = 0;
    
    if ([GameSaveState sharedGameData].currentLabSetting==1&&[GameSaveState sharedGameData].whitePowder>=1&&[GameSaveState sharedGameData].redPowder>=1&&[GameSaveState sharedGameData].potActive==0) {
        puede = 1;
    }
    if ([GameSaveState sharedGameData].currentLabSetting==2&&[GameSaveState sharedGameData].greyPowder>=1&&[GameSaveState sharedGameData].potActive==0) {
        puede = 1;
    }
    
    if (puede==1&&currentToxicity<=50&&[GameSaveState sharedGameData].liquidCrystal<maxLiquidCrystal) {
        [animationImageView startAnimating];
        potLabel.text = [NSString stringWithFormat:@"%isec",(int)tiempoCocinar];
        
        if ([GameSaveState sharedGameData].level>=3&&[GameSaveState sharedGameData].currentLabBackground>=4&&[GameSaveState sharedGameData].currentLabBackground<=10) {
            currentToxicity = currentToxicity + 50;
        }
        if ([GameSaveState sharedGameData].currentLabSetting==1) {
            [GameSaveState sharedGameData].whitePowder--;
            [GameSaveState sharedGameData].redPowder--;
            
            glassLabel.text = [NSString stringWithFormat:@"White Powder: %li",(long)[GameSaveState sharedGameData].whitePowder];
            bowlLabel.text = [NSString stringWithFormat:@"Red Powder: %li",(long)[GameSaveState sharedGameData].redPowder];
        }
        else
        {
            [GameSaveState sharedGameData].greyPowder--;
            
            bowlLabel.text = [NSString stringWithFormat:@"Grey Powder: %li",(long)[GameSaveState sharedGameData].greyPowder];
        }
        
        [GameSaveState sharedGameData].potDate = [NSDate date];
        [GameSaveState sharedGameData].potActive = 1;
    }
    else
    {
        if ([GameSaveState sharedGameData].whitePowder<1)
        {
            glassLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
            glassLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseWhitePowder) withObject:nil afterDelay:0.5];
        }
        if ([GameSaveState sharedGameData].currentLabSetting==1&&[GameSaveState sharedGameData].redPowder<1) {
            bowlLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
            bowlLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseRedPowder) withObject:nil afterDelay:0.5];
        }
        if ([GameSaveState sharedGameData].currentLabSetting==2&&[GameSaveState sharedGameData].greyPowder<1) {
            bowlLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
            bowlLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseRedPowder) withObject:nil afterDelay:0.5];
        }
        if ([GameSaveState sharedGameData].liquidCrystal>maxLiquidCrystal-cuantoMasCrystal)
        {
            decantorLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
            decantorLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseLiquidCrystal) withObject:nil afterDelay:0.5];
        }
    }
}

- (void)reverseWhitePowder
{
    glassLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    glassLabel.textColor = [UIColor whiteColor];
}
- (void)reverseRedPowder
{
    bowlLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    bowlLabel.textColor = [UIColor whiteColor];
}
- (void)reverseLiquidCrystal
{
    decantorLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    decantorLabel.textColor = [UIColor whiteColor];
}
- (void)reversePills
{
    pillsLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    pillsLabel.textColor = [UIColor blackColor];
}
- (void)reverseMatchbox
{
    matchboxLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    matchboxLabel.textColor = [UIColor blackColor];
}
- (void)reverseAluminum
{
    aluminumLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    aluminumLabel.textColor = [UIColor blackColor];
}

- (void)animateChange:(int)cuanto cual:(int)cualLabel
{
    int randomX = arc4random_uniform(170)+75;
    int randomY = arc4random_uniform(100)+350;
    
    UILabel *animation;
    
    if (cualLabel==1) {
        animation = animationLabel;
        animation.text = [NSString stringWithFormat:@"+%i Liquid Crystal",cuanto];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [[BannerHelper sharedAd].bannerView removeFromSuperview];
    
    [gameTimer invalidate];
    gameTimer = nil;
    
    [GameSaveState sharedGameData].pastDate = [NSDate date];
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
