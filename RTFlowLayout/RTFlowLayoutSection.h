//
//  RTCollectionLayoutSection.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTFlowLayoutInfo, RTFlowLayoutRow, RTFlowLayoutItem;

@interface RTFlowLayoutSection : NSObject

@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong, readonly) NSArray *rows;
@property (nonatomic, readonly) NSInteger itemsCount;

@property (nonatomic, assign) CGFloat verticalInterstice;
@property (nonatomic, assign) CGFloat horizontalInterstice;
@property (nonatomic, assign) UIEdgeInsets sectionMargins;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect bodyFrame;
@property (nonatomic, assign) CGRect footerFrame;
@property (nonatomic, unsafe_unretained) RTFlowLayoutInfo *layoutInfo;

@property (nonatomic, assign, readonly) NSInteger indexOfIncompleteRow; // typo as of iOS6B3

// Invalidate layout. Destroys rows.
- (void)invalidate;

// Compute layout. Creates rows.
- (void)computeLayout;

- (RTFlowLayoutItem *)addItem;
- (RTFlowLayoutRow *)addRow;

@end
