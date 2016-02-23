//
//  InsetsLabel.h
//  viewController
//
//  Created by rimi on 15/10/16.
//  Copyright (c) 2015年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel

@property (nonatomic) UIEdgeInsets insets;

-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;

-(id) initWithInsets: (UIEdgeInsets) insets;

@end
