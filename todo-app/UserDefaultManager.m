//
//  UserDefaultManager.m
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (void)archiveData:(NSMutableArray *)arr {
    NSData* archivedData = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:archivedData forKey:@"tasks"];
}

+ (void)addTask:(nonnull Task *)task {

    NSMutableArray* arr = [self fetchSavedTasks];
    
    [arr addObject:task];
    
    [self archiveData:arr];
    
}

+ (nonnull NSMutableArray *)fetchSavedTasks {
    NSData* savedTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"tasks"];
    
    NSMutableArray<Task *> *tasks;
    
    if (savedTasks == nil) {
        tasks = [NSMutableArray<Task *> array];
    } else {
        NSData* savedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"tasks"];
        NSSet* set = [NSSet setWithArray:@[[NSArray class], [Task class]]];
        tasks = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:nil];
    }
    return tasks;
}

+ (void)deleteTaskWithId:(NSString*) deletedTaskId {
    NSMutableArray* arr = [self fetchSavedTasks];
    
    for (Task* task in arr) {
        if ([task.taskID isEqual:deletedTaskId]) {
            [arr removeObject:task];
            break;
        }
    }
    
    [self archiveData:arr];
}

+ (void)updateTask:(Task*) updatedTask {
    
    NSMutableArray* arr = [self fetchSavedTasks];
    for (int i = 0; i < arr.count; i++) {
        if ([[[arr objectAtIndex:i] taskID] isEqual:updatedTask.taskID]) {
            [arr replaceObjectAtIndex:i withObject:updatedTask];
            [self archiveData:arr];
            break;
        }
    }
    
}

@end
