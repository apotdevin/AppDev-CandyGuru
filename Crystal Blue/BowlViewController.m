//
//  BowlViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/5/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "BowlViewController.h"
#import "BannerHelper.h"

@interface BowlViewController ()

@end

@implementation BowlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL productPurchased=NO;
    if ([GameSaveState sharedGameData].removeBanners==641) {
        productPurchased=YES;
    }
    if (!productPurchased) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        porcentaje.center=CGPointMake(screenBounds.size.width/2, 90);
        [self.view addSubview:[BannerHelper sharedAd].bannerView];
        [BannerHelper sharedAd].bannerView.center = CGPointMake(screenBounds.size.width/2, 25);
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
    
    [self iniciarJuego];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iniciarJuego
{
    fondo.image = [UIImage imageNamed:@"1_Pills"];
    
    progressPorcent = 0;
    porcentaje.font = [UIFont fontWithName:@"AllerDisplay" size:70];
    porcentaje.text = [NSString stringWithFormat:@"0%%"];
    //porcentaje.textColor = [UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1];
    
    dondePresionar.hidden = YES;
    
    pills.text = [NSString stringWithFormat:@"Sugar Cubes: %li",(long)[GameSaveState sharedGameData].pills];
    powder.text = [NSString stringWithFormat:@"Sugar Dust: %li",(long)[GameSaveState sharedGameData].whitePowder];
    pills.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    powder.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    backButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    //[backButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    
    
    tutLabel = [[UILabel alloc]init];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    tutLabel.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    tutLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tutLabel.numberOfLines = 30;
    tutLabel.textAlignment = NSTextAlignmentCenter;
    tutLabel.font = [UIFont fontWithName:@"AllerDisplay" size:50];
    tutLabel.textColor = [UIColor redColor];
    tutLabel.text = @"\n\n\n\n\nPress the Spot!";
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"tutBowl"]!=YES)
    {
        tutLabel.hidden = NO;
    }
    else
    {
        tutLabel.hidden = YES;
    }
    
    [self.view addSubview:tutLabel];
    
    
    juego = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(juego) userInfo:nil repeats:YES];
}

-(void)juego
{
    int xCenter = 0;
    int yCenter = 0;
    int iphone4 = 0;
    
    if ([GameSaveState sharedGameData].screenSize==1)
    {
        iphone4 = 34;
        yCenter = -40;
    }
    if ([GameSaveState sharedGameData].screenSize==2)
    {
        xCenter = 60;
        yCenter = 70;
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        xCenter = 80;
        yCenter = 90;
    }
    
    randomX = arc4random()%(270+xCenter)+25;
    randomY = (arc4random()%(270+yCenter)+170)-iphone4;
    
    dondePresionar.center = CGPointMake(randomX, randomY);
    dondePresionar.hidden = NO;
    
    if ([GameSaveState sharedGameData].pills>=6) {
        
        if (progressPorcent>=100) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutBowl"];
            
            progressPorcent = 0;
            
            [GameSaveState sharedGameData].pills-=6;
            [GameSaveState sharedGameData].whitePowder++;
            [GameSaveState sharedGameData].totalWhitePowder++;
            [[GameCenterHelper sharedGC] makeWhiteAchievements];
            
            [self refreshInterface];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HizoDust"]!=YES)
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HizoDust"];
            }
            
            if ([GameSaveState sharedGameData].pills<=5)
            {
                [juego invalidate];
                
                [self performSegueWithIdentifier:@"exitBowl" sender:self];
            }
            
        }
    }
    else
    {
        [juego invalidate];
        
        [self performSegueWithIdentifier:@"exitBowl" sender:self];
    }
    [self ponerFondo];
}

-(void)ponerFondo
{
    if (progressPorcent<13)
    {
        fondo.image = [UIImage imageNamed:@"1_Pills"];
    }
    else if (progressPorcent>=13&&progressPorcent<26) {
        fondo.image = [UIImage imageNamed:@"2_Pills"];
    }
    else if (progressPorcent>=26&&progressPorcent<39) {
        fondo.image = [UIImage imageNamed:@"3_Pills"];
    }
    else if (progressPorcent>=39&&progressPorcent<52) {
        fondo.image = [UIImage imageNamed:@"4_Pills"];
    }
    else if (progressPorcent>=52&&progressPorcent<65) {
        fondo.image = [UIImage imageNamed:@"5_Pills"];
    }
    else if (progressPorcent>=65&&progressPorcent<78) {
        fondo.image = [UIImage imageNamed:@"6_Pills"];
    }
    else if (progressPorcent>=78&&progressPorcent<90) {
        fondo.image = [UIImage imageNamed:@"7_Pills"];
    }
    else if (progressPorcent>=90&&progressPorcent<100) {
        fondo.image = [UIImage imageNamed:@"8_Pills"];
    }
    if ([GameSaveState sharedGameData].pills<=0) {
        fondo.image = [UIImage imageNamed:@"9_Pills"];
    }
}

-(void)refreshInterface
{
    pills.text = [NSString stringWithFormat:@"Sugar Cubes: %li",(long)[GameSaveState sharedGameData].pills];
    powder.text = [NSString stringWithFormat:@"Sugar Dust: %li",(long)[GameSaveState sharedGameData].whitePowder];
    [porcentaje setText:[NSString stringWithFormat:@"%d%%",(int)progressPorcent]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: nil];
    
    int posX = currentPos.x;
    int posY = currentPos.y;
    
    int maxX = randomX+25;
    int minX = randomX-25;
    
    int maxY = randomY+25;
    int minY = randomY-25;
    
    NSInteger glassLevel = 0;
    NSInteger currentGlass = [GameSaveState sharedGameData].currentGlass;
    
    if (currentGlass==1) {
        glassLevel = arc4random_uniform(5)+5;
    }
    else if (currentGlass==2)
    {
        glassLevel = arc4random_uniform(5)+7;
    }
    else if (currentGlass==3)
    {
        glassLevel = arc4random_uniform(5)+9;
    }
    else
    {
        glassLevel = arc4random_uniform(5)+11;
    }
    
    if (posX>=minX&&posX<=maxX&&posY<=maxY&&posY>=minY) {
        
        progressPorcent = progressPorcent+glassLevel;
        if (progressPorcent<=100) {
            [porcentaje setText:[NSString stringWithFormat:@"%i%%",(int)progressPorcent]];
        }
        else
        {
            [porcentaje setText:[NSString stringWithFormat:@"100%%"]];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)backPressed:(UIButton *)sender
{
    [juego invalidate];
}
@end
