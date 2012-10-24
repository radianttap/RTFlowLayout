//
//  RTFlowLayout.h
//  RTFlowLayout
//
//  Created by Aleksandar Vacić on 28.9.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
/*

##	This layout is actually multiple layouts in one, with animated transitions between them
 
##	Simplest form is largely modeled on UICollectionViewFlowLayout, but I did it from scratch for several reasons
	• it helped me learn how this layouting business actually work
	• it serves as good example how to add additional supplementary views (there aren't any of these at the moment of publishing)
	  - adding new supplementaries like I did requires you to re-compute entire layout, thus I avoided FlowLayout
	  - it might be possible to do this by simply subclassing FlowLayout and adjusting relevant methods - I have not tried that
	• each section can have a different sub-layout and it's possible to extend and customize it for new sub-layouts

##	Huge shout out to Peter Steinberger for https://github.com/steipete/PSTCollectionView
	- this layout is extensively using and building upon his work, especially section/row/item data structure

##	iOS6 only, of course, since it's based on UICollectionViewLayout

*/


#import <UIKit/UIKit.h>

//	supplementary views
UIKIT_EXTERN NSString *const RTCollectionElementKindHeader;
UIKIT_EXTERN NSString *const RTCollectionElementKindFooter;
UIKIT_EXTERN NSString *const RTCollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const RTCollectionElementKindSectionFooter;


@class RTFlowLayout;

@protocol RTFlowLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout sizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout sizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(RTFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
@end


//	PUBLIC API
@interface RTFlowLayout : UICollectionViewLayout

@property (nonatomic) CGSize headerReferenceSize;						//	default is Zero, can be only one header
@property (nonatomic) CGSize footerReferenceSize;						//	default is Zero, can be only one footer
@property (nonatomic) CGSize sectionHeaderReferenceSize;					//	default is Zero, use protocol method to set it per section
@property (nonatomic) CGSize sectionFooterReferenceSize;					//	default is Zero, use protocol method to set it per section

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;	//	default is vertical
@property (nonatomic) CGSize itemSize;									//	default is 80x50
@property (nonatomic) UIEdgeInsets sectionInset;							//	default is 0,0,0,0
@property (nonatomic) CGFloat minimumLineSpacing;						//	default is 8
@property (nonatomic) CGFloat minimumInteritemSpacing;					//	default is 8

@end


