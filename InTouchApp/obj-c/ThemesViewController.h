//
//  ThemesViewController.h
//  InTouchApp
//
//  Created by Михаил Борисов on 02/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"
NS_ASSUME_NONNULL_BEGIN



@interface ThemesViewController : UIViewController {
}
@property (nonatomic, retain) id<ThemesViewControllerDelegate> delegate;
@property (nonatomic, retain) Themes * model;

@end

NS_ASSUME_NONNULL_END
