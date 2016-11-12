//
//  CardsView.h
//  mFinoWallet
//
//  Created by Vishwa Deepak on 31/01/16.
//  Copyright © 2016 mFino. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CardsView : UIView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable int shadowOffsetWidth;
@property (nonatomic) IBInspectable int shadowOffsetHeight;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;


//@IBInspectable var shadowOffsetHeight: Int = 3
//@IBInspectable var shadowColor: UIColor? = UIColor.blackColor()
//@IBInspectable var shadowOpacity: Float = 0.5

@end
