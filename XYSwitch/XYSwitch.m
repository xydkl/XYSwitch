//
//  XYSwitch.m
//  MyTravel
//
//  Created by eric on 13-9-16.
//  Copyright (c) 2013年 www.51you.com. All rights reserved.
//

#import "XYSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface XYSwitch ()  {
    UIImageView *background;
    UIView *knob;
    UIImageView *onImageView;
    UIImageView *offImageView;
    UILabel *onLabel;
    UILabel *offLabel;
    BOOL currentVisualValue;
    BOOL startTrackingValue;
    BOOL didChangeWhileTracking;
    BOOL isAnimating;
}

- (void)showOn:(BOOL)animated;
- (void)showOff:(BOOL)animated;
- (void)setup;

@end

@implementation XYSwitch
@synthesize on;

#pragma mark init Methods

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 65, 30)];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    // use the default values if CGRectZero frame is set
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, 65, 30);
    }
    else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        [self setup];
    }
    return self;
}


/**
 *	Setup the individual elements of the switch and set default values
 */
- (void)setup {
    
    // default values
    self.on = NO;
    currentVisualValue = NO;
    
    // background
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    background.image = self.offImage;
    background.userInteractionEnabled = NO;
    [self addSubview:background];
    
    onLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    onLabel.text = @"是";
    onLabel.textColor = [UIColor whiteColor];
    onLabel.textAlignment = NSTextAlignmentCenter;
    onLabel.backgroundColor = [UIColor clearColor];
    onLabel.font = [UIFont systemFontOfSize:12];
    onLabel.alpha = 0;
    [self addSubview:onLabel];
    
    offLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 20, 20)];
    offLabel.text = @"否";
    offLabel.textColor = [UIColor whiteColor];
    offLabel.textAlignment = NSTextAlignmentCenter;
    offLabel.backgroundColor = [UIColor clearColor];
    offLabel.font = [UIFont systemFontOfSize:12];
    offLabel.alpha = 1;
    [self addSubview:offLabel];
    // knob
    knob = [[UIView alloc] initWithFrame:CGRectMake(3, 3.5, self.frame.size.height - 8, self.frame.size.height - 8)];
    knob.backgroundColor = [UIColor whiteColor];
    knob.layer.cornerRadius = (self.frame.size.height * 0.5) - 4;
    knob.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    knob.layer.shadowRadius = 2.0;
    knob.layer.shadowOpacity = 0.5;
    knob.layer.shadowOffset = CGSizeMake(0, 3);
    knob.layer.masksToBounds = NO;
    knob.userInteractionEnabled = NO;
    [self addSubview:knob];
    
    isAnimating = NO;
}


#pragma mark Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    startTrackingValue = self.on;
    didChangeWhileTracking = NO;
    
    // make the knob larger and animate to the correct color
    CGFloat activeKnobWidth = self.bounds.size.height - 8 + 5;
    isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.on) {
            knob.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.image = self.onImage;
            onLabel.alpha = 1;
            offLabel.alpha = 0;
        }
        else {
            knob.frame = CGRectMake(knob.frame.origin.x, knob.frame.origin.y, activeKnobWidth, knob.frame.size.height);
            background.image = self.offImage;
            onLabel.alpha = 0;
            offLabel.alpha = 1;
        }
    } completion:^(BOOL finished) {
        isAnimating = NO;
    }];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    // Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    // update the switch to the correct visuals depending on if
    // they moved their touch to the right or left side of the switch
    if (lastPoint.x > self.bounds.size.width * 0.5) {
        [self showOn:YES];
        if (!startTrackingValue) {
            didChangeWhileTracking = YES;
        }
    }
    else {
        [self showOff:YES];
        if (startTrackingValue) {
            didChangeWhileTracking = YES;
        }
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    BOOL previousValue = self.on;
    
    if (didChangeWhileTracking) {
        [self setOn:currentVisualValue animated:YES];
    }
    else {
        [self setOn:!self.on animated:YES];
    }
    
    if (previousValue != self.on)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    
    // just animate back to the original value
    if (self.on)
        [self showOn:YES];
    else
        [self showOff:YES];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!isAnimating) {
        CGRect frame = self.frame;
        
        // background
        background.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        // knob
        CGFloat normalKnobWidth = frame.size.height - 8;
        if (self.on)
            knob.frame = CGRectMake(frame.size.width - (normalKnobWidth + 1), 3.5, frame.size.height - 8, normalKnobWidth);
        else
            knob.frame = CGRectMake(3, 3.5, normalKnobWidth, normalKnobWidth);
        
        knob.layer.cornerRadius = frame.size.height * 0.5 - 4;
    }
}

/*
 * Set (without animation) whether the switch is on or off
 */
- (void)setOn:(BOOL)isOn {
    [self setOn:isOn animated:NO];
}


/*
 * Set the state of the switch to on or off, optionally animating the transition.
 */
- (void)setOn:(BOOL)isOn animated:(BOOL)animated {
    on = isOn;
    
    if (isOn) {
        [self showOn:animated];
    }
    else {
        [self showOff:animated];
    }
}

#pragma mark State Changes


/*
 * update the looks of the switch to be in the on position
 * optionally make it animated
 */
- (void)showOn:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 8;

    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
            background.image = self.onImage;
            onLabel.alpha = 1;
            offLabel.alpha = 0;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        knob.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
        background.image = self.onImage;
        onLabel.alpha = 1;
        offLabel.alpha = 0;
    }
    
    currentVisualValue = YES;
}


/*
 * update the looks of the switch to be in the off position
 * optionally make it animated
 */
- (void)showOff:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 8;
    
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            knob.frame = CGRectMake(3, knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
            background.image = self.offImage;
            onLabel.alpha = 0;
            offLabel.alpha = 1;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        
        knob.frame = CGRectMake(3, knob.frame.origin.y, normalKnobWidth, knob.frame.size.height);
        background.image = self.offImage;
        onLabel.alpha = 0;
        offLabel.alpha = 1;
    }
    
    currentVisualValue = NO;
}

- (UIImage *)onImage
{
    if (_onImage == nil) {
        return [UIImage imageNamed:@"switch_on"];
    }
    return _onImage;
}

- (UIImage *)offImage
{
    if (_offImage == nil) {
        return [UIImage imageNamed:@"switch_off"];
    }
    return _offImage;
}
@end