//
//  ProgressViewController.m
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import "ProgressViewController.h"
#import "Task.h"
#import "UserDefaultManager.h"
#import "CustomTableViewCell.h"
#import "DetailsViewController.h"

@interface ProgressViewController ()

@property (nonatomic) NSMutableArray<Task*> *progressTasks;
@property (nonatomic) int numberOfSections;
@property (nonatomic) BOOL isFiltered;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *noTasksImage;

@end

@implementation ProgressViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.tabBarController.navigationItem.rightBarButtonItems[0] setHidden:YES];
    [self.tabBarController.navigationItem.rightBarButtonItems[1] setHidden:NO];
    [self.tabBarController.navigationItem setTitle:@"Progress Screen"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _numberOfSections = 1;
    _isFiltered = NO;
    _progressTasks = [NSMutableArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self update];
}

- (void)fetchProgresTasks {
    [_progressTasks removeAllObjects];
    for (Task* task in [UserDefaultManager fetchSavedTasks]) {
        if (task.state == 1) {
            [_progressTasks addObject:task];
        }
    }
}

- (void)update {
    [self fetchProgresTasks];
    _progressTasks.count > 0 ? [_noTasksImage setHidden:YES] : [_noTasksImage setHidden:NO];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isFiltered) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFiltered) {
        NSArray * filteredTasks = [self getFilteredTasks:section];
        return filteredTasks.count;
    }
    return _progressTasks.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_isFiltered) {
        switch(section) {
            case 0:
                return @"Low";
            case 1:
                return @"Medium";
            case 2:
                return @"High";
            default:
                return nil;
        }
    } else {
        return nil;
    }
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell"];
    
    Task* currentTask;
    if (_isFiltered) {
        NSArray* filteredTasks = [self getFilteredTasks:indexPath.section];
        currentTask = filteredTasks[indexPath.row];
    } else {
        currentTask = [_progressTasks objectAtIndex:indexPath.row];
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
    detailsVC.selectedTask = [_progressTasks objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete task" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            Task* taskToDelete;
            
            if (self->_isFiltered) {
                NSArray *filteredTasks = [self getFilteredTasks:indexPath.section];
                taskToDelete = filteredTasks[indexPath.row];
            } else {
                taskToDelete = self->_progressTasks[indexPath.row];
            }
            
            [UserDefaultManager deleteTaskWithId:taskToDelete.taskID];
            [self->_progressTasks removeObject:taskToDelete];
            self->_progressTasks.count > 0 ? [self->_noTasksImage setHidden:YES] : [self->_noTasksImage setHidden:NO];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:delete];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (NSArray *)getFilteredTasks:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority == %ld", (long)section];
    NSArray *filteredTasks = [_progressTasks filteredArrayUsingPredicate:predicate];
    return filteredTasks;
}

- (void) filterTasks {
    
    _isFiltered = !_isFiltered;
    [_tableView reloadData];
}

@end
