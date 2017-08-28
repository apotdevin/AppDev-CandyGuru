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
#import "SoundHelper.h"

@interface LaboratoryViewController ()

@end

@implementation LaboratoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL productPurchased=NO;
    if ([GameSaveState sharedGameData].removeBanners==641) {
        productPurchased=YES;
    }
    
    if (!productPurchased) {
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-25);
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
    
    [self inicializarTodo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inicializarTodo
{
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eachSecondTimer) userInfo:nil repeats:YES];
    
    NSString *cualFondo = [NSString stringWithFormat:@"%iLocation",(int)[GameSaveState sharedGameData].currentLabBackground];
    [imagenDeFondo setImage:[UIImage imageNamed:cualFondo]];
    
    fridgeWindow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ShopWindow"]];
    
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
    /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewLab"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewLab"];
    }
    else
    {
        
    }*/
    if ([GameSaveState sharedGameData].currentLabBackground>=4&&[GameSaveState sharedGameData].currentLabBackground<=10)
    {
        [self setupExtractor];
    }
    [self.view addSubview:fridgeWindow];
    /*if ([GameSaveState sharedGameData].currentLabBackground>=4&&[GameSaveState sharedGameData].currentLabBackground<=10)
    {
        if ([GameSaveState sharedGameData].currentLabSetting==1)
        {
            fridgeWindow.frame = CGRectMake(3, 3, 130, 150);
        }
        else
        {
            fridgeWindow.frame = CGRectMake(3, 3, 130, 130);
        }
    }*/
    
    if ([GameSaveState sharedGameData].currentLabSetting==1)
    {
        [self setupFirstLab];
        fridgeWindow.frame = CGRectMake(3, 3, 150, 100);
    }
    else
    {
        [self setupSecondLab];
        fridgeWindow.frame = CGRectMake(3, 3, 150, 80);
    }
    
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back Home" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:0.98039 green:0.85882 blue:0.039215 alpha:1] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    [backButton setFrame:CGRectMake(10, 10, 140, 20)];
    backButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [backButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    shopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shopButton addTarget:self action:@selector(shopButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [shopButton setTitle:@"Shop" forState:UIControlStateNormal];
    [shopButton setTitleColor:[UIColor colorWithRed:0.98039 green:0.85882 blue:0.039215 alpha:1] forState:UIControlStateNormal];
    shopButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    [shopButton setFrame:CGRectMake(10, 32, 140, 20)];
    shopButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [shopButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:shopButton];
    
    cuantoMasLabel = [[UILabel alloc]init];
    cuantoMasLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15];
    cuantoMasLabel.textColor = [UIColor whiteColor];
    cuantoMasLabel.shadowColor = [UIColor blackColor];
    cuantoMasLabel.shadowOffset = CGSizeMake(1, 1);
    if (cuantoMasCrystal==1) {
        cuantoMasLabel.text = @"(+1)";
    }
    else
    {
        cuantoMasLabel.text = [NSString stringWithFormat:@"( 1  - %i )",(int)cuantoMasCrystal];
    }
    
    animationLabel = [[UILabel alloc]init];
    animationLabel.font = [UIFont fontWithName:@"AllerDisplay" size:30];
    animationLabel.frame = CGRectMake(0, 0, 150, 100);
    animationLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1];
    animationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    animationLabel.numberOfLines = 2;
    [self.view addSubview:animationLabel];
    
    animationXp = [[UILabel alloc]init];
    animationXp.font = [UIFont fontWithName:@"AllerDisplay" size:30];
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
    
    if ([GameSaveState sharedGameData].screenSize==1)
    {
        if ([GameSaveState sharedGameData].currentLabSetting==1)
        {
            animationImageView.frame = CGRectMake(105, 133-65, 130, 142);
            cuantoMasLabel.frame = CGRectMake(160, 275-65, 80, 115);
        }
        else
        {
            animationImageView.frame = CGRectMake(71, 204-55, 120, 132);
            cuantoMasLabel.frame = CGRectMake(115, 298-55, 80, 115);
        }
    }
    
    else if ([GameSaveState sharedGameData].screenSize==2)
    {
        cuantoMasLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15*1.4];
        if ([GameSaveState sharedGameData].currentLabSetting==1)
        {
            animationImageView.frame = CGRectMake(116, 122, 130*1.3, 142*1.3);
            cuantoMasLabel.frame = CGRectMake(192, 300, 80*1.4, 115*1.4);
        }
        else
        {
            animationImageView.frame = CGRectMake(75, 222, 130*1.2, 142*1.2);
            cuantoMasLabel.frame = CGRectMake(123, 330, 80*1.4, 115*1.4);
        }
    }
    
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        cuantoMasLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15*1.4];
        if ([GameSaveState sharedGameData].currentLabSetting==1)
        {
            animationImageView.frame = CGRectMake(124, 136, 130*1.4, 142*1.4);
            cuantoMasLabel.frame = CGRectMake(203, 340, 80*1.4, 115*1.4);
        }
        else
        {
            animationImageView.frame = CGRectMake(92, 254, 130*1.3, 142*1.3);
            cuantoMasLabel.frame = CGRectMake(155, 380, 80*1.4, 115*1.4);
        }
    }
    
    [self.view addSubview:animationImageView];
    [self.view addSubview:cuantoMasLabel];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    tutorialButton = [[UIImageView alloc] init];
    [tutorialButton setFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    tutorialButton.hidden=YES;
    [self.view addSubview:tutorialButton];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewKitchen"]!=YES) {
        [self manejoDelTutorial:4 aparecer:1];
        
        backButton.enabled=NO;
        shopButton.enabled=NO;
        potButton.enabled=NO;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HizoPowder"]==YES&&[[NSUserDefaults standardUserDefaults] boolForKey:@"HizoDust"]==YES)
        {
            [self manejoDelTutorial:5 aparecer:1];
            potButton.enabled=YES;
        }
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]) {
        [self manejoDelTutorial:1 aparecer:0];
        backButton.enabled=YES;
        shopButton.enabled=YES;
        potButton.enabled=YES;
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

- (void)setupExtractor
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    NSString *cualExtractor = [NSString stringWithFormat:@"Extractor%i",(int)[GameSaveState sharedGameData].currentExtractor];
    extractorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:cualExtractor]];
    [extractorImage setFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    
    [self.view addSubview:extractorImage];
    
    float currentDate = CACurrentMediaTime();
    float pastDate = [GameSaveState sharedGameData].pastDate;
    float secondsBetween;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewLab"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewLab"];
        [GameSaveState sharedGameData].pastDate = CACurrentMediaTime();
        secondsBetween = 0;
    }
    else
    {
        secondsBetween = (currentDate-pastDate)*[GameSaveState sharedGameData].currentExtractor;
        if (secondsBetween<0) {
            [GameSaveState sharedGameData].pastDate = CACurrentMediaTime();
            currentDate = CACurrentMediaTime();
            pastDate = [GameSaveState sharedGameData].pastDate;
            secondsBetween = (currentDate-pastDate)*[GameSaveState sharedGameData].currentExtractor;
        }
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
    extractorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    extractorLabel.textAlignment = NSTextAlignmentCenter;
    extractorLabel.text = [NSString stringWithFormat:@"Kitchen Heat: %i%%",(int)currentToxicity];
    extractorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    extractorLabel.numberOfLines = 2;
    extractorLabel.textColor = [UIColor colorWithRed:0.98039 green:0.85882 blue:0.039215 alpha:1];
    extractorLabel.shadowColor = [UIColor blackColor];
    extractorLabel.shadowOffset = CGSizeMake(1, 1);
    
    [self.view addSubview:extractorLabel];
    
    if ([GameSaveState sharedGameData].currentLabSetting==1)
    {
        extractorLabel.frame = CGRectMake(3, 100, 150, 60);
    }
    else
    {
        extractorLabel.frame = CGRectMake(3, 80, 150, 60);
    }
    UIImage *img = [UIImage imageNamed:@"ShopWindow"];
    CGSize imgSize = extractorLabel.frame.size;
    UIGraphicsBeginImageContext( imgSize );
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    extractorLabel.backgroundColor = [UIColor colorWithPatternImage:newImage];
}

