//
//  RoundProgressView.m
//  Crystal Blue
//
//  Created by Anthony Potdevin on 6/1/14.
//  Copyright (c) 2014 Anthony Potdevin. All rights reserved.
//

#import "RoundProgressView.h"
#import "CERoundProgressView.h"

@interface RoundProgressView()

@property (nonatomic,strong)CERoundProgressView *pieView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *lblValue;

- (void)_initIVars;

@end

@implementation RoundProgressView

@synthesize pieView;
@synthesize piePadding;
@synthesize imgView;
@synthesize lblValue;
@synthesize progress;
@synthesize redondo;
@synthesize fontSize;
@synthesize tintcolor;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initIVars];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initIVars];
    }
    return self;
}

- (void)_initIVars
{
    self.backgroundColor = [UIColor clearColor];
    
    self.pieView = [[CERoundProgressView alloc]initWithFrame:self.bounds];
    self.pieView.tintColor = self.tintcolor;
    self.pieView.startAngle = (2*M_PI)/2;
    
    [self addSubview:self.pieView];
    
    /*
    self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imgView.image = [UIImage imageNamed:@"progresscircle"];
    [self addSubview:self.imgView];
    */
    
    self.lblValue = [[UILabel alloc] initWithFrame:self.bounds];
    lblValue.backgroundColor = [UIColor clearColor];
    lblValue.textAlignment = NSTextAlignmentCenter;
    //lblValue.font
    lblValue.textColor = [UIColor blackColor];
    lblValue.shadowColor = [UIColor whiteColor];
    lblValue.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:self.lblValue];
    
    self.piePadding = 1.5;
}

- (void)setProgress:(float)newProgress
{
    if (newProgress<0) {
        newProgress=0.0;
    }
    else if (newProgress>1) {
        newProgress=1.0;
    }
    if (progress==newProgress) {
        return;
    }
    progress = newProgress;
    self.pieView.progress = progress;
    self.lblValue.text = [NSString stringWithFormat:@"%2.0f%%",progress*100];
}

-(void)setFontSize:(float)newFontSize
{
    if (fontSize==newFontSize) {
        return;
    }
}

-(void)setImage:(UIImage *)newImage
{
    if ([redondo isEqual:newImage]) {
        return;
    }
    
    redondo = newImage;
    self.imgView.image = redondo;
}

-(void)setTintcolor:(UIColor *)newTintColor
{
    if ([tintcolor isEqual:newTintColor]) {
        return;
    }
    
    tintcolor = newTintColor;
    self.pieView.tintColor = tintcolor;
}

-(void)setPiePadding:(float)newPiePadding
{
    if (piePadding == newPiePadding) {
        return;
    }
    
    piePadding = newPiePadding;
    CGRect pieFrame = self.bounds;
    pieFrame.origin.x = piePadding;
    pieFrame.origin.y = piePadding;
    pieFrame.size.width -= 2*pieFrame.origin.x;
    pieFrame.size.height -= 2*pieFrame.origin.y;
    
    self.pieView.frame = pieFrame;
}



@end
