//
//  DetailsViewController.h
//  todo-app
//
//  Created by Youssef Waleed on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "UpdateTableProtocol.h"
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController<UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate>

@property Task* selectedTask;
@property id<UpdateTableProtocol> ref;

@end

NS_ASSUME_NONNULL_END
