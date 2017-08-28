//
//  SliderViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/1/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

@interface SliderViewController : UIViewController {
    
}

@property (retain,nonatomic) IBOutlet CERoundProgressView *progressView;
@property (retain,nonatomic) IBOutlet UISlider *progressSlider;
@property (retain,nonatomic) IBOutlet UILabel *label;

- (IBAction)progressSlider:(UISlider *)sender;

@end
