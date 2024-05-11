//
//  DetailsViewController.m
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import "DetailsViewController.h"
#import "Task.h"
#import "UserDefaultManager.h"
#import <UserNotifications/UserNotifications.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UniformTypeIdentifiers/UniformTypeIdentifiers.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addAndEditBtn;
@property (weak, nonatomic) IBOutlet UIImageView *priorityImg;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmented;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmented;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *attachedFileLabel;
@property (weak, nonatomic) IBOutlet UIButton *openDocumentBtn;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_datePicker setMinimumDate:[NSDate date]];
    
    if (_selectedTask != nil) {
        
        [_addAndEditBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [self setSelectedTaskData];
        
    } else {
        
        [_addAndEditBtn setTitle:@"Add" forState:UIControlStateNormal];
        [_stateSegmented setEnabled:NO forSegmentAtIndex:1];
        [_stateSegmented setEnabled:NO forSegmentAtIndex:2];
        
    }
}

- (void)setPriorityImage {
    switch (self.prioritySegmented.selectedSegmentIndex) {
        case 0:
            [_priorityImg setImage:[UIImage imageNamed:@"low-priority"]];
            break;
        case 1:
            [_priorityImg setImage:[UIImage imageNamed:@"medium-priority"]];
            break;
        case 2:
            [_priorityImg setImage:[UIImage imageNamed:@"high-priority"]];
            break;
    }
}

- (IBAction)onChangePriority:(UISegmentedControl *)sender {
    [self setPriorityImage];
    
}

- (IBAction)addButton:(UIButton *)sender {
    
    NSString* trimmedText = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedText.length == 0) {
        [self noNameAlert];
    } else {
        [self saveTask];
    }
    
}

-(void) noNameAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed to add task" message:@"Please provide a name for the task" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* dismiss = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:dismiss];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)setSelectedTaskData {
    _nameTextField.text = _selectedTask.title;
    _descTextField.text = _selectedTask.desc;
    [_prioritySegmented setSelectedSegmentIndex:_selectedTask.priority];
    [_stateSegmented setSelectedSegmentIndex:_selectedTask.state];
    _datePicker.date = _selectedTask.date;
    [self setPriorityImage];
    for (int i = 0; i < _selectedTask.state; i++) {
        [_stateSegmented setEnabled:NO forSegmentAtIndex:i];
    }
    _attachedFileLabel.text = _selectedTask.attachmentPath;
}

- (void)updateSelectedTask {
    _selectedTask.title = _nameTextField.text;
    _selectedTask.desc = _descTextField.text;
    _selectedTask.priority = _prioritySegmented.selectedSegmentIndex;
    _selectedTask.state = _stateSegmented.selectedSegmentIndex;
    _selectedTask.date = _datePicker.date;
    _selectedTask.attachmentPath = _attachedFileLabel.text;
    [UserDefaultManager updateTask:_selectedTask];
    if (_selectedTask.priority == 2) {
        [self createNotification:_selectedTask];
    }
}

- (void)createNotification:(Task *)task {
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"URGENT: %@", task.title] arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:task.desc     arguments:nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *date = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:task.date];
    
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
                                              triggerWithDateMatchingComponents:date repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest
                                      requestWithIdentifier:@"reminder" content:content trigger:trigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center addNotificationRequest:request withCompletionHandler:nil];
}

-(void) saveTask {
    
    if (_selectedTask == nil) {
        
        Task* task = [[Task alloc] initWithTitle:_nameTextField.text andDesc:_descTextField.text andPriority: self.prioritySegmented.selectedSegmentIndex andState:self.stateSegmented.selectedSegmentIndex andDate:_datePicker.date andAttachmentPath:_attachedFileLabel.text];
        
        [self addTaskConfirmation:task];
        
        if (task.priority == 2) {
            [self createNotification:task];
        }
        
        [_ref update];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self editTaskAlertConfirmation];
    }
}

-(void) addTaskConfirmation: (Task*) task {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Adding task" message:@"Are you sure you want to add this task?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [UserDefaultManager addTask:task];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancel];
    [alert addAction:edit];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) editTaskAlertConfirmation {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Editing task" message:@"Are you sure you want to confirm these edits?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self updateSelectedTask];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancel];
    [alert addAction:edit];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
