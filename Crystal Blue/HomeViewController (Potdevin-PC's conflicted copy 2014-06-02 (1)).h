//
//  HomeViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 5/31/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

@interface HomeViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scroller;
    IBOutlet UIImageView *couch;
    IBOutlet UIImageView *mesa;
    IBOutlet UIImageView *sillas;
    IBOutlet UIImageView *computador;
    
    IBOutlet UILabel *shop;
    IBOutlet UILabel *contracts;
    IBOutlet UILabel *lab;
    
    NSInteger *level;
    NSInteger *xp;
    
    NSInteger levelXp[];
    
    IBOutlet UILabel *percent;
    
}

@property (retain,nonatomic) IBOutlet CERoundProgressView *progressView;
@property (retain,nonatomic) IBOutlet UISlider *progressSlider;

- (IBAction)progressSlider:(UISlider *)sender;
- (IBAction)buttonLeft:(UIButton *)sender;
- (IBAction)buttonRight:(UIButton *)sender;

@end
