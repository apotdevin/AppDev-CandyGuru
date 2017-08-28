//
//  LaboratoryViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/4/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "LaboratoryViewController.h"

@interface LaboratoryViewController ()

@end

@implementation LaboratoryViewController

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
    
    [self inicializarTodo];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inicializarTodo
{
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eachSecondTimer) userInfo:nil repeats:YES];
    
    xpLab = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentXp"];
    
    currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
    currentLabBackground1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLabBackground"];
    currentLabSetting1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLabSetting"];
    currentGlass1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentGlass"];
    currentBowl1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentBowl"];
    currentPot1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPot"];
    currentDecantor1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentDecantor"];
    currentExtractor1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentExtractor"];
    currentBeaker1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentBeaker"];
    currentMixer1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentMixer"];
    currentDistilator1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentDistilator"];
    
    currentCrystal = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCrystal"];
    currentPills = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPills"];
    currentMatchbox = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentMatchbox"];
    currentAluminum = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAluminum"];
    
    whitePowder = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentWhitePowder"];
    redPowder = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentRedPowder"];
    liquidCrystal = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentLiquidCrystal"];
    
    NSString *cualFondo = [NSString stringWithFormat:@"labFondo%d",currentLabBackground1];
    [imagenDeFondo setImage:[UIImage imageNamed:cualFondo]];
    
    fridgeWindow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labWindow"]];
    fridgeWindow.frame = CGRectMake(3, 3, 130, 200);
    [self.view addSubview:fridgeWindow];
    
    crystalLabel = [[UILabel alloc] init];
    crystalLabel.frame = CGRectMake(5,60,120,20);
    crystalLabel.text = [NSString stringWithFormat:@"Crystal: %i",currentCrystal];
    crystalLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [self.view addSubview:crystalLabel];
    
    cuantoMasCrystal=0;
    tiempoCocinar=0;
    maxLiquidCrystal=0;
    
    if (currentLabSetting1==1) {
        cuantoMasCrystal=currentPot1;
        tiempoCocinar=TIEMPO_COOK+1-currentPot1;
        maxLiquidCrystal=2+(currentDecantor1*3);
    }
    else
    {
        cuantoMasCrystal=4+currentMixer1;
        tiempoCocinar=TIEMPO_COOK-3-currentMixer1;
        maxLiquidCrystal=14+(currentDistilator1);
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewLab"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewLab"];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"potDate"];
    }
    else
    {
        
    }
    
    if (currentLabSetting1==1)
    {
        [self setupFirstLab];
    }
    else
    {
        [self setupSecondLab];
    }
    if (currentLevel>=3&&currentLabBackground1>=4)
    {
        [self setupExtractor];
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
}

- (void)setupExtractor
{
    NSString *cualExtractor = [NSString stringWithFormat:@"Extractor%d",currentExtractor1];
    extractorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:cualExtractor]];
    [extractorImage setFrame:CGRectMake(145, -80, 70, 206)];
    [self.view addSubview:extractorImage];
    
    NSTimeInterval secondsBetween;
    NSDate *currentDate = [NSDate date];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewLab"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewLab"];
        pastDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:pastDate forKey:@"labDate"];
        secondsBetween = 0;
    }
    else
    {
        pastDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"labDate"];
        [[NSUserDefaults standardUserDefaults]setObject:pastDate forKey:@"labDate"];
        secondsBetween = [currentDate timeIntervalSinceDate:pastDate]*currentExtractor1;
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
    extractorLabel.frame = CGRectMake(3, 150, 130, 60);
    extractorLabel.font = [UIFont fontWithName:@"28 Days Later" size:20];
    extractorLabel.textAlignment = NSTextAlignmentCenter;
    extractorLabel.text = [NSString stringWithFormat:@"Lab Toxicity: %i%%",currentToxicity];
    extractorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    extractorLabel.numberOfLines = 2;
    extractorLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:extractorLabel];
    
}

