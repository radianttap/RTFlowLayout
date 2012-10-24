//
//  RTAppDelegate.h
//  RTFlowLayout
//
//  Created by Aleksandar Vacić on 24.10.12..
//  Copyright (c) 2012. Aleksandar Vacić. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTViewController;

@interface RTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RTViewController *viewController;

@end
