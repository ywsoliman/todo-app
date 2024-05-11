//
//  Task.h
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSInteger, PRIORITY) {
//    LOW,
//    MEDIUM,
//    HIGH,
//};
//
//typedef NS_ENUM(NSInteger, STATE) {
//    TODO,
//    PROGRESS,
//    DONE,
//};

@interface Task : NSObject<NSCoding, NSSecureCoding>

@property (nonatomic, readonly) NSString *taskID;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* desc;
@property (nonatomic) NSInteger priority;
@property (nonatomic) NSInteger state;
@property (nonatomic) NSDate* date;
@property (nonatomic) NSString* attachmentPath;

-(instancetype) initWithTitle: (NSString*) title andDesc: (NSString*) desc andPriority: (NSInteger) priority andState: (NSInteger) state andDate: (NSDate*) date andAttachmentPath: (NSString* ) path;

@end

NS_ASSUME_NONNULL_END