- (void)setupFirstLab
{
    pillsLabel = [[UILabel alloc] init];
    pillsLabel.frame = CGRectMake(5, 80, 120, 20);
    pillsLabel.text = [NSString stringWithFormat:@"Pills: %i",currentPills];
    pillsLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [self.view addSubview:pillsLabel];
    
    matchboxLabel = [[UILabel alloc] init];
    matchboxLabel.frame = CGRectMake(5, 100, 120, 20);
    matchboxLabel.text = [NSString stringWithFormat:@"Matchboxes: %i",currentMatchbox];
    matchboxLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [self.view addSubview:matchboxLabel];
    
    heater = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"heater"]];
    heater.frame = CGRectMake(130, 340, 91, 46);
    [self.view addSubview:heater];
    
    base = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LabSupport"]];
    base.frame = CGRectMake(230, 370, 91, 46);
    [self.view addSubview:base];
    
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
    [decantorImage setFrame:CGRectMake(250, 265, 51, 133)];
    [self.view addSubview:decantorImage];
    
    glassLabel = [[UILabel alloc]init];
    glassLabel.frame = CGRectMake(5, 295, 90, 100);
    glassLabel.text = [NSString stringWithFormat:@"White Powder: %i",whitePowder];
    glassLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    glassLabel.textColor = [UIColor whiteColor];
    glassLabel.lineBreakMode = NSLineBreakByWordWrapping;
    glassLabel.numberOfLines = 2;
    glassLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:glassLabel];
    
    bowlLabel = [[UILabel alloc]init];
    bowlLabel.frame = CGRectMake(60, 365, 74, 80);
    bowlLabel.text = [NSString stringWithFormat:@"Red Powder: %i",redPowder];
    bowlLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    bowlLabel.textColor = [UIColor whiteColor];
    bowlLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bowlLabel.numberOfLines = 2;
    bowlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bowlLabel];
    
    potLabel = [[UILabel alloc]init];
    potLabel.frame = CGRectMake(135, 250, 80, 115);
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"potDate"]isEqual:@0]) {
        NSDate *presentDate = [NSDate date];
        potDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"potDate"];
        NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:potDate];
        
        potTimer = tiempoCocinar-secondsBetween;
        if (potTimer<=0) {
            potLabel.text = @"Done!";
        }
        else
        {
            potLabel.text = [NSString stringWithFormat:@"%isec",potTimer];
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
    decantorLabel.text = [NSString stringWithFormat:@"Liquid Crystal: %i/%i",liquidCrystal,maxLiquidCrystal];
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
    aluminumLabel.frame = CGRectMake(5, 80, 120, 20);
    aluminumLabel.text = [NSString stringWithFormat:@"Aluminum roll: %i",currentAluminum];
    aluminumLabel.font = [UIFont fontWithName:@"28 Days Later" size:16];
    [self.view addSubview:aluminumLabel];
    
    mixerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mixerButton addTarget:self action:@selector(mixerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
}

- (void)refreshInterfaceValues
{
    crystalLabel.text = [NSString stringWithFormat:@"Crystal: %i",currentCrystal];
    pillsLabel.text = [NSString stringWithFormat:@"Pills: %i",currentPills];
    matchboxLabel.text = [NSString stringWithFormat:@"Matchboxes: %i",currentMatchbox];
    glassLabel.text = [NSString stringWithFormat:@"White Powder: %i",whitePowder];
    bowlLabel.text = [NSString stringWithFormat:@"Red Powder: %i",redPowder];
    decantorLabel.text = [NSString stringWithFormat:@"Liquid Crystal: %i",liquidCrystal];
}

- (void)eachSecondTimer
{
    if (currentLabSetting1==1) {
        //Pot timer---------------------------------------------------------------------------------------------
        if (![potLabel.text isEqualToString:@"Cook some Crystal!"])
        {
            started = 1;
            
            NSDate *presentDate = [NSDate date];
            potDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"potDate"];
            NSTimeInterval secondsBetween = [presentDate timeIntervalSinceDate:potDate];
            
            potTimer = tiempoCocinar-secondsBetween;
            potLabel.text = [NSString stringWithFormat:@"%isec",potTimer];
        }
        if (potTimer<=0)
        {
            if (started==1)
            {
                [self sonidoMoney];
                
                potLabel.text = @"Cook some Crystal!";
                started = 0;
                
                whitePowder = whitePowder-1;
                redPowder = redPowder-1;
                liquidCrystal = liquidCrystal+cuantoMasCrystal;
                
                [self animateChange:cuantoMasCrystal cual:1];
                [self animateChange:2*currentLevel cual:2];
                
                int totalLiquidCrystal = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalLiquidCrystal"]+1;
                [[NSUserDefaults standardUserDefaults] setInteger:totalLiquidCrystal forKey:@"totalLiquidCrystal"];
                
                int xp = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentXp"]+(2*currentLevel);
                [[NSUserDefaults standardUserDefaults]setInteger:xp forKey:@"currentXp"];
                [[NSUserDefaults standardUserDefaults]setInteger:whitePowder forKey:@"currentWhitePowder"];
                [[NSUserDefaults standardUserDefaults]setInteger:redPowder forKey:@"currentRedPowder"];
                [[NSUserDefaults standardUserDefaults]setInteger:liquidCrystal forKey:@"currentLiquidCrystal"];
                [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"potDate"];
                [self refreshInterfaceValues];
            }
        }
    }
        //Toxicity timer-----------------------------------------------------------------------------------------
    if (currentToxicity>currentExtractor1&&currentLevel>=3) {
        currentToxicity = currentToxicity - currentExtractor1;
        extractorLabel.text = [NSString stringWithFormat:@"Lab Toxicity: %i%%",currentToxicity];
        [[NSUserDefaults standardUserDefaults] setInteger:currentToxicity forKey:@"currentLabToxicity"];
        
        if (currentToxicity>50) {
            extractorLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
        }
        else
        {
            extractorLabel.textColor = [UIColor whiteColor];
        }
    }
    if (currentToxicity<currentExtractor1) {
        currentToxicity = 0;
        extractorLabel.text = [NSString stringWithFormat:@"Lab Toxicity: %i%%",currentToxicity];
        [[NSUserDefaults standardUserDefaults] setInteger:currentToxicity forKey:@"currentLabToxicity"];
    }
}

