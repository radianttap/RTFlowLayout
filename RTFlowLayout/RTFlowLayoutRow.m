//
//  RTFlowLayoutRow.m
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTFlowLayoutRow.h"
#import "RTFlowLayoutSection.h"
#import "RTFlowLayoutItem.h"
#import "RTFlowLayoutInfo.h"
#import "RTFlowLayout.h"

@interface RTFlowLayoutRow() {
	NSMutableArray *_items;
	BOOL _isValid;
	int _verticalAlignement;
	int _horizontalAlignement;
}
@property (nonatomic, strong) NSArray *items;
@end

@implementation RTFlowLayoutRow

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
	if((self = [super init])) {
		_items = [NSMutableArray new];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p frame:%@ index:%d items:%@>", NSStringFromClass([self class]), self, NSStringFromCGRect(self.rowFrame), self.index, self.items];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)invalidate {
	_isValid = NO;
	_rowSize = CGSizeZero;
	_rowFrame = CGRectZero;
}

- (NSArray *)itemRects {
	return [self layoutRowAndGenerateRectArray:YES];
}

- (void)layoutRow {
	[self layoutRowAndGenerateRectArray:NO];
}

- (NSArray *)layoutRowAndGenerateRectArray:(BOOL)generateRectArray {
	NSMutableArray *rects = generateRectArray ? [NSMutableArray array] : nil;
	if (!_isValid || generateRectArray) {
		// properties for aligning
		BOOL isHorizontal = (self.section.layoutInfo.scrollDirection == UICollectionViewScrollDirectionHorizontal);

		// calculate space that's left over if we would align it from left to right.
		CGFloat leftOverSpace = (isHorizontal) ? self.section.layoutInfo.collectionViewSize.height : self.section.layoutInfo.collectionViewSize.width;
		if (isHorizontal) {
			leftOverSpace -= self.section.sectionMargins.top + self.section.sectionMargins.bottom;
		} else {
			leftOverSpace -= self.section.sectionMargins.left + self.section.sectionMargins.right;
		}

		// calculate the space that we have left after counting all items.
		// UICollectionView is smart and lays out items like they would have been placed on a full row
		// So we need to calculate the "usedItemCount" with using the last item as a reference size.
		// This allows us to correctly justify-place the items in the grid.
		NSUInteger usedItemCount = 0;
		NSInteger itemIndex = 0;
		BOOL canFitMoreItems = itemIndex < self.itemCount;
		while (itemIndex < self.itemCount || canFitMoreItems) {
			RTFlowLayoutItem *item = self.items[MIN(itemIndex, self.itemCount-1)];
			leftOverSpace -= isHorizontal ? item.itemFrame.size.height : item.itemFrame.size.width;
			canFitMoreItems = isHorizontal ? (leftOverSpace > item.itemFrame.size.height) : (leftOverSpace > item.itemFrame.size.width);
			// separator starts after first item
			if (itemIndex > 0) {
				leftOverSpace -= isHorizontal ? self.section.verticalInterstice : self.section.horizontalInterstice;
			}
			itemIndex++;
			usedItemCount = itemIndex;
		}
		
		CGPoint itemOffset = CGPointZero;
		
		// calculate row frame as union of all items
		CGRect frame = CGRectZero;
		CGRect itemFrame;
		for (NSInteger itemIndex = 0; itemIndex < self.itemCount; itemIndex++) {
			RTFlowLayoutItem *item = nil;
			item = self.items[itemIndex];
			itemFrame = [item itemFrame];
			if (isHorizontal) {
				itemFrame.origin.y = itemOffset.y;
				itemOffset.y += itemFrame.size.height + self.section.verticalInterstice;
				itemOffset.y += leftOverSpace/(CGFloat)(usedItemCount-1);
			} else {
				itemFrame.origin.x = itemOffset.x;
				itemOffset.x += itemFrame.size.width + self.section.horizontalInterstice;
				itemOffset.x += leftOverSpace/(CGFloat)(usedItemCount-1);
			}
			item.itemFrame = CGRectIntegral(itemFrame); // might call nil; don't care
			[rects addObject:[NSValue valueWithCGRect:CGRectIntegral(itemFrame)]];
			frame = CGRectUnion(frame, itemFrame);
		}
		_rowSize = frame.size;
		//		_rowFrame = frame; // set externally
		_isValid = YES;
	}
	return rects;
}

- (void)addItem:(RTFlowLayoutItem *)item {
	[_items addObject:item];
	item.rowObject = self;
	[self invalidate];
}

- (NSInteger)itemCount {
	return [self.items count];
}

@end

