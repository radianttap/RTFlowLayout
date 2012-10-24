//
//  RTFlowLayoutItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTFlowLayoutSection, RTFlowLayoutRow;

// Represents a single grid item; only created for non-uniform-sized grids.
@interface RTFlowLayoutItem : NSObject

@property (nonatomic, unsafe_unretained) RTFlowLayoutSection *section;
@property (nonatomic, unsafe_unretained) RTFlowLayoutRow *rowObject;
@property (nonatomic, assign) CGRect itemFrame;

@end