- (IBAction)regresarButton:(id)sender
{
    
}

- (void)increaseXpLab:(int)cuantoMas
{
    xpLab = xpLab+cuantoMas;
    [[NSUserDefaults standardUserDefaults] setInteger:xpLab forKey:@"currentXp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)glassButtonPressed
{
    if (currentPills>=6) {
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"glassVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)bowlButtonPressed
{
    if (currentMatchbox>=1) {
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"bowlVC"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)potButtonPressed
{
    if (whitePowder>=1&&redPowder>=1&&currentToxicity<=50&&liquidCrystal<=maxLiquidCrystal-cuantoMasCrystal) {
        if ([potLabel.text isEqualToString:@"Cook some Crystal!"])
        {
            potLabel.text = [NSString stringWithFormat:@"%isec",tiempoCocinar];
            potTimer = tiempoCocinar;
            if (currentLevel>=3&&currentLabBackground1>=4) {
                currentToxicity = currentToxicity + 50;
            }
            glassLabel.text = [NSString stringWithFormat:@"White Powder: %i",whitePowder-1];
            bowlLabel.text = [NSString stringWithFormat:@"Red Powder: %i",redPowder-1];
            
            potDate = [NSDate date];
            [[NSUserDefaults standardUserDefaults]setObject:potDate forKey:@"potDate"];
        }
    }
    if (whitePowder<1)
    {
        glassLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
        glassLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseWhitePowder) withObject:nil afterDelay:0.5];
    }
    if (redPowder<1)
    {
        bowlLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
        bowlLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseRedPowder) withObject:nil afterDelay:0.5];
    }
    if (liquidCrystal>maxLiquidCrystal-cuantoMasCrystal)
    {
        decantorLabel.font = [UIFont fontWithName:@"28 Days Later" size:18];
        decantorLabel.textColor = [UIColor redColor];
        [self performSelector:@selector(reverseLiquidCrystal) withObject:nil afterDelay:0.5];
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

-(void)beakerButtonPressed
{
    
}

-(void)mixerButtonPressed
{
    
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
    [gameTimer invalidate];
    
    pastDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:pastDate forKey:@"labDate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
