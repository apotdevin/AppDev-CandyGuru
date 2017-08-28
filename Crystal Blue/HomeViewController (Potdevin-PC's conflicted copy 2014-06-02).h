//
//  HomeViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
#import "CrystalViewController.h"

@interface HomeViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scroller;
    IBOutlet UIImageView *imagen;
    IBOutlet UIImageView *imagen1;
    IBOutlet UIImageView *imagen2;
    IBOutlet UIImageView *imagen3;
    
    NSInteger *level;
    NSInteger *xp;
    
    IBOutlet UILabel *percent;
    
}

@property (retain,nonatomic) IBOutlet CERoundProgressView *progressView;
@property (retain,nonatomic) IBOutlet UISlider *progressSlider;

- (IBAction)progressSlider:(UISlider *)sender;
- (IBAction)buttonLeft:(UIButton *)sender;
- (IBAction)buttonRight:(UIButton *)sender;

@end
