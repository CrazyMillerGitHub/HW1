//
//  ThemesViewController.m
//  InTouchApp
//
//  Created by Михаил Борисов on 02/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

#import "ThemesViewController.h"
#import "InTouchApp-Swift.h"
@interface ThemesViewController () {
  ConversationsListViewController *ViewController;
}
@end


@implementation ThemesViewController

- (IBAction)firstThemeButton:(id)sender {
  Themes *model = [[Themes alloc] init];
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: model.theme1];
  self.view.backgroundColor = model.theme1;
  [model release];
  [ViewController release];
}
- (IBAction)secondThemeButton:(id)sender {
  Themes *model = [[Themes alloc] init];
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: [model theme2]];
  self.view.backgroundColor = [model theme2];
  [model release];
  [ViewController release];
}
- (IBAction)thirdThemeButton:(id)sender {
  Themes *model = [[Themes alloc] init];
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: [model theme3]];
  self.view.backgroundColor = [model theme3];
  [model release];
  [ViewController release];
}
- (void)themesViewController:(ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme {
  
}
- (IBAction)returnButton:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
  //  Themes * theme = [[Themes alloc] init];
    // Do any additional setup after loading the view.
}
- (void)dealloc
{
  [_delegate release];
  [_model release];
  [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
