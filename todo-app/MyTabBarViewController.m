//
//  MyTabBarViewController.m
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import "MyTabBarViewController.h"
#import "DetailsViewController.h"
#import "ToDoViewController.h"
#import "ProgressViewController.h"
#import "DoneViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)plusButton:(UIBarButtonItem *)sender {
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    
    ToDoViewController *todoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"todoVC"];
    
    detailsVC.ref = todoVC;
    
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (IBAction)filterButton:(UIBarButtonItem *)sender {
    
    [self toggleFilterIcon:sender];
    
    UIViewController *selectedViewController = self.selectedViewController;
    
    if ([selectedViewController isKindOfClass:[ProgressViewController class]]) {
        
        ProgressViewController* progressVC = (ProgressViewController*)selectedViewController;
        [progressVC filterTasks];
        
    } else if ([selectedViewController isKindOfClass:[DoneViewController class]]) {
        
        DoneViewController* doneVC = (DoneViewController*)selectedViewController;
        [doneVC filterTasks];
        
    }
    
}

- (void)toggleFilterIcon:(UIBarButtonItem *)sender {
    if ([sender.image isEqual:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle"]]) {
        [sender setImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle.fill"]];
    } else {
        [sender setImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle"]];
    }
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
