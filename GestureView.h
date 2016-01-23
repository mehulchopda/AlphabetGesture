
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface GestureView : UIView{
    NSMutableDictionary *currentTouches;
    NSMutableArray *completeStrokes;
    
}

- (void)clearAll;
-(void)sendNotification;
@end