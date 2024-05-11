//
//  Task.m
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import "Task.h"

@implementation Task

- (instancetype)initWithTitle:(nonnull NSString *)title andDesc:(nonnull NSString *)desc andPriority:(NSInteger)priority andState:(NSInteger)state andDate:(nonnull NSDate *)date andAttachmentPath:(nonnull NSString *)path {
    
    _taskID = [[NSUUID UUID] UUIDString];
    _title = title;
    _desc = desc;
    _priority = priority;
    _state = state;
    _date = date;
    _attachmentPath = path;
    
    return self;
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeObject:_taskID forKey:@"id"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_desc forKey:@"desc"];
    [encoder encodeInteger:_priority forKey:@"priority"];
    [encoder encodeInteger:_state forKey:@"state"];
    [encoder encodeObject:_date forKey:@"date"];
    [encoder encodeObject:_attachmentPath forKey:@"attachment"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        _taskID = [decoder decodeObjectOfClass:[NSString class] forKey:@"id"];
        _title = [decoder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _desc = [decoder decodeObjectOfClass:[NSString class] forKey:@"desc"];
        _priority = [decoder decodeIntegerForKey:@"priority"];
        _state = [decoder decodeIntegerForKey:@"state"];
        _date = [decoder decodeObjectOfClass:[NSDate class] forKey:@"date"];
        _attachmentPath = [decoder decodeObjectOfClass:[NSString class] forKey:@"attachment"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
