//
//  XYSwitch.h
//  MyTravel
//
//  Created by eric on 13-9-16.
//  Copyright (c) 2013年 www.51you.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSwitch : UIControl
/*
 * Set (without animation) whether the switch is on or off
 */
@property (nonatomic, assign, getter = isOn) BOOL on;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIImage *onImage;

@property (nonatomic, strong) NSString *onText;

@property (nonatomic, strong) UIImage *offImage;

@property (nonatomic, strong) NSString *offText;
/*
 * Set whether the switch is on or off. Optionally animate the change
 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end