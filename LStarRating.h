//
//  LStarRating.h
//  lstarrating
//
//  Created by zhanglei on 8/9/16.
//  Copyright © 2016 loftor. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface LStarRating : UIControl

@property (nonatomic, strong)IBInspectable UIImage *image;

@property (nonatomic, assign)IBInspectable CGFloat spacing;

@property (nonatomic, assign)IBInspectable CGFloat maxRating;

@property (nonatomic, assign)IBInspectable CGFloat rating;

@end
