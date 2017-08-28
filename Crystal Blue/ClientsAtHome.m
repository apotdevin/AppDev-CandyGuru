//
//  ClientsAtHome.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/21/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "ClientsAtHome.h"

@implementation ClientsAtHome

+ (instancetype)sharedClientData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)newGame
{
    _valoresDangerOriginal = [[NSMutableArray alloc]init];
    _valoresDangerEnRegion = [[NSMutableArray alloc]init];
    _timesSentToEachPlace = [[NSMutableArray alloc]init];
    _infoClientes = [[NSMutableArray alloc]init];
    _infoZone = [[NSMutableArray alloc]init];
    _completeFreezersOnOrOff = [[NSMutableArray alloc]init];
    _individualTraysOnOrOff = [[NSMutableArray alloc]init];
    _individualTrayDates = [[NSMutableArray alloc]init];
    _peopleOnOrOff = [[NSMutableArray alloc]init];
    _peopleStartDate = [[NSMutableArray alloc]init];
    _placeSentTo = [[NSMutableArray alloc]init];
    
    [self startDangerArray];
    
    for (int i=0; i<10; i++) {
        [_timesSentToEachPlace addObject:@0];
        [_infoClientes addObject:@123];
    }
    
    for (int i=0; i<4; i++) {
        [_infoZone addObject:@123];
    }
    
    for (int i=0; i<7; i++)
    {
        [_completeFreezersOnOrOff addObject:@"NO"];
    }
    for (int i=0; i<18; i++) {
        [_individualTraysOnOrOff addObject:@"APAGADO"];
        [_individualTrayDates addObject:@"NO"];
    }
    
    for (int i=0; i<20; i++) {
        [_peopleOnOrOff addObject:@"NONE"];
        [_peopleStartDate addObject:@"NONE"];
        [_placeSentTo addObject:@"NONE"];
    }
    _dangerClientOnOrOff = 0;
    _dangerStartDate = CACurrentMediaTime();
    _whichDanger = 0;
    _appLaunchDate = CACurrentMediaTime();
    _boostActivated = 0;
    //_boostLaunchDate = [NSDate date];
    _boostLaunchDate = CACurrentMediaTime();
    
    _valoresDangerEnRegion = [NSMutableArray arrayWithArray:_valoresDangerOriginal];
    _alturaZone = 135;
    _randomPresent=0;
    _contractsPosition = 0;
    _homeViewPosition = 0;
    _contractsCustomerPressed=0;
}

-(void)loadGame
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _valoresDangerOriginal = [[NSMutableArray alloc]init];
    _valoresDangerEnRegion = [[NSMutableArray alloc]init];
    _timesSentToEachPlace = [[NSMutableArray alloc]init];
    _infoClientes = [[NSMutableArray alloc]init];
    _infoZone = [[NSMutableArray alloc]init];
    _completeFreezersOnOrOff = [[NSMutableArray alloc]init];
    _individualTraysOnOrOff = [[NSMutableArray alloc]init];
    _individualTrayDates = [[NSMutableArray alloc]init];
    _peopleOnOrOff = [[NSMutableArray alloc]init];
    _peopleStartDate = [[NSMutableArray alloc]init];
    _placeSentTo = [[NSMutableArray alloc]init];
    
    BOOL valid = NO;
    NSArray *clientSaveArray = [NSArray arrayWithArray:[defaults secureObjectForKey:@"clientSaveArray" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome");
        _dangerStartDate = CACurrentMediaTime();
        _whichDanger = 0;
        _appLaunchDate = CACurrentMediaTime();
    }
    else
    {
        if ([clientSaveArray[0] isKindOfClass:[NSDate class]]) {
            _dangerStartDate = CACurrentMediaTime();
        }
        else
        {
            _dangerStartDate = [clientSaveArray[0] floatValue];
        }
        
        
        _whichDanger = [clientSaveArray[1]integerValue];
        
        if ([clientSaveArray[2] isKindOfClass:[NSDate class]]) {
            _appLaunchDate = CACurrentMediaTime();
        }
        else
        {
            _appLaunchDate = [clientSaveArray[2] floatValue];
        }
    }
    
    valid = NO;
    _valoresDangerOriginal = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"1" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome valoresdangeroriginal");
        [self startDangerArray];
    }
    
    valid = NO;
    _timesSentToEachPlace = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"2" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome timessenttoeachplace");
        for (int i=0; i<10; i++) {
            [_timesSentToEachPlace addObject:@0];
        }
    }
    
    valid = NO;
    _completeFreezersOnOrOff = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"3" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome completefreezersonoroff");
        for (int i=0; i<7; i++)
        {
            [_completeFreezersOnOrOff addObject:@"NO"];
        }
    }
    
    valid = NO;
    _individualTraysOnOrOff = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"4" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome individualtraysonoroff");
        for (int i=0; i<18; i++) {
            [_individualTraysOnOrOff addObject:@"APAGADO"];
        }
    }
    
    valid = NO;
    _individualTrayDates = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"5" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome individualtraydates");
        for (int i=0; i<18; i++) {
            [_individualTrayDates addObject:@"NO"];
        }
    }
    
    valid = NO;
    _peopleOnOrOff = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"6" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome peopleonoroff");
        for (int i=0; i<20; i++) {
            [_peopleOnOrOff addObject:@"NONE"];
        }
    }
    
    valid = NO;
    _peopleStartDate = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"7" valid:&valid]];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome peoplestartdate");
        for (int i=0; i<20; i++) {
            [_peopleStartDate addObject:@"NONE"];
        }
    }
    
    valid = NO;
    _boostActivated = [[defaults secureObjectForKey:@"8" valid:&valid]integerValue];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome boostactivated");
        _boostActivated = 0;
    }
    
    valid = NO;
    if ([[defaults secureObjectForKey:@"9" valid:&valid] isKindOfClass:[NSDate class]]) {
        [defaults setSecureObject:[NSNumber numberWithFloat:CACurrentMediaTime()] forKey:@"9"];
    }
    valid = NO;
    _boostLaunchDate = [[defaults secureObjectForKey:@"9" valid:&valid] floatValue];
    if (!valid)
    {
        NSLog(@"INVALID ClientsAtHome boostlaunchdate");
        _boostLaunchDate = CACurrentMediaTime();
    }
    
    valid = NO;
    _infoClientes = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"10" valid:&valid]];
    if (!valid) {
        NSLog(@"INVALID ClientsAtHome infoClientes");
        for (int i=0; i<10; i++) {
            [_infoClientes addObject:@123];
        }
    }
    
    valid = NO;
    _infoZone = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"11" valid:&valid]];
    if (!valid) {
        NSLog(@"INVALID ClientsAtHome infoZone");
        for (int i=0; i<4; i++) {
            [_infoZone addObject:@123];
        }
    }
    
    valid = NO;
    _placeSentTo = [NSMutableArray arrayWithArray:[defaults secureObjectForKey:@"12" valid:&valid]];
    if (!valid) {
        NSLog(@"INVALID ClientsAtHome placeSentTo");
        for (int i=0; i<20; i++) {
            [_placeSentTo addObject:@"NONE"];
        }
    }
    
    valid = NO;
    _dangerClientOnOrOff = [[defaults secureObjectForKey:@"13" valid:&valid] integerValue];
    if (!valid) {
        NSLog(@"INVALID ClientsAtHome dangerClientOnOrOff");
        _dangerClientOnOrOff = 1;
    }
    
    _valoresDangerEnRegion = [NSMutableArray arrayWithArray:_valoresDangerOriginal];
    _alturaZone = 135;
    _randomPresent = 0;
    _contractsPosition = 0;
    _homeViewPosition = 0;
    _contractsCustomerPressed = 0;
}

