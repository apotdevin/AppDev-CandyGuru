//
//  LocationSelectionViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/12/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollContractsViewController.h"

@interface LocationSelectionViewController : UIViewController
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *infoLabel;
    
    NSMutableArray *locationButtonArray;
    NSArray *nameArray;
    
    NSMutableArray *dangerLabelArray;
}
@end
