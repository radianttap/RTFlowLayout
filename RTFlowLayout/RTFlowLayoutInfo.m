//
//  RTFlowLayoutInfo.m
//  RTFlowLayout
//
//  Created by Aleksandar Vacić on 21.10.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTFlowLayoutInfo.h"
#import "RTFlowLayoutSection.h"
#import "RTFlowLayoutRow.h"
#import "RTFlowLayoutItem.h"

@interface RTFlowLayoutInfo() {
	NSMutableArray *_sections;
	CGRect _visibleBounds;
	CGSize _layoutSize;
	BOOL _isValid;
}
@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation RTFlowLayoutInfo

#pragma mark - NSObject

- (id)init {
	if((self = [super init])) {
		_sections = [NSMutableArray new];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p contentSize:%@ sections:%@>", NSStringFromClass([self class]), self, NSStringFromCGSize(self.contentSize), self.sections];
}

#pragma mark - Public

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
	RTFlowLayoutSection *section = self.sections[indexPath.section];
	CGRect itemFrame;
	itemFrame = [section.items[indexPath.item] itemFrame];
	return itemFrame;
}

- (id)addSection {
	RTFlowLayoutSection *section = [RTFlowLayoutSection new];
	section.layoutInfo = self;
	[_sections addObject:section];
	[self invalidate];

	return section;
}

- (void)invalidate {
	_isValid = NO;
}

@end
