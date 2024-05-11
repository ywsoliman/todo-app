//
//  ProgressViewController.h
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (void) filterTasks;

@end

NS_ASSUME_NONNULL_END
