//
//  RTPhotoCell.m
//  Dream Cars
//
//  Created by Aleksandar Vacić on 28.9.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
//

#import "RTPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RTPhotoCell

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
	self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.600];

	if (self) {
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		iv.backgroundColor = [UIColor lightTextColor];
		iv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		iv.contentMode = UIViewContentModeScaleAspectFill;
		iv.layer.masksToBounds = YES;

		[self addSubview:iv];
		self.imageView = iv;
	}

	return self;
}

@end
