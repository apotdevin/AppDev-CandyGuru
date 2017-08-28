//
//  CustomFacebookTableViewCell.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 2/23/15.
//  Copyright (c) 2015 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"

@interface CustomFacebookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FBProfilePictureView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
