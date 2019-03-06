//
//  Themes.h
//  InTouchApp
//
//  Created by Михаил Борисов on 03/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Themes : NSObject{
  UIColor* _theme1;
  UIColor* _theme2;
  UIColor* _theme3;
}
@property (readonly,retain) UIColor* theme1;
@property (readonly,retain) UIColor* theme2;
@property (readonly,retain) UIColor* theme3;
//- (UIColor *)theme1;
//- (UIColor *)theme2;
//- (UIColor *)theme3;
@end

NS_ASSUME_NONNULL_END
