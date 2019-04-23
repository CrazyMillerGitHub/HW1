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
  Themes * _model;
}
@end


@implementation ThemesViewController
- (Themes *)model{
  return _model;
}
- (IBAction)gesture:(id)sender {
      
}
- (void)setModel:(Themes *)model{
  [_model release];
  _model = [model retain];
}
- (IBAction)firstThemeButton:(id)sender {

  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: _model.theme1];
  self.view.backgroundColor = _model.theme1;
  [ViewController release];
}
- (IBAction)secondThemeButton:(id)sender {
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: _model.theme2];
  self.view.backgroundColor = _model.theme2;
  [ViewController release];
}
- (IBAction)thirdThemeButton:(id)sender {
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: _model.theme3];
  self.view.backgroundColor = _model.theme3;
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
