//
//  RTGroupHeader.m
//  Dream Cars
//
//  Created by Aleksandar Vacić on 28.9.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
//

#import "RTGroupHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RTGroupHeaderView

- (void)awakeFromNib {

	//	add shadow
	self.groupTitleLabel.shadowColor = [UIColor grayColor];
	self.groupTitleLabel.shadowOffset = CGSizeMake(0, 0.5);
	
}

@end
