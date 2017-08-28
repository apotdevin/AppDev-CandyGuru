//
//  BeakerViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 7/14/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

@interface BeakerViewController : UIViewController
{
    IBOutlet UILabel *amountOfProgress;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *aluminumLabel;
    IBOutlet UILabel *greyPowderLabel;
    IBOutlet UIImageView *labWindow;
    
    float progress;
    float cuantoIncremento;
    int empezoBien;
    int hayBanner;
}

@end
