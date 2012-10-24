//
//  RTFlowLayoutItem.m
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "RTFlowLayoutItem.h"

@implementation RTFlowLayoutItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p itemFrame:%@>", NSStringFromClass([self class]), self, NSStringFromCGRect(self.itemFrame)];
}

@end