-(void)saveGame
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *clientSaveArray = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:_dangerStartDate],
                                [NSNumber numberWithInteger:_whichDanger],
                                [NSNumber numberWithFloat:_appLaunchDate],
                                nil];
    [defaults setSecureObject:clientSaveArray forKey:@"clientSaveArray"];
    [defaults setSecureObject:_valoresDangerOriginal forKey:@"1"];
    [defaults setSecureObject:_timesSentToEachPlace forKey:@"2"];
    [defaults setSecureObject:_completeFreezersOnOrOff forKey:@"3"];
    [defaults setSecureObject:_individualTraysOnOrOff forKey:@"4"];
    [defaults setSecureObject:_individualTrayDates forKey:@"5"];
    [defaults setSecureObject:_peopleOnOrOff forKey:@"6"];
    [defaults setSecureObject:_peopleStartDate forKey:@"7"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_boostActivated] forKey:@"8"];
    [defaults setSecureObject:[NSNumber numberWithFloat:_boostLaunchDate] forKey:@"9"];
    [defaults setSecureObject:_infoClientes forKey:@"10"];
    [defaults setSecureObject:_infoZone forKey:@"11"];
    [defaults setSecureObject:_placeSentTo forKey:@"12"];
    [defaults setSecureObject:[NSNumber numberWithInteger:_dangerClientOnOrOff] forKey:@"13"];
    
    [defaults synchronize];
    NSLog(@"ClientsAtHome SAVED");
}

-(int)availableClient
{
    int cualCliente = -1;
    while (cualCliente==-1) {
        int randomClient = arc4random_uniform(10);
        if ([_infoClientes[randomClient] isEqual:@123]) {
            cualCliente = randomClient;
        }
    }
    return cualCliente;
}

-(int)availableZone
{
    int cualZone = -1;
    while (cualZone==-1) {
        int randomZone = arc4random_uniform(4);
        if ([_infoZone[randomZone] isEqual:@123]) {
            cualZone = randomZone;
        }
    }
    return cualZone;
}

-(BOOL)zonesFull
{
    BOOL zonesFull = YES;
    for (int i=0; i<4; i++) {
        if ([_infoZone[i]isEqual:@123]) {
            zonesFull = NO;
        }
    }
    return zonesFull;
}

-(BOOL)notAtHomeFull
{
    BOOL zonesFull = YES;
    int cuantos = 0;
    
    for (int i =0; i<4; i++) {
        if (![_infoZone[i]isEqual:@123]) {
            cuantos++;
        }
    }
    if (cuantos<2) {
        zonesFull=NO;
    }
    return zonesFull;
}

-(void)startDangerArray
{
    NSMutableArray *valoresDanger = [[NSMutableArray alloc]init];
    [valoresDanger addObject:@90];
    [valoresDanger addObject:@70];
    [valoresDanger addObject:@50];
    [valoresDanger addObject:@100];
    [valoresDanger addObject:@100];
    [valoresDanger addObject:@90];
    [valoresDanger addObject:@80];
    [valoresDanger addObject:@100];
    [valoresDanger addObject:@90];
    
    for (int i = 0; i<10; i++)
    {
        [_valoresDangerOriginal addObject:@1234];
    }
    
    [_valoresDangerOriginal replaceObjectAtIndex:7 withObject:[NSNumber numberWithInt:0]];
    
    int cual=0;
    while (cual<9)
    {
        int random = arc4random_uniform(10);
        int number = [_valoresDangerOriginal[random] intValue];
        if (number==1234) {
            [_valoresDangerOriginal replaceObjectAtIndex:random withObject:valoresDanger[cual]];
            cual++;
        }
    }
}


@end
