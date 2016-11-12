//
//  CardsView.m
//  mFinoWallet
//
//  Created by Vishwa Deepak on 31/01/16.
//  Copyright © 2016 mFino. All rights reserved.
//

#import "CardsView.h"

@implementation CardsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _cornerRadius = 2;
    
    _shadowOffsetWidth = 0;
    _shadowOffsetHeight = 3;
    _shadowColor = [UIColor blackColor];
    _shadowOpacity = 0.5;
}

- (void)layoutSubviews
{
    self.layer.cornerRadius = _cornerRadius;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    self.layer.masksToBounds = false;
    self.layer.shadowColor = _shadowColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(_shadowOffsetWidth, _shadowOffsetHeight);
    self.layer.shadowOpacity = _shadowOpacity;
    self.layer.shadowPath = shadowPath.CGPath;
}

@end
