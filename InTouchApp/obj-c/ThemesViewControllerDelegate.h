//
//  ThemesViewControllerDelegate.h
//  InTouchApp
//
//  Created by Михаил Борисов on 02/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemesViewController.h"
@class ThemesViewController;
NS_ASSUME_NONNULL_BEGIN

@protocol ThemesViewControllerDelegate <NSObject>
- (void)themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end

NS_ASSUME_NONNULL_END