- (void)setupFirstLab
{
    int iphone4 = 0;
    if ([GameSaveState sharedGameData].screenSize==1) {
        iphone4=-65;
    }
    
    pillsLabel = [[UILabel alloc] init];
    pillsLabel.frame = CGRectMake(8, 60, 140, 20);
    pillsLabel.text = [NSString stringWithFormat:@"Sugar Cubes: %li",(long)[GameSaveState sharedGameData].pills];
    pillsLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    [self.view addSubview:pillsLabel];
    
    matchboxLabel = [[UILabel alloc] init];
    matchboxLabel.frame = CGRectMake(8, 80, 140, 20);
    matchboxLabel.text = [NSString stringWithFormat:@"Red Taffy: %li",(long)[GameSaveState sharedGameData].matchbox];
    matchboxLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    [self.view addSubview:matchboxLabel];
    
    heater = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Heater"]];
    heater.frame = CGRectMake(130, 340+iphone4, 91, 46);
    [self.view addSubview:heater];
    
    glassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [glassButton addTarget:self action:@selector(glassButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [glassButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Glass%li",(long)[GameSaveState sharedGameData].currentGlass]] forState:UIControlStateNormal];
    [glassButton setFrame:CGRectMake(5, 285+iphone4, 90, 100)];
    [self.view addSubview:glassButton];
    
    bowlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bowlButton addTarget:self action:@selector(bowlButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bowlButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Bowl%li",(long)[GameSaveState sharedGameData].currentBowl]] forState:UIControlStateNormal];
    [bowlButton setFrame:CGRectMake(60, 375+iphone4, 74, 53)];
    [self.view addSubview:bowlButton];
    
    potButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [potButton addTarget:self action:@selector(potButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [potButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Pot%li",(long)[GameSaveState sharedGameData].currentPot]] forState:UIControlStateNormal];
    [potButton setFrame:CGRectMake(96, 250+iphone4, 156, 115)];
    [self.view addSubview:potButton];
    
    decantorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Decantator%li",(long)[GameSaveState sharedGameData].currentDecantor]]];
    [decantorImage setFrame:CGRectMake(245, 265+iphone4, 70, 142)];
    [self.view addSubview:decantorImage];
    
    glassLabel = [[UILabel alloc]init];
    glassLabel.frame = CGRectMake(0, 295+iphone4, 100, 100);
    glassLabel.text = [NSString stringWithFormat:@"Sugar\nDust: %li",(long)[GameSaveState sharedGameData].whitePowder];
    glassLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15];
    glassLabel.textColor = [UIColor whiteColor];
    glassLabel.shadowColor = [UIColor blackColor];
    glassLabel.shadowOffset = CGSizeMake(1, 1);
    glassLabel.lineBreakMode = NSLineBreakByWordWrapping;
    glassLabel.numberOfLines = 3;
    glassLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:glassLabel];
    
    bowlLabel = [[UILabel alloc]init];
    bowlLabel.frame = CGRectMake(40, 365+iphone4, 114, 80);
    bowlLabel.text = [NSString stringWithFormat:@"Taffy\nDust: %li",(long)[GameSaveState sharedGameData].redPowder];
    bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15];
    bowlLabel.textColor = [UIColor whiteColor];
    bowlLabel.shadowColor = [UIColor blackColor];
    bowlLabel.shadowOffset = CGSizeMake(1, 1);
    bowlLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bowlLabel.numberOfLines = 3;
    bowlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bowlLabel];
    
    potLabel = [[UILabel alloc]init];
    potLabel.frame = CGRectMake(135, 250+iphone4, 80, 115);
    
    if ([GameSaveState sharedGameData].potActive!=0) {
        float presentDate = CACurrentMediaTime();
        float potDate = [GameSaveState sharedGameData].potDate;
        float secondsBetween = presentDate - potDate;
        
        int potTimer = tiempoCocinar-secondsBetween;
        
        if (potTimer>tiempoCocinar) {
            [GameSaveState sharedGameData].potDate = CACurrentMediaTime();
            potDate = [GameSaveState sharedGameData].potDate;
            presentDate= CACurrentMediaTime();
            secondsBetween = presentDate - potDate;
            potTimer = tiempoCocinar-secondsBetween;
        }
        
        if (potTimer<=0) {
            potLabel.text = @"Done!";
        }
        else
        {
            [animationImageView startAnimating];
            potLabel.text = [NSString stringWithFormat:@"%isec",(int)potTimer];
            [[SoundHelper sharedSoundInstance] playSound:11];
        }
        
    }
    else
    {
        potLabel.text = @"Make some Candy!";
    }
    potLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15];
    potLabel.textColor = [UIColor whiteColor];
    potLabel.shadowColor = [UIColor blackColor];
    potLabel.shadowOffset = CGSizeMake(1, 1);
    potLabel.lineBreakMode = NSLineBreakByWordWrapping;
    potLabel.numberOfLines = 2;
    potLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:potLabel];
    
    decantorLabel = [[UILabel alloc]init];
    decantorLabel.frame = CGRectMake(200, 350+iphone4, 115, 115);
    decantorLabel.text = [NSString stringWithFormat:@"Soft Candy:\n%li/%i",(long)[GameSaveState sharedGameData].liquidCrystal,(int)maxLiquidCrystal];
    decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15];
    decantorLabel.textColor = [UIColor whiteColor];
    decantorLabel.shadowColor = [UIColor blackColor];
    decantorLabel.shadowOffset = CGSizeMake(1, 1);
    decantorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    decantorLabel.numberOfLines = 2;
    decantorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:decantorLabel];
    
    if ([GameSaveState sharedGameData].screenSize==2)
    {
        heater.frame = CGRectMake(145, 390, 91*1.3, 46*1.3);
        [glassButton setFrame:CGRectMake(5, 315, 90*1.3, 100*1.3)];
        [bowlButton setFrame:CGRectMake(70, 435, 74*1.3, 53*1.3)];
        [potButton setFrame:CGRectMake(100, 275, 156*1.3, 115*1.3)];
        [decantorImage setFrame:CGRectMake(280, 290, 70*1.3, 142*1.3)];
        glassLabel.frame = CGRectMake(0, 325, 100*1.3, 100*1.3);
        bowlLabel.frame = CGRectMake(40, 415, 114*1.3, 80*1.3);
        potLabel.frame = CGRectMake(150, 255, 80*1.3, 115*1.3);
        decantorLabel.frame = CGRectMake(240, 340, 115*1.3, 115*1.3);
        
        glassLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.3];
        bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.3];
        potLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.1];
        decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.3];
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        heater.frame = CGRectMake(155, 430, 91*1.4, 46*1.4);
        [glassButton setFrame:CGRectMake(5, 355, 90*1.4, 100*1.4)];
        [bowlButton setFrame:CGRectMake(80, 475, 74*1.4, 53*1.4)];
        [potButton setFrame:CGRectMake(110, 300, 156*1.4, 115*1.4)];
        [decantorImage setFrame:CGRectMake(310, 330, 70*1.4, 142*1.4)];
        glassLabel.frame = CGRectMake(0, 365, 100*1.4, 100*1.4);
        bowlLabel.frame = CGRectMake(60, 455, 114*1.4, 80*1.4);
        potLabel.frame = CGRectMake(160, 290, 80*1.4, 115*1.4);
        decantorLabel.frame = CGRectMake(260, 380, 115*1.4, 115*1.4);
        
        glassLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.4];
        bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.4];
        potLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.2];
        decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.4];
    }
}

