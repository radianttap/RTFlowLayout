//
//  RTFlowLayoutInfo.h
//  RTFlowLayout
//
//  Created by Aleksandar Vacić on 21.10.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTFlowLayoutSection;

@interface RTFlowLayoutInfo : NSObject

@property (nonatomic, strong, readonly) NSArray *sections;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

//	global header
@property (nonatomic, assign) CGRect headerFrame;
//	global footer
@property (nonatomic, assign) CGRect footerFrame;

// Frame for specific RTFlowLayoutItem.
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;

// Add new section. Invalidates layout.
- (RTFlowLayoutSection *)addSection;

// forces the layout to recompute on next access
- (void)invalidate;

@end
