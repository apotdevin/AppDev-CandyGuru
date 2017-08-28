//
//  RoundProgressView.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/1/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundProgressView : UIView

@property (nonatomic) float progress;
@property (nonatomic) float piePadding;
@property (nonatomic) float fontSize;
@property (nonatomic,strong) UIImage *redondo;
@property (nonatomic,retain) UIColor *tintcolor UI_APPEARANCE_SELECTOR;

@end