-(void)setupSecondLab
{
    int iphone4 = 0;
    if ([GameSaveState sharedGameData].screenSize==1) {
        iphone4=-55;
    }
    
    aluminumLabel = [[UILabel alloc]init];
    aluminumLabel.frame = CGRectMake(8, 60, 140, 20);
    aluminumLabel.text = [NSString stringWithFormat:@"Licorice Sticks: %li",(long)[GameSaveState sharedGameData].aluminum];
    aluminumLabel.font = [UIFont fontWithName:@"AllerDisplay" size:14];
    if ([GameSaveState sharedGameData].screenSize==1) {
        aluminumLabel.font = [UIFont fontWithName:@"AllerDisplay" size:12];
    }
    [self.view addSubview:aluminumLabel];
    
    mixerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mixerButton addTarget:self action:@selector(potButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [mixerButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Pot2%li",(long)[GameSaveState sharedGameData].currentMixer]] forState:UIControlStateNormal];
    [mixerButton setFrame:CGRectMake(65, 275+iphone4, 135, 100)];
    [self.view addSubview:mixerButton];
    
    beakerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [beakerButton addTarget:self action:@selector(beakerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [beakerButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Glass2%li",(long)[GameSaveState sharedGameData].currentBeaker]] forState:UIControlStateNormal];
    [beakerButton setFrame:CGRectMake(10, 315+iphone4, 80, 105)];
    [self.view addSubview:beakerButton];
    
    distilatorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Destillator%li",(long)[GameSaveState sharedGameData].currentDistilator]]];
    [distilatorImage setFrame:CGRectMake(180, 280+iphone4, 140, 140)];
    [self.view addSubview:distilatorImage];
    
    bowlLabel = [[UILabel alloc]init];
    bowlLabel.frame = CGRectMake(0, 325+iphone4, 100, 100);
    bowlLabel.text = [NSString stringWithFormat:@"Red\nBites: %li",(long)[GameSaveState sharedGameData].greyPowder];
    bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    bowlLabel.textColor = [UIColor whiteColor];
    bowlLabel.shadowColor = [UIColor blackColor];
    bowlLabel.shadowOffset = CGSizeMake(1, 1);
    bowlLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bowlLabel.numberOfLines = 2;
    bowlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bowlLabel];
    
    potLabel = [[UILabel alloc]init];
    potLabel.frame = CGRectMake(95, 270+iphone4, 80, 115);
    if ([GameSaveState sharedGameData].potActive!=0) {
        
        float presentDate = CACurrentMediaTime();
        float potDate = [GameSaveState sharedGameData].potDate;
        float secondsBetween = presentDate - potDate;
        
        int potTimer = tiempoCocinar-secondsBetween;
        
        if (potTimer>tiempoCocinar) {
            [GameSaveState sharedGameData].potDate = CACurrentMediaTime();
            potDate = [GameSaveState sharedGameData].potDate;
            presentDate= CACurrentMediaTime();
            secondsBetween = presentDate - potDate;
            potTimer = tiempoCocinar-secondsBetween;
        }
        
        if (potTimer<=0) {
            potLabel.text = @"Done!";
        }
        else
        {
            [animationImageView startAnimating];
            potLabel.text = [NSString stringWithFormat:@"%isec",(int)potTimer];
            [[SoundHelper sharedSoundInstance] playSound:12];
        }
        
    }
    else
    {
        potLabel.text = @"Make some Candy!";
    }
    potLabel.font = [UIFont fontWithName:@"AllerDisplay" size:15];
    potLabel.textColor = [UIColor whiteColor];
    potLabel.shadowColor = [UIColor blackColor];
    potLabel.shadowOffset = CGSizeMake(1, 1);
    potLabel.lineBreakMode = NSLineBreakByWordWrapping;
    potLabel.numberOfLines = 2;
    potLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:potLabel];
    
    decantorLabel = [[UILabel alloc]init];
    decantorLabel.frame = CGRectMake(190, 300+iphone4, 115, 115);
    decantorLabel.text = [NSString stringWithFormat:@"Soft Candy:\n%li/%i",(long)[GameSaveState sharedGameData].liquidCrystal,(int)maxLiquidCrystal];
    decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    decantorLabel.textColor = [UIColor whiteColor];
    decantorLabel.shadowColor = [UIColor blackColor];
    decantorLabel.shadowOffset = CGSizeMake(1, 1);
    decantorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    decantorLabel.numberOfLines = 2;
    decantorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:decantorLabel];
    
    if ([GameSaveState sharedGameData].screenSize==2)
    {
        [mixerButton setFrame:CGRectMake(70, 315, 135*1.2, 100*1.2)];
        [beakerButton setFrame:CGRectMake(5, 365, 80*1.2, 105*1.2)];
        [distilatorImage setFrame:CGRectMake(210, 345, 140*1.2, 140*1.2)];
        bowlLabel.frame = CGRectMake(0, 365, 100*1.2, 100*1.2);
        potLabel.frame = CGRectMake(105, 300, 80*1.2, 115*1.2);
        decantorLabel.frame = CGRectMake(220, 400, 115*1.2, 115*1.2);
        
        bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.2];
        potLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.1];
        decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.2];
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        [mixerButton setFrame:CGRectMake(90, 355, 135*1.3, 100*1.3)];
        [beakerButton setFrame:CGRectMake(10, 405, 80*1.3, 105*1.3)];
        [distilatorImage setFrame:CGRectMake(235, 370, 140*1.3, 140*1.3)];
        bowlLabel.frame = CGRectMake(0, 405, 100*1.3, 100*1.3);
        potLabel.frame = CGRectMake(130, 340, 80*1.3, 115*1.3);
        decantorLabel.frame = CGRectMake(250, 420, 115*1.3, 115*1.3);
        
        bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.3];
        potLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.2];
        decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16*1.3];
    }
}

