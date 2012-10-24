//
//  RTCollectionLayoutSection.m
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "RTFlowLayoutSection.h"
#import "RTFlowLayoutItem.h"
#import "RTFlowLayoutRow.h"
#import "RTFlowLayoutInfo.h"

@interface RTFlowLayoutSection() {
	NSMutableArray *_items;
	NSMutableArray *_rows;
	BOOL _isValid;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger indexOfIncompleteRow;
@end

@implementation RTFlowLayoutSection

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
	if((self = [super init])) {
		_items = [NSMutableArray new];
		_rows = [NSMutableArray new];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p itemCount:%d frame:%@ rows:%@>", NSStringFromClass([self class]), self, self.itemsCount, NSStringFromCGRect(self.frame), self.rows];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)invalidate {
	_isValid = NO;
	self.rows = [NSMutableArray array];
}

- (void)computeLayout {
	if (!_isValid) {
		NSAssert([self.rows count] == 0, @"No rows shall be at this point.");

		// iterate over all items, turning them into rows.
		CGPoint bodyOrigin = CGPointZero;
		CGSize bodySize = CGSizeZero;
		NSInteger rowIndex = 0;
		NSInteger itemIndex = 0;
		NSInteger itemsByRowCount = 0;
		CGFloat dimensionLeft = 0;
		RTFlowLayoutRow *row = nil;

		BOOL isHorizontal = (self.layoutInfo.scrollDirection == UICollectionViewScrollDirectionHorizontal);
		
		//	header origin is 0, 0. nothing to do

		// get available space for section body, compensate for section margins
		CGFloat dimension = (isHorizontal) ? self.layoutInfo.collectionViewSize.height : self.layoutInfo.collectionViewSize.width;
		if (isHorizontal) {
			dimension -= self.sectionMargins.top + self.sectionMargins.bottom;
			bodySize.height = dimension;
		} else {
			dimension -= self.sectionMargins.left + self.sectionMargins.right;
			bodySize.width = dimension;
		}

		if (CGRectIsEmpty(self.headerFrame))
			bodyOrigin = CGPointMake(self.sectionMargins.left, self.sectionMargins.top);
		else {
			bodyOrigin.x = (isHorizontal) ? self.headerFrame.size.width : 0;
			bodyOrigin.x += self.sectionMargins.left;
			bodyOrigin.y = (isHorizontal) ? 0 :  self.headerFrame.size.height;
			bodyOrigin.y += self.sectionMargins.top;
		}
		
		CGFloat currentRowPoint = (isHorizontal) ? bodyOrigin.x : bodyOrigin.y;

		do {
			BOOL finishCycle = (itemIndex >= self.itemsCount);

			RTFlowLayoutItem *item = nil;
			if (!finishCycle) {
				item = self.items[itemIndex];
			}

			CGSize itemSize = item.itemFrame.size;
			CGFloat itemDimension = (isHorizontal) ? itemSize.height : itemSize.width;
			itemDimension += (isHorizontal) ? self.verticalInterstice : self.horizontalInterstice;

			if (dimensionLeft < itemDimension || finishCycle) {
				// finish current row
				if (row) {
					// compensate last row
					row.itemCount = itemsByRowCount;
					[row layoutRow];
					if (isHorizontal) {
						row.rowFrame = CGRectMake(currentRowPoint, bodyOrigin.y, row.rowSize.width, row.rowSize.height);
						if (rowIndex > 0) bodySize.width += self.horizontalInterstice;
						bodySize.width += row.rowSize.width;
						currentRowPoint += row.rowSize.width + self.horizontalInterstice;
					} else {
						row.rowFrame = CGRectMake(bodyOrigin.x, currentRowPoint, row.rowSize.width, row.rowSize.height);
						if (rowIndex > 0) bodySize.height += self.verticalInterstice;
						bodySize.height += row.rowSize.height;
						currentRowPoint += row.rowSize.height + self.verticalInterstice;
					}
				}
				if (!finishCycle) {
					// create new row
					row.complete = YES; // finish up current row
					row = [self addRow];
					row.index = rowIndex;
					self.indexOfIncompleteRow = rowIndex;
					rowIndex++;
					itemsByRowCount = 0;
					dimensionLeft = dimension;
				}
			}
			dimensionLeft -= itemDimension;

			if (item) {
				[row addItem:item];
			}
			itemIndex++;
			itemsByRowCount++;
		} while (itemIndex <= self.itemsCount); // cycle once more to finish last row
		
		self.bodyFrame = (CGRect){.origin = bodyOrigin, .size = bodySize};

		CGRect ff = self.footerFrame;
		ff.origin.x = (isHorizontal) ? bodyOrigin.x + bodySize.width + self.sectionMargins.right : 0;
		ff.origin.y = (isHorizontal) ? 0 : bodyOrigin.y + bodySize.height + self.sectionMargins.bottom;
		self.footerFrame = ff;

		CGPoint sectionOrigin = CGPointZero;
		CGSize sectionSize = CGSizeZero;
		sectionSize.width = (isHorizontal) ? ff.origin.x + ff.size.width : fmaxf(self.headerFrame.size.width, bodySize.width + self.sectionMargins.left + self.sectionMargins.right);
		sectionSize.height = (isHorizontal) ? fmaxf(self.headerFrame.size.height, bodySize.height + self.sectionMargins.top + self.sectionMargins.bottom) : ff.origin.y + ff.size.height;
		self.frame = (CGRect){.origin = sectionOrigin, .size = sectionSize};

		_isValid = YES;
	}
}

- (RTFlowLayoutItem *)addItem {
	RTFlowLayoutItem *item = [RTFlowLayoutItem new];
	item.section = self;
	[_items addObject:item];

	return item;
}

- (RTFlowLayoutRow *)addRow {
	RTFlowLayoutRow *row = [RTFlowLayoutRow new];
	row.section = self;
	[_rows addObject:row];

	return row;
}

- (NSInteger)itemsCount {
	return [self.items count];
}

@end
