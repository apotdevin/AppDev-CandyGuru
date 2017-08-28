//
//  ScrollContractsViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/11/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSelectionViewController.h"

@interface ScrollContractsViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scroller;
    IBOutlet UILabel *sellers;
    IBOutlet UILabel *bullys;
    IBOutlet UILabel *money;
    IBOutlet UILabel *crystal;
    IBOutlet UILabel *animationLabel;
    IBOutlet UIButton *backButton;
    
    UIColor *tintColor;
    
    NSMutableArray *nameLabelArray;
    NSMutableArray *infoLabelArray;
    NSMutableArray *locationButtonArray;
    NSMutableArray *timerLabelArray;
    NSMutableArray *startButtonArray;
    NSMutableArray *imageViewArray;
    NSMutableArray *collectButtonArray;
    NSMutableArray *lockedLabelArray;
    NSMutableArray *backgroundImageArray;
    
    NSMutableArray *people;
    
    UILabel *lockedLabel;
    UIImageView *backgroundImage;
    
    NSTimer *countDownTimer;
}
@end