- (void)refreshInterfaceValues
{
    if ([GameSaveState sharedGameData].currentLabSetting==1) {
        pillsLabel.text = [NSString stringWithFormat:@"Sugar Cubes: %li",(long)[GameSaveState sharedGameData].pills];
        matchboxLabel.text = [NSString stringWithFormat:@"Red Taffy: %li",(long)[GameSaveState sharedGameData].matchbox];
        glassLabel.text = [NSString stringWithFormat:@"Sugar\nDust: %li",(long)[GameSaveState sharedGameData].whitePowder];
        bowlLabel.text = [NSString stringWithFormat:@"Taffy\nDust: %li",(long)[GameSaveState sharedGameData].redPowder];
    }
    else
    {
        aluminumLabel.text = [NSString stringWithFormat:@"Licorice Sticks: %li",(long)[GameSaveState sharedGameData].aluminum];
        bowlLabel.text = [NSString stringWithFormat:@"Red\nBites: %li",(long)[GameSaveState sharedGameData].greyPowder];
    }
    decantorLabel.text = [NSString stringWithFormat:@"Soft Candy:\n%li/%i",(long)[GameSaveState sharedGameData].liquidCrystal,(int)maxLiquidCrystal];
}

- (void)eachSecondTimer
{
    //Pot timer---------------------------------------------------------------------------------------------
    int potTimer=1000;
    if ([GameSaveState sharedGameData].potActive==1)
    {
        
        float presentDate = CACurrentMediaTime();
        float potDate = [GameSaveState sharedGameData].potDate;
        float secondsBetween = presentDate - potDate;
        
        potTimer = tiempoCocinar-secondsBetween;
        
        if (potTimer>tiempoCocinar) {
            [GameSaveState sharedGameData].potDate = CACurrentMediaTime();
            potDate = [GameSaveState sharedGameData].potDate;
            presentDate= CACurrentMediaTime();
            secondsBetween = presentDate - potDate;
            potTimer = tiempoCocinar-secondsBetween;
        }
        potLabel.text = [NSString stringWithFormat:@"%isec",(int)potTimer];
    }
    if (potTimer<=0)
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HizoSoftCandy"]!=YES&&[[NSUserDefaults standardUserDefaults]boolForKey:@"terminoTutorial"]!=YES)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HizoSoftCandy"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewKitchen"];
            glassButton.enabled=NO;
            bowlButton.enabled=NO;
            potButton.enabled=NO;
            backButton.enabled=YES;
            [self manejoDelTutorial:6 aparecer:1];
        }
        
        [[SoundHelper sharedSoundInstance] stopSound:11];
        [[SoundHelper sharedSoundInstance] stopSound:12];
        [[SoundHelper sharedSoundInstance] playSound:5];
        
        potLabel.text = @"Make some Candy!";
        
        [animationImageView stopAnimating];
        
        int randomCuantoMasCrystal = arc4random_uniform(((int)cuantoMasCrystal))+1;
        int faltante = (int)maxLiquidCrystal-(int)[GameSaveState sharedGameData].liquidCrystal;
        
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
        [GameSaveState sharedGameData].potDate=CACurrentMediaTime();
        [self refreshInterfaceValues];
    }
    
    //Toxicity timer-----------------------------------------------------------------------------------------
    if (currentToxicity>=[GameSaveState sharedGameData].currentExtractor&&[GameSaveState sharedGameData].currentLabBackground>=4&&[GameSaveState sharedGameData].currentLabBackground<=10)
    {
        currentToxicity = currentToxicity - ([GameSaveState sharedGameData].currentExtractor);
        if (currentToxicity>100) {
            currentToxicity=0;
        }
        extractorLabel.text = [NSString stringWithFormat:@"Kitchen Heat: %i%%",(int)currentToxicity];
        [[NSUserDefaults standardUserDefaults] setInteger:currentToxicity forKey:@"currentLabToxicity"];
        
        if (currentToxicity>50) {
            extractorLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
        }
        else
        {
            extractorLabel.textColor = [UIColor colorWithRed:0.98039 green:0.85882 blue:0.039215 alpha:1];
            extractorLabel.shadowColor = [UIColor blackColor];
            extractorLabel.shadowOffset = CGSizeMake(1, 1);
        }
    }
    if (currentToxicity<[GameSaveState sharedGameData].currentExtractor) {
        currentToxicity = 0;
        extractorLabel.text = [NSString stringWithFormat:@"Kitchen Heat: %i%%",(int)currentToxicity];
        [[NSUserDefaults standardUserDefaults] setInteger:currentToxicity forKey:@"currentLabToxicity"];
    }
    
    //Customer Arrived-----------------------------------------------------------------------------------------
    for (int i=0; i<10; i++) {
        int clientePrendido = [[ClientsAtHome sharedClientData].infoClientes[i]intValue];
        if (clientePrendido!=123)
        {
            availableCustomerImage.hidden = NO;
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)glassButtonPressed
{
    if ([GameSaveState sharedGameData].pills>=6) {
        [gameTimer invalidate];
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"glassVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        pillsLabel.font = [UIFont fontWithName:@"AllerDisplay" size:17];
        pillsLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reversePills) withObject:nil afterDelay:0.5];
    }
}

