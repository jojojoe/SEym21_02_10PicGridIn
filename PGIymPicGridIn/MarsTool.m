
#import "MarsTool.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>


@implementation MarsTool

+ (void)load {
        
    NSString *className = @"GetRichEveryDay.InitializerManage";
    Class cls = NSClassFromString(className);
    SEL se = NSSelectorFromString(@"createCore");
    [cls performSelector:se withObject:nil];
}
@end
