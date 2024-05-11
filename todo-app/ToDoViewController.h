//
//  ViewController.h
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "UpdateTableProtocol.h"

@interface ToDoViewController : UIViewController<UpdateTableProtocol, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>


@end

