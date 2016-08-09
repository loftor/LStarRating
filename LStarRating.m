//
//  LStarRating.m
//  lstarrating
//
//  Created by zhanglei on 8/9/16.
//  Copyright © 2016 loftor. All rights reserved.
//

#import "LStarRating.h"

@interface LStarRating()

@property (nonatomic,strong ) UIImage *tintedImage;

@end



@implementation LStarRating

-(void)setDefaultProperties
{
    _maxRating=5.0;
    _rating=0.0;
    _spacing = 0.0;
    self.image = [UIImage imageNamed:@"icon_star"];
    self.tintedImage = [self tintedImage:_image];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self setDefaultProperties];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        [self setDefaultProperties];
    }
    return self;
}


-(UIImage*)tintedImage:(UIImage*)img
{
    UIImage *tintedImage = img;
    
    if( [self respondsToSelector:@selector(tintColor)])
    {
        
        UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale );
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, img.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        // draw alpha-mask
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextDrawImage(context, rect, img.CGImage);
        // draw tint color, preserving alpha values of original image
        CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        [self.tintColor setFill];
        CGContextFillRect(context, rect);
        
        tintedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return tintedImage;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for( NSInteger i=0 ; i<_maxRating; i++ )
    {
        [self drawImage:self.image atPosition:i];
        if( i < _rating )
        {
            CGContextSaveGState(ctx);
            {
                if( i< _rating &&  _rating < i+1 )
                {
                    
                    CGRect rect = [self rectAtPosition:i];
                    float difference = _rating - i;
                    CGRect rectClip;
                    rectClip.origin = rect.origin;
                    rectClip.size = rect.size;
                    rectClip.size.width*=difference;
                    
                    CGContextClipToRect( ctx, rectClip);
                    
                }
                
                [self drawImage:self.tintedImage atPosition:i];
            }
            CGContextRestoreGState(ctx);
        }
    }

}

-(void)drawImage:(UIImage*)image atPosition:(NSInteger)position
{
    
    [image drawInRect:[self rectAtPosition:position]];
    
    
}

-(CGRect)rectAtPosition:(NSInteger)position
{
    CGRect rect = CGRectMake(position* _image.size.width/_image.size.height*self.bounds.size.height+_spacing*position  ,0,_image.size.width/_image.size.height*self.bounds.size.height,self.bounds.size.height);
    
    NSLog(@"rect:%@",NSStringFromCGRect(rect));
    return rect;
}

- (void)setMaxRating:(CGFloat)maxRating{
    if (_maxRating == maxRating) {
        return;
    }
    _maxRating = maxRating;
    [self setNeedsDisplay];
}

- (void)setRating:(CGFloat)rating{
    if (_rating == rating || rating >_maxRating) {
        return;
    }
    _rating = rating;
    [self setNeedsDisplay];
}

- (void)tintColorDidChange{
    self.tintedImage = [self tintedImage:self.image];
    [self setNeedsDisplay];
}

- (void)setSpacing:(CGFloat)spacing{
    if (_spacing == spacing) {
        return;
    }
    _spacing = spacing;
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image{
    if (_image == image) {
        return;
    }
    
    _image = image;
    self.tintedImage = [self tintedImage:_image];
    [self setNeedsDisplay];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(_maxRating * _image.size.width/_image.size.height*self.bounds.size.height +(_maxRating-1)*_spacing, self.bounds.size.height);
}


#pragma mark -
#pragma mark Mouse/Touch Interaction
-(float) ratingForPoint:(CGPoint)point
{
    float rating =0;
    for( NSInteger i=0; i<_maxRating; i++ )
    {
        CGRect rect =[self rectAtPosition:i];
        if( point.x >= rect.origin.x && point.x <= rect.origin.x+rect.size.width+_spacing)
        {
            float increment=1.0;
            

            float difference = (point.x - rect.origin.x)/rect.size.width;
            if (difference>1) {
                difference = 1;
            }

            rating+=increment*difference;
            break;
        }
        else{
            rating++;
        }
    }
    return rating;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    self.rating =[self ratingForPoint:touchLocation];
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    self.rating =[self ratingForPoint:touchLocation];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end