-(void)bowlButtonPressed
{
    if ([GameSaveState sharedGameData].matchbox>=1) {
        [gameTimer invalidate];
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"bowlVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        matchboxLabel.font = [UIFont fontWithName:@"AllerDisplay" size:17];
        matchboxLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseMatchbox) withObject:nil afterDelay:0.5];
    }
}

-(void)beakerButtonPressed
{
    if ([GameSaveState sharedGameData].aluminum>=1) {
        [gameTimer invalidate];
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"beakerVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [[SoundHelper sharedSoundInstance] playSound:9];
        aluminumLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
        aluminumLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseAluminum) withObject:nil afterDelay:0.5];
    }
}

-(void)backButtonPressed
{
    [gameTimer invalidate];
    [[BannerHelper sharedAd].bannerView removeFromSuperview];
    [self performSegueWithIdentifier:@"exitLabToHome" sender:self];
}

-(void)shopButtonPressed
{
    [gameTimer invalidate];
    [GameSaveState sharedGameData].currentShopList=0;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"shopVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction)unwindToLab:(UIStoryboardSegue*)unwindSegue
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"])
    {
        BOOL productPurchased=NO;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
         if ([GameSaveState sharedGameData].removeBanners==641)
         {
             productPurchased=YES;
         }
         
         if (!productPurchased)
         {
             [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height-25);
         }
        else
        {
            [BannerHelper sharedAd].bannerView.alpha = 0;
            [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height+25);
        }
    }
    
    [self eachSecondTimer];
    if ([GameSaveState sharedGameData].potActive==1) {
        if ([GameSaveState sharedGameData].currentLabSetting==1) {
            [[SoundHelper sharedSoundInstance] playSound:11];
        }
        else if ([GameSaveState sharedGameData].currentLabSetting==2) {
            [[SoundHelper sharedSoundInstance] playSound:12];
        }
    }
    
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
    
    float currentDate = CACurrentMediaTime();
    float pastDate = [GameSaveState sharedGameData].pastDate;
    float secondsBetween;
    secondsBetween = (currentDate-pastDate)*[GameSaveState sharedGameData].currentExtractor;
    
    if (secondsBetween<0) {
        [GameSaveState sharedGameData].pastDate = CACurrentMediaTime();
        currentDate = CACurrentMediaTime();
        pastDate = [GameSaveState sharedGameData].pastDate;
        secondsBetween = (currentDate-pastDate)*[GameSaveState sharedGameData].currentExtractor;
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
    [self refreshInterfaceValues];
    extractorLabel.text = [NSString stringWithFormat:@"Kitchen Heat: %i%%",(int)currentToxicity];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eachSecondTimer) userInfo:nil repeats:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HizoPowder"]==YES&&[[NSUserDefaults standardUserDefaults] boolForKey:@"HizoDust"]==YES&&[[NSUserDefaults standardUserDefaults]boolForKey:@"terminoTutorial"]!=YES)
    {
        [self manejoDelTutorial:5 aparecer:1];
        potButton.enabled=YES;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HizoSoftCandy"]==YES&&[[NSUserDefaults standardUserDefaults] boolForKey:@"terminoTutorial"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewKitchen"];
        glassButton.enabled=NO;
        bowlButton.enabled=NO;
        potButton.enabled=NO;
        backButton.enabled=YES;
        [self manejoDelTutorial:6 aparecer:1];
    }
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
        if ([GameSaveState sharedGameData].currentLabSetting==1) {
            [[SoundHelper sharedSoundInstance] playSound:11];
        }
        else if ([GameSaveState sharedGameData].currentLabSetting==2) {
            [[SoundHelper sharedSoundInstance] playSound:12];
        }
        
        if ([GameSaveState sharedGameData].level>=3&&[GameSaveState sharedGameData].currentLabBackground>=4&&[GameSaveState sharedGameData].currentLabBackground<=10) {
            currentToxicity = currentToxicity + 50;
        }
        if ([GameSaveState sharedGameData].currentLabSetting==1) {
            [GameSaveState sharedGameData].whitePowder--;
            [GameSaveState sharedGameData].redPowder--;
            
            glassLabel.text = [NSString stringWithFormat:@"Sugar\nDust: %li",(long)[GameSaveState sharedGameData].whitePowder];
            bowlLabel.text = [NSString stringWithFormat:@"Taffy\nDust: %li",(long)[GameSaveState sharedGameData].redPowder];
        }
        else
        {
            [GameSaveState sharedGameData].greyPowder--;
            
            bowlLabel.text = [NSString stringWithFormat:@"Red\nBites: %li",(long)[GameSaveState sharedGameData].greyPowder];
        }
        
        [GameSaveState sharedGameData].potDate = CACurrentMediaTime();
        [GameSaveState sharedGameData].potActive = 1;
    }
    else
    {
        if ([GameSaveState sharedGameData].whitePowder<1)
        {
            [[SoundHelper sharedSoundInstance] playSound:9];
            glassLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
            glassLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseWhitePowder) withObject:nil afterDelay:0.5];
        }
        if ([GameSaveState sharedGameData].currentLabSetting==1&&[GameSaveState sharedGameData].redPowder<1) {
            [[SoundHelper sharedSoundInstance] playSound:9];
            bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
            bowlLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseRedPowder) withObject:nil afterDelay:0.5];
        }
        if ([GameSaveState sharedGameData].currentLabSetting==2&&[GameSaveState sharedGameData].greyPowder<1) {
            [[SoundHelper sharedSoundInstance] playSound:9];
            bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
            bowlLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseRedPowder) withObject:nil afterDelay:0.5];
        }
        if ([GameSaveState sharedGameData].liquidCrystal>maxLiquidCrystal-cuantoMasCrystal)
        {
            [[SoundHelper sharedSoundInstance] playSound:9];
            decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:18];
            decantorLabel.textColor = [UIColor redColor];
            [self performSelector:@selector(reverseLiquidCrystal) withObject:nil afterDelay:0.5];
        }
    }
}

