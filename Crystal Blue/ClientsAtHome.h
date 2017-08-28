//
//  ClientsAtHome.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/21/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientsAtHome : NSObject

@property (strong, nonatomic) NSMutableArray *infoClientes;
@property (strong, nonatomic) NSMutableArray *valoresDangerOriginal;
@property (strong, nonatomic) NSMutableArray *valoresDangerEnRegion;
@property (strong, nonatomic) NSMutableArray *timesSentToEachPlace;
@property (strong, nonatomic) NSMutableArray *infoZone;
@property (assign, nonatomic) NSInteger alturaZone;
@property (assign, nonatomic) NSInteger dangerClientOnOrOff;
@property (strong, nonatomic) NSMutableArray *completeFreezersOnOrOff;
@property (strong, nonatomic) NSMutableArray *individualTraysOnOrOff;
@property (strong, nonatomic) NSMutableArray *individualTrayDates;
@property (assign, nonatomic) float dangerStartDate;
@property (assign, nonatomic) NSInteger whichDanger;
@property (assign, nonatomic) float appLaunchDate;

@property (strong, nonatomic) NSMutableArray *peopleOnOrOff;
@property (strong, nonatomic) NSMutableArray *peopleStartDate;
@property (strong, nonatomic) NSMutableArray *placeSentTo;
@property (assign, nonatomic) NSInteger boostActivated;
@property (assign, nonatomic) float boostLaunchDate;

@property (assign, nonatomic) NSInteger randomPresent;
@property (assign, nonatomic) NSInteger contractsPosition;
@property (assign, nonatomic) NSInteger homeViewPosition;
@property (assign, nonatomic) NSInteger contractsCustomerPressed;

+(instancetype)sharedClientData;
-(void)newGame;
-(void)loadGame;
-(void)saveGame;
-(int)availableClient;
-(int)availableZone;
-(BOOL)zonesFull;
-(BOOL)notAtHomeFull;
@end
