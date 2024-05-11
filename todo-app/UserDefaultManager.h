//
//  UserDefaultManager.h
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultManager : NSObject

+ (NSMutableArray*) fetchSavedTasks;
+ (void) addTask: (Task*) task;
+ (void) deleteTaskWithId:(NSString*) deletedTaskId;
+ (void) updateTask:(Task*) updatedTask;

@end

NS_ASSUME_NONNULL_END