- (void)reverseWhitePowder
{
    glassLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    glassLabel.textColor = [UIColor whiteColor];
}
- (void)reverseRedPowder
{
    bowlLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    bowlLabel.textColor = [UIColor whiteColor];
}
- (void)reverseLiquidCrystal
{
    decantorLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    decantorLabel.textColor = [UIColor whiteColor];
}
- (void)reversePills
{
    pillsLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    pillsLabel.textColor = [UIColor blackColor];
}
- (void)reverseMatchbox
{
    matchboxLabel.font = [UIFont fontWithName:@"AllerDisplay" size:16];
    matchboxLabel.textColor = [UIColor blackColor];
}
- (void)reverseAluminum
{
    aluminumLabel.font = [UIFont fontWithName:@"AllerDisplay" size:14];
    if ([GameSaveState sharedGameData].screenSize==1) {
        aluminumLabel.font = [UIFont fontWithName:@"AllerDisplay" size:12];
    }
    aluminumLabel.textColor = [UIColor blackColor];
}

- (void)animateChange:(int)cuanto cual:(int)cualLabel
{
    CGSize screenbounds = [[UIScreen mainScreen] bounds].size;
    int randomX = (screenbounds.width/2-100)+arc4random_uniform(200);
    //int randomX = arc4random_uniform(170)+75;
    int randomY = arc4random_uniform(100)+350;
    
    UILabel *animation;
    
    if (cualLabel==1) {
        animation = animationLabel;
        animation.text = [NSString stringWithFormat:@"+%i Soft Candy",cuanto];
    }
    else
    {
        animation = animationXp;
        animation.text = [NSString stringWithFormat:@"+%i Xp",cuanto];
    }
    
    animation.textAlignment = NSTextAlignmentCenter;
    animation.font = [UIFont fontWithName:@"AllerDisplay" size:30];
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
    [GameSaveState sharedGameData].pastDate = CACurrentMediaTime();
    [[SoundHelper sharedSoundInstance] stopSound:11];
    [[SoundHelper sharedSoundInstance] stopSound:12];
    [super viewWillDisappear:animated];
}

- (IBAction)availableCustomerPressed:(id)sender
{
    [GameSaveState sharedGameData].scrollToTheLeftLab=1;
    [self backButtonPressed];
}
@end