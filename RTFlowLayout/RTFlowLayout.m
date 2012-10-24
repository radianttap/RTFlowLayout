//
//  RTFlowLayout.m
//  RTFlowLayout
//
//  Created by Aleksandar Vacić on 28.9.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
//

#import "RTFlowLayout.h"
#import "RTFlowLayoutInfo.h"
#import "RTFlowLayoutSection.h"
#import "RTFlowLayoutRow.h"
#import "RTFlowLayoutItem.h"

NSString *const RTCollectionElementKindHeader = @"RTCollectionElementKindHeader";
NSString *const RTCollectionElementKindFooter = @"RTCollectionElementKindFooter";
NSString *const RTCollectionElementKindSectionHeader = @"RTCollectionElementKindSectionHeader";
NSString *const RTCollectionElementKindSectionFooter = @"RTCollectionElementKindSectionFooter";

//	PRIVATE API
@interface RTFlowLayout()

@property (nonatomic, strong) RTFlowLayoutInfo *layoutInfo;

@end

#pragma mark -

@implementation RTFlowLayout

-(id)init {
	self = [super init];

	if (self) {
		self.headerReferenceSize = CGSizeZero;
		self.footerReferenceSize = CGSizeZero;
		self.sectionHeaderReferenceSize = CGSizeZero;
		self.sectionFooterReferenceSize = CGSizeZero;
		
		self.scrollDirection = UICollectionViewScrollDirectionVertical;
		self.itemSize = CGSizeMake(80.0f, 50.0f);
		self.sectionInset = UIEdgeInsetsZero;
		self.minimumLineSpacing = 8.0;
		self.minimumInteritemSpacing = 8.0;
		
		self.layoutInfo = [RTFlowLayoutInfo new];
	}

	return self;
}

#pragma mark - Layout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

//	BOOL isHorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);

	NSMutableArray *layoutAttributesArray = [NSMutableArray array];

	//	header
	CGRect normalizedHeaderFrame = self.layoutInfo.headerFrame;
	if (CGRectIntersectsRect(normalizedHeaderFrame, rect)) {
		UICollectionViewLayoutAttributes *layoutAttributes;
		layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RTCollectionElementKindHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
		layoutAttributes.frame = normalizedHeaderFrame;
		[layoutAttributesArray addObject:layoutAttributes];
	}
	
	
	for (RTFlowLayoutSection *section in self.layoutInfo.sections) {

		if (CGRectIntersectsRect(section.frame, rect)) {
			
			NSUInteger sectionIndex = [self.layoutInfo.sections indexOfObject:section];
			
			//	section header
			CGRect normalizedSectionHeaderFrame = section.headerFrame;
			normalizedSectionHeaderFrame.origin.x += section.frame.origin.x;
			normalizedSectionHeaderFrame.origin.y += section.frame.origin.y;
			if (CGRectIntersectsRect(normalizedSectionHeaderFrame, rect)) {
				UICollectionViewLayoutAttributes *layoutAttributes;
				layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RTCollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
				layoutAttributes.frame = normalizedSectionHeaderFrame;
				[layoutAttributesArray addObject:layoutAttributes];
			}
			
			//	section body
			for (RTFlowLayoutRow *row in section.rows) {
				//	figure out row's frame in global layout measurements
				CGRect normalizedRowFrame = row.rowFrame;
				normalizedRowFrame.origin.x += section.frame.origin.x;
				normalizedRowFrame.origin.y += section.frame.origin.y;
				
				if (CGRectIntersectsRect(normalizedRowFrame, rect)) {
					for (NSInteger itemIndex = 0; itemIndex < row.itemCount; itemIndex++) {
						UICollectionViewLayoutAttributes *layoutAttributes;
						NSUInteger sectionItemIndex;

						CGRect itemFrame;
						RTFlowLayoutItem *item = row.items[itemIndex];
						sectionItemIndex = [section.items indexOfObject:item];
						itemFrame = item.itemFrame;

						layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:sectionItemIndex inSection:sectionIndex]];
						layoutAttributes.frame = CGRectMake(normalizedRowFrame.origin.x + itemFrame.origin.x,
															normalizedRowFrame.origin.y + itemFrame.origin.y,
															itemFrame.size.width,
															itemFrame.size.height);
						[layoutAttributesArray addObject:layoutAttributes];
					}
				}
			}

			//	section footer
			CGRect normalizedSectionFooterFrame = section.footerFrame;
			normalizedSectionFooterFrame.origin.x += section.frame.origin.x;
			normalizedSectionFooterFrame.origin.y += section.frame.origin.y;
			if (CGRectIntersectsRect(normalizedSectionFooterFrame, rect)) {
				UICollectionViewLayoutAttributes *layoutAttributes;
				layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RTCollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
				layoutAttributes.frame = normalizedSectionFooterFrame;
				[layoutAttributesArray addObject:layoutAttributes];
			}
			
		}

	}
	
	//	footer
	CGRect normalizedFooterFrame = self.layoutInfo.footerFrame;
	if (CGRectIntersectsRect(normalizedFooterFrame, rect)) {
		UICollectionViewLayoutAttributes *layoutAttributes;
		layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:RTCollectionElementKindFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
		layoutAttributes.frame = normalizedFooterFrame;
		[layoutAttributesArray addObject:layoutAttributes];
	}

	return layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	RTFlowLayoutSection *section = self.layoutInfo.sections[indexPath.section];
	RTFlowLayoutRow *row = nil;
	CGRect itemFrame = CGRectZero;
	
	if (indexPath.item < (NSInteger)[section.items count]) {
		RTFlowLayoutItem *item = section.items[indexPath.item];
		row = item.rowObject;
		itemFrame = item.itemFrame;
	}
	
	UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	
	// calculate item rect
	CGRect normalizedRowFrame = row.rowFrame;
	normalizedRowFrame.origin.x += section.frame.origin.x;
	normalizedRowFrame.origin.y += section.frame.origin.y;
	layoutAttributes.frame = CGRectMake(normalizedRowFrame.origin.x + itemFrame.origin.x, normalizedRowFrame.origin.y + itemFrame.origin.y, itemFrame.size.width, itemFrame.size.height);
	
	return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

	UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
	
	if ([kind isEqualToString:RTCollectionElementKindHeader]) {
		layoutAttributes.frame = self.layoutInfo.headerFrame;

	} else if ([kind isEqualToString:RTCollectionElementKindFooter]) {
		layoutAttributes.frame = self.layoutInfo.footerFrame;
			
	} else {
		RTFlowLayoutSection *section = self.layoutInfo.sections[indexPath.section];

		if ([kind isEqualToString:RTCollectionElementKindSectionHeader]) {
			layoutAttributes.frame = section.headerFrame;

		} else if ([kind isEqualToString:RTCollectionElementKindSectionFooter]) {
			layoutAttributes.frame = section.footerFrame;
		}
	}

	return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewWithReuseIdentifier:(NSString*)identifier atIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (CGSize)collectionViewContentSize {
	return self.layoutInfo.contentSize;
}

