//
//  MapViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/16/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "MapViewController.h"
#import "ClientsAtHome.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    [[GameCenterHelper sharedGC] reachDominationAchievements];
    
    NSInteger screenSize = [GameSaveState sharedGameData].screenSize;
    backButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20];
    //[backButton setTitleColor:[UIColor colorWithRed:0.988 green:0.655 blue:0 alpha:1] forState:UIControlStateNormal];
    /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstViewMap"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstViewMap"];
    }
    
    else
    {
        
    }*/
    
    int spacingX = 0;
    int spacingY = 0;
    int screenX = 0;
    int screenY = 0;
    float textSize = 1;
    float placesSize = 1;
    int mapX = 0;
    int dominanceX = 0;
    
    if ([GameSaveState sharedGameData].screenSize==2)
    {
        mapX = 15;
        dominanceX = 20;
        textSize = 1.1;
        screenX = 10;
        screenY = 70;
        spacingX = 5;
        spacingY = 20;
        placesSize = 1.2;
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        mapX = 15;
        dominanceX = 25;
        textSize = 1.2;
        screenX = 15;
        screenY = 110;
        spacingX = 10;
        spacingY = 35;
        placesSize = 1.3;
    }
    
    
    NSArray *sellsForDominance = [NSArray arrayWithObjects:
                          @1800,
                          @1950,
                          @2150,
                          @2000,
                          @2200,
                          @2050,
                          @1970,
                          @1630,
                          @2180,
                          @2090,
                          nil];
    NSArray *names = [NSArray arrayWithObjects:
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
    int arrayNum = 0;
    
    int totalSellsForDominance=0;
    for (int i=0; i<sellsForDominance.count; i++) {
        totalSellsForDominance = totalSellsForDominance+[sellsForDominance[i]intValue];
    }
    
    int totalVisits=0;
    for (int i=0; i<10; i++) {
        totalVisits = totalVisits + [[ClientsAtHome sharedClientData].timesSentToEachPlace[i]intValue];
    }
    
    UIImageView *mapImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MapView"]];
    mapImage.frame = CGRectMake(-3+mapX, 15, 320*textSize, 200*textSize);
    [self.view addSubview:mapImage];
    
    UILabel *completeDominance = [[UILabel alloc]initWithFrame:CGRectMake(37+dominanceX, 5, 250*textSize, 30*textSize)];
    completeDominance.font = [UIFont fontWithName:@"AllerDisplay" size:18*textSize];
    float dominance = (float)(totalVisits*100)/totalSellsForDominance;
    if (dominance>=100) {
        dominance=100.0;
    }
    completeDominance.text = [NSString stringWithFormat:@"Global Popularity: %1.5f%%",dominance];
    completeDominance.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:completeDominance];
    
    UILabel *zone1Label = [[UILabel alloc]initWithFrame:CGRectMake(35+mapX, 45, 100*placesSize, 30*placesSize)];
    zone1Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone1Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone1Label];
    arrayNum++;
    
    UILabel *zone2Label = [[UILabel alloc]initWithFrame:CGRectMake(120+mapX, 50, 100*placesSize, 30*placesSize)];
    zone2Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone2Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone2Label];
    arrayNum++;
    
    UILabel *zone3Label = [[UILabel alloc]initWithFrame:CGRectMake(230+mapX, 70, 100*placesSize, 30*placesSize)];
    zone3Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone3Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone3Label];
    arrayNum++;
    
    UILabel *zone4Label = [[UILabel alloc]initWithFrame:CGRectMake(20+mapX, 110, 100*placesSize, 30*placesSize)];
    zone4Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone4Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone4Label];
    arrayNum++;
    
    UILabel *zone5Label = [[UILabel alloc]initWithFrame:CGRectMake(130+mapX, 85, 100*placesSize, 30*placesSize)];
    zone5Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone5Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone5Label];
    arrayNum++;
    
    UILabel *zone6Label = [[UILabel alloc]initWithFrame:CGRectMake(145+mapX, 130, 100*placesSize, 30*placesSize)];
    zone6Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone6Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone6Label];
    arrayNum++;
    
    UILabel *zone7Label = [[UILabel alloc]initWithFrame:CGRectMake(210+mapX, 110, 100*placesSize, 30*placesSize)];
    zone7Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone7Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone7Label];
    arrayNum++;
    
    UILabel *zone8Label = [[UILabel alloc]initWithFrame:CGRectMake(70+mapX, 150, 100*placesSize, 30*placesSize)];
    zone8Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone8Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone8Label];
    arrayNum++;
    
    UILabel *zone9Label = [[UILabel alloc]initWithFrame:CGRectMake(170+mapX, 160, 100*placesSize, 30*placesSize)];
    zone9Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone9Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone9Label];
    arrayNum++;
    
    UILabel *zone10Label = [[UILabel alloc]initWithFrame:CGRectMake(240+mapX, 170, 100*placesSize, 30*placesSize)];
    zone10Label.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
    zone10Label.text = [NSString stringWithFormat:@"%i. %@",arrayNum+1,names[arrayNum]];
    [self.view addSubview:zone10Label];
    
    for (int j=0; j<4; j++) {
        for (int i=-1; i<10; i++) {
            UILabel *zoneInfo = [[UILabel alloc]init];
            
            if (j==0) {
                if (i==-1) {
                    zoneInfo.text = @".Zone.";
                    zoneInfo.textAlignment = NSTextAlignmentLeft;
                }
                else
                {
                    zoneInfo.text = [NSString stringWithFormat:@"%i. %@.",(i+1),names[i]];
                    zoneInfo.textAlignment = NSTextAlignmentLeft;
                }
                zoneInfo.frame = CGRectMake(17+(60+spacingX)*j+screenX, (240-15*screenSize)+(30-8*screenSize+spacingY)*i+screenY, 95*placesSize, 30*placesSize);
            }
            else if (j==1)
            {
                if (i==-1) {
                    zoneInfo.text = @".Love.";
                }
                else
                {
                    int danger = 100-[[ClientsAtHome sharedClientData].valoresDangerEnRegion[i]intValue];
                    zoneInfo.text = [NSString stringWithFormat:@"%i%%",danger];
                }
                zoneInfo.frame = CGRectMake(7+(70+spacingX)*j+screenX, (240-15*screenSize)+(30-8*screenSize+spacingY)*i+screenY, 80*placesSize, 30*placesSize);
                zoneInfo.textAlignment = NSTextAlignmentRight;
            }
            else if (j==2)
            {
                if (i==-1) {
                    zoneInfo.text = @".Visits.";
                }
                else
                {
                    int times = [[ClientsAtHome sharedClientData].timesSentToEachPlace[i]intValue];
                    zoneInfo.text = [NSString stringWithFormat:@"%i",times];
                }
                zoneInfo.frame = CGRectMake(12+(67+spacingX)*j+screenX, (240-15*screenSize)+(30-8*screenSize+spacingY)*i+screenY, 90*placesSize, 30*placesSize);
                zoneInfo.textAlignment = NSTextAlignmentCenter;
            }
            else if (j==3)
            {
                if (i==-1) {
                    zoneInfo.text = @".Popularity.";
                }
                else
                {
                    int times = [[ClientsAtHome sharedClientData].timesSentToEachPlace[i]intValue];
                    int forDominance = [sellsForDominance[i]intValue];
                    
                    float percent = 0;
                    if (times<=forDominance) {
                        percent = ((float)times/forDominance)*100;
                    }
                    else
                    {
                        percent=100;
                    }
                    
                    zoneInfo.text = [NSString stringWithFormat:@"%1.2f%%",percent];
                }
                zoneInfo.frame = CGRectMake(0+(71+spacingX)*j+screenX, (240-15*screenSize)+(30-8*screenSize+spacingY)*i+screenY, 90*placesSize, 30*placesSize);
                zoneInfo.textAlignment = NSTextAlignmentRight;
            }
            
            zoneInfo.font = [UIFont fontWithName:@"AllerDisplay" size:14*placesSize];
            //zoneInfo.textColor = [UIColor colorWithRed:0.98039 green:0.85882 blue:0.039215 alpha:1];
            zoneInfo.shadowColor = [UIColor whiteColor];
            zoneInfo.shadowOffset = CGSizeMake(1, 1);
            
            [self.view addSubview:zoneInfo];
        }
    }
    
    if (screenSize==1) {
        backButton.center = CGPointMake(160, 550-88);
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
