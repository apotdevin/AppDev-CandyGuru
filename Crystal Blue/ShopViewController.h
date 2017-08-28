//
//  ShopViewController.h
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/8/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShopTableViewCell.h"

@interface ShopViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *table;
    IBOutlet UILabel *moneyLabel;
    IBOutlet UILabel *levelLabel;
    
    IBOutlet UIButton *backHomeButton;
    IBOutlet UIButton *backLabButton;
    
    IBOutlet UIButton *materialsButton;
    IBOutlet UIButton *instrumentsButton;
    IBOutlet UIButton *technologyButton;
    IBOutlet UIButton *specialsButton;
    
    IBOutlet UILabel *animationMoneyLabel;
    IBOutlet UILabel *amountOfMaterials;
    
    NSMutableArray *materiales;
    NSMutableArray *materiales2;
    NSMutableArray *instruments;
    NSMutableArray *instruments2;
    NSMutableArray *technology;
    NSMutableArray *currentArray;
    NSMutableArray *specials;
    //NSMutableArray *specialsAndShop;
    
    UIImageView *tutorialButton;
    
    NSArray *productsArray;
    
    NSArray *iconosMateriales;
    NSArray *iconosMateriales2;
    NSArray *iconosInstruments;
    NSArray *iconosInstruments2;
    
    UIColor *tintColor;
    BOOL productPurchased;
}

- (IBAction)materialsButton:(id)sender;
- (IBAction)instrumentsButton:(id)sender;
- (IBAction)specialsButton:(id)sender;
- (IBAction)technologyButton:(id)sender;

- (IBAction)backLabButton:(id)sender;

@end