#pragma mark - Invalidating the Layout

- (void)invalidateLayout {
	//	use this method to clear any cached layout data
	[super invalidateLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//	return [super shouldInvalidateLayoutForBoundsChange:newBounds];

	// we need to recalculate on width changes
	if ((self.collectionView.bounds.size.width != newBounds.size.width && self.scrollDirection == UICollectionViewScrollDirectionHorizontal) || (self.collectionView.bounds.size.height != newBounds.size.height && self.scrollDirection == UICollectionViewScrollDirectionVertical)) {
		return YES;
	}
	return NO;
}

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
	return proposedContentOffset;
}

- (void)prepareLayout {

	self.layoutInfo = [RTFlowLayoutInfo new]; // clear old layout data
	self.layoutInfo.scrollDirection = self.scrollDirection;
	self.layoutInfo.collectionViewSize = self.collectionView.bounds.size;

	[self fetchItemsInfo];

}

#pragma mark - Private

- (void)fetchItemsInfo {
	[self getSizingInfos];

	[self updateItemsLayout];
}

//	get size of all items, if delegate has supplied them
- (void)getSizingInfos {
	NSAssert([self.layoutInfo.sections count] == 0, @"Layout is already populated?");
	
	BOOL isHorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);
	
	//	adjust header/footer frames to span entire respective dimension of the collection view
	if (isHorizontal) {
		self.headerReferenceSize = CGSizeMake(self.headerReferenceSize.width, self.collectionView.bounds.size.height);
		self.footerReferenceSize = CGSizeMake(self.footerReferenceSize.width, self.collectionView.bounds.size.height);
	} else {
		self.headerReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, self.headerReferenceSize.height);
		self.footerReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, self.footerReferenceSize.height);
	}

	self.layoutInfo.headerFrame = (CGRect){.size=self.headerReferenceSize};
	self.layoutInfo.footerFrame = (CGRect){.size=self.footerReferenceSize};
	
	id <RTFlowLayoutDelegate> flowDataSource = (id <RTFlowLayoutDelegate>)self.collectionView.dataSource;
	
	NSUInteger numberOfSections = [self.collectionView numberOfSections];
	for (NSUInteger section = 0; section < numberOfSections; section++) {
		RTFlowLayoutSection *layoutSection = [self.layoutInfo addSection];
		
		layoutSection.headerFrame = (CGRect){.size=self.sectionHeaderReferenceSize};
		if ([flowDataSource respondsToSelector:@selector(collectionView:layout:sizeForHeaderInSection:)]) {
			layoutSection.headerFrame = (CGRect){.size=[flowDataSource collectionView:self.collectionView layout:self sizeForHeaderInSection:section]};
		}

		layoutSection.footerFrame = (CGRect){.size=self.sectionFooterReferenceSize};
		if ([flowDataSource respondsToSelector:@selector(collectionView:layout:sizeForFooterInSection:)]) {
			layoutSection.footerFrame = (CGRect){.size=[flowDataSource collectionView:self.collectionView layout:self sizeForFooterInSection:section]};
		}

		layoutSection.sectionMargins = self.sectionInset;
		if ([flowDataSource respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
			layoutSection.sectionMargins = [flowDataSource collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
		}

		layoutSection.verticalInterstice = isHorizontal ? self.minimumInteritemSpacing : self.minimumLineSpacing;
		layoutSection.horizontalInterstice = !isHorizontal ? self.minimumInteritemSpacing : self.minimumLineSpacing;

		if ([flowDataSource respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
			CGFloat minimumLineSpacing = [flowDataSource collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
			if (isHorizontal)
				layoutSection.horizontalInterstice = minimumLineSpacing;
			else
				layoutSection.verticalInterstice = minimumLineSpacing;
		}
		
		if ([flowDataSource respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
			CGFloat minimumInterimSpacing = [flowDataSource collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
			if (isHorizontal)
				layoutSection.verticalInterstice = minimumInterimSpacing;
			else
				layoutSection.horizontalInterstice = minimumInterimSpacing;
		}
		
		NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
		
		BOOL implementsSizeDelegate = [flowDataSource respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
		for (NSUInteger item = 0; item < numberOfItems; item++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
			CGSize itemSize = implementsSizeDelegate ? [flowDataSource collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath] : self.itemSize;

			RTFlowLayoutItem *layoutItem = [layoutSection addItem];
			layoutItem.itemFrame = (CGRect){.size=itemSize};
		}
	}
}

- (void)updateItemsLayout {
	CGSize contentSize = CGSizeZero;
	BOOL isHorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);

	//	global header
	if (isHorizontal) {
		contentSize.width += self.layoutInfo.headerFrame.size.width;
		contentSize.height = fmaxf(contentSize.height, self.layoutInfo.headerFrame.size.height);
	} else {
		contentSize.width = fmaxf(contentSize.width, self.layoutInfo.headerFrame.size.width);
		contentSize.height += self.layoutInfo.headerFrame.size.height;
	}

	//	sections
	for (RTFlowLayoutSection *section in self.layoutInfo.sections) {
		[section computeLayout];
		
		// update section offset to make frame absolute (section only calculates relative)
		CGRect sectionFrame = section.frame;
		CGRect headerFrame = section.headerFrame;
		CGRect footerFrame = section.footerFrame;
		if (isHorizontal) {
			headerFrame.size.height = self.collectionView.bounds.size.height;
			footerFrame.size.height = self.collectionView.bounds.size.height;
			sectionFrame.origin.x += contentSize.width;
			contentSize.width += section.frame.size.width + section.frame.origin.x;
			contentSize.height = fmaxf(contentSize.height, sectionFrame.size.height + section.frame.origin.y);
		} else {
			headerFrame.size.width = self.collectionView.bounds.size.width;
			footerFrame.size.width = self.collectionView.bounds.size.width;
			sectionFrame.origin.y += contentSize.height;
			contentSize.height += sectionFrame.size.height + section.frame.origin.y;
			contentSize.width = fmaxf(contentSize.width, sectionFrame.size.width + section.frame.origin.x);
		}
		section.frame = sectionFrame;
		section.headerFrame = headerFrame;
		section.footerFrame = footerFrame;
	}

	//	global footer
	CGPoint footerOrigin = CGPointZero;
	if (isHorizontal) {
		footerOrigin.x = contentSize.width;
		contentSize.width += self.layoutInfo.footerFrame.size.width;
		contentSize.height = fmaxf(contentSize.height, self.layoutInfo.footerFrame.size.height);
	} else {
		footerOrigin.y = contentSize.height;
		contentSize.width = fmaxf(contentSize.width, self.layoutInfo.footerFrame.size.width);
		contentSize.height += self.layoutInfo.footerFrame.size.height;
	}
	self.layoutInfo.footerFrame = (CGRect){.origin=footerOrigin, .size=self.layoutInfo.footerFrame.size};
	
	self.layoutInfo.contentSize = contentSize;
}

@end