//
//  ThemesViewController.m
//  InTouchApp
//
//  Created by Михаил Борисов on 02/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

#import "ThemesViewController.h"
#import "InTouchApp-Swift.h"

@interface ThemesViewController ()
@end


@implementation ThemesViewController

- (IBAction)firstThemeButton:(id)sender {
  Themes *theme = [[Themes alloc] init];
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: [theme theme1]];
  self.view.backgroundColor = [theme theme1];
}
- (IBAction)secondThemeButton:(id)sender {
  Themes *theme = [[Themes alloc] init];
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: [theme theme2]];
  self.view.backgroundColor = [theme theme2];
}
- (IBAction)thirdThemeButton:(id)sender {
  Themes *theme = [[Themes alloc] init];
  ConversationsListViewController *ViewController = [[ConversationsListViewController alloc]init];
  self.delegate = ViewController;
  [_delegate themesViewController:self didSelectTheme: [theme theme3]];
  self.view.backgroundColor = [theme theme3];
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
  
  [Themes release];
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
