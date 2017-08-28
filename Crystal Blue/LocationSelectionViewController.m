//
//  LocationSelectionViewController.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/12/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "LocationSelectionViewController.h"
#import "ClientsAtHome.h"

@interface LocationSelectionViewController ()

@end

@implementation LocationSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self iniciarTablas];
    [self startInterface];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iniciarTablas
{
    locationButtonArray = [[NSMutableArray alloc] init];
    dangerLabelArray = [[NSMutableArray alloc] init];
    nameArray = [NSArray arrayWithObjects:
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
    
    for (int i = 0; i<10; i++) {
        UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [locationButtonArray addObject:locationButton];
        
        UILabel *label = [[UILabel alloc] init];
        [dangerLabelArray addObject:label];
    }
    
}

-(void)startInterface
{
    float textSize = 1;
    float rectSize = 40;
    float screenX = 0;
    float screenY = 0;
    
    if ([GameSaveState sharedGameData].screenSize==1) {
        titleLabel.center = CGPointMake(160, 30);
        infoLabel.center = CGPointMake(160, 425);
        
        rectSize = 33;
        textSize = 0.8;
    }
    else if ([GameSaveState sharedGameData].screenSize==2)
    {
        textSize = 1.1;
        rectSize = 50;
        screenX = 40;
        screenY = 20;
    }
    else if ([GameSaveState sharedGameData].screenSize==3)
    {
        textSize = 1.2;
        rectSize = 50;
        screenX = 50;
        screenY = 30;
    }
    
    titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:40*textSize];
    infoLabel.font =  [UIFont fontWithName:@"AllerDisplay" size:15*textSize];
    if ([ClientsAtHome sharedClientData].contractsCustomerPressed<10) {
        infoLabel.text = @"The more they love your candy the higher the chance of being able to sell them! (Increase your love by hosting events!)";
    }
    else if ([ClientsAtHome sharedClientData].contractsCustomerPressed>9) {
        infoLabel.text = @"The more they love your candy the higher the chance of your advertise working! (Increase your love by hosting events!)";
    }
    
    for (int i=0; i<10; i++) {
        NSString *name = nameArray[i];
        UIButton *locationButton = locationButtonArray[i];
        [locationButton setTag:i];
        [locationButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [locationButton setTitle:[NSString stringWithFormat:@"..%@..",name] forState:UIControlStateNormal];
        locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        locationButton.frame = CGRectMake(50+screenX, 60+screenY+(rectSize*i), 220, 40);
        locationButton.titleLabel.font = [UIFont fontWithName:@"AllerDisplay" size:20*textSize];
        locationButton.tintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        [self.view addSubview:locationButton];
        
        UILabel *dangerLabel = dangerLabelArray[i];
        dangerLabel.frame = CGRectMake(190+screenX, 60+screenY+(rectSize*i), 80, 40);
        int danger = 100-[[ClientsAtHome sharedClientData].valoresDangerEnRegion[i]intValue];
        dangerLabel.text = [NSString stringWithFormat:@"%i%%",danger];
        dangerLabel.textAlignment = NSTextAlignmentCenter;
        dangerLabel.font = [UIFont fontWithName:@"AllerDisplay" size:22*textSize];
        
        if (danger>=75) {
            [dangerLabel setTextColor:[UIColor colorWithRed:0 green:0.5 blue:0 alpha:1]];
        }
        else if (danger<75&&danger>=50) {
            [dangerLabel setTextColor:[UIColor colorWithRed:0.9 green:0.8 blue:0 alpha:1]];
        }
        else if (danger<50&&danger>=25) {
            [dangerLabel setTextColor:[UIColor colorWithRed:0.9 green:0.5 blue:0 alpha:1]];
        }
        else {
            [dangerLabel setTextColor:[UIColor colorWithRed:0.6 green:0 blue:0 alpha:1]];
        }
        
        [self.view addSubview:dangerLabel];
    }
    [self disableUsed];
}

-(void)disableUsed
{
    int inicio=0;
    NSMutableArray *posibles = [[NSMutableArray alloc]init];
    
    if ([ClientsAtHome sharedClientData].contractsCustomerPressed<10) {
        inicio=0;
    }
    else if ([ClientsAtHome sharedClientData].contractsCustomerPressed>9) {
        inicio=10;
    }
    for (int i=inicio; i<[ClientsAtHome sharedClientData].placeSentTo.count-(10-inicio); i++) {
        [posibles addObject:[ClientsAtHome sharedClientData].placeSentTo[i]];
    }
    
    for (int i = 0; i<10; i++) {
        NSString *nombre = nameArray[i];
        if ([posibles containsObject:nombre])
        {
            UIButton *locationButton = locationButtonArray[i];
            locationButton.enabled = NO;
        }
        
    }
    
}

-(void)buttonPressed:(UIButton *)sender
{
    NSInteger cualFue = sender.tag;
    
    [[ClientsAtHome sharedClientData].placeSentTo replaceObjectAtIndex:[ClientsAtHome sharedClientData].contractsCustomerPressed withObject:nameArray[cualFue]];
    
    [self performSegueWithIdentifier:@"exitLocationSelection" sender:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
