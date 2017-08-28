//
//  GlassViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/5/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlassViewController : UIViewController
{
    float glassProgress;
    NSInteger currentBowl;
    float dificulty;
    
    IBOutlet UILabel *progress;
    IBOutlet UILabel *matchBoxes;
    IBOutlet UILabel *redPowder;
    IBOutlet UIImageView *background;
    IBOutlet UIButton *backButton;
    IBOutlet UIImageView *windowGlass;
    
    UILabel *tutLabel;
}

@end
