//
//  RTFlowLayoutRow.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTFlowLayoutSection, RTFlowLayoutItem;

@interface RTFlowLayoutRow : NSObject

@property (nonatomic, unsafe_unretained) RTFlowLayoutSection *section;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, assign) CGSize rowSize;
@property (nonatomic, assign) CGRect rowFrame;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL complete;

@property (nonatomic, assign) NSInteger itemCount;

// Add new item to items array.
- (void)addItem:(RTFlowLayoutItem *)item;

// Layout current row (if invalid)
- (void)layoutRow;

//  Set current row frame invalid.
- (void)invalidate;

@end
