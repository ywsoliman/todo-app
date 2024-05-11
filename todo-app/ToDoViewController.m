//
//  ViewController.m
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import "ToDoViewController.h"
#import "DetailsViewController.h"
#import "Task.h"
#import "UserDefaultManager.h"
#import "CustomTableViewCell.h"

@interface ToDoViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *noTasksImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray<Task*> *todoTasks;
@property NSMutableArray<Task*> *searchedTasks;

@end

@implementation ToDoViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.tabBarController.navigationItem.rightBarButtonItems[0] setHidden:NO ];
    [self.tabBarController.navigationItem.rightBarButtonItems[1] setHidden:YES ];
    [self.tabBarController.navigationItem setTitle:@"To Do Screen"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchBar.delegate = self;
    _todoTasks = [NSMutableArray new];
    _searchedTasks = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self update];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (_searchedTasks.count > 0) {
        numberOfRows = _searchedTasks.count;
    }
    else if (_searchBar.text.length > 0) {
        [_noTasksImage setHidden:NO];
    } else {
        numberOfRows = _todoTasks.count;
    }
    [_noTasksImage setHidden:(numberOfRows > 0)];
    return numberOfRows;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell"];
    
    Task* currentTask;
    if (_searchedTasks.count > 0) {
        currentTask = [_searchedTasks objectAtIndex:indexPath.row];
    } else {
        currentTask = [_todoTasks objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = currentTask.title;
    
    cell.priorityImg.image = (currentTask.priority == 0) ? [UIImage imageNamed:@"low-priority"] : ((currentTask.priority == 1) ? [UIImage imageNamed:@"medium-priority"] : [UIImage imageNamed:@"high-priority"]);
    
    cell.descLabel.text = currentTask.desc;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:currentTask.date];
    cell.dateLabel.text = stringFromDate;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsVC"];
    detailsVC.selectedTask = [_todoTasks objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete task" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            Task* taskToDelete = self->_todoTasks[indexPath.row];
            
            [UserDefaultManager deleteTaskWithId:taskToDelete.taskID];
            [self->_todoTasks removeObject:taskToDelete];
            self->_todoTasks.count > 0 ? [self->_noTasksImage setHidden:YES] : [self->_noTasksImage setHidden:NO];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:delete];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _searchedTasks = [[NSMutableArray alloc]init];
    for (Task *task in _todoTasks) {
        
        NSString* lowercaseTitle = [task.title lowercaseString];
        NSString* lowercaseSearch = [searchText lowercaseString];
        
        if ([lowercaseTitle hasPrefix:lowercaseSearch]) {
            [_searchedTasks addObject:task];
        }
        
    }
    
    [self.tableView reloadData];
    
}


- (void) fetchTodoTasks {
    [_todoTasks removeAllObjects];
    for (Task* task in [UserDefaultManager fetchSavedTasks]) {
        if (task.state == 0) {
            [_todoTasks addObject:task];
        }
    }
}

- (void)update {
    [self fetchTodoTasks];
    _todoTasks.count > 0 ? [_noTasksImage setHidden:YES] : [_noTasksImage setHidden:NO];
    [_tableView reloadData];
}

@end
