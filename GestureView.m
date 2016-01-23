#import "GestureView.h"



@interface Stroke : NSObject

@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) UIColor *color;

@end


//@implementation Stroke
//
//@synthesize points, color;
//
//@end


NSTimer *myTimer;
BOOL recognized;
@implementation GestureView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self setup];
}

- (void)setup {
    currentTouches = [[NSMutableDictionary alloc] init];
    completeStrokes = [NSMutableArray array];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setMultipleTouchEnabled:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UIView *view= [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    UIImageView *myImageView = (UIImageView *)[view viewWithTag:15];
    myImageView.alpha=0.35;
    
    UIView *view1= [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    UIImageView *myImageView1 = (UIImageView *)[view1 viewWithTag:14];
    myImageView1.alpha=0.35;
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        CGPoint location = [touch locationInView:self];
        
        Stroke *stroke = [[Stroke alloc] init];
        [stroke setPoints:[NSMutableArray arrayWithObject:
                           [NSValue valueWithCGPoint:location]]];
        [stroke setColor:[UIColor blackColor]];
        
        [currentTouches setObject:stroke forKey:key];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [myTimer invalidate];
    
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        NSMutableArray *points = [[currentTouches objectForKey:key] points];
        CGPoint location = [touch locationInView:self];
        [points addObject:[NSValue valueWithCGPoint:location]];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    [self endTouches:touches];
}

- (void)endTouches:(NSSet *)touches {
    myTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(sendNotification) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer: myTimer forMode: NSDefaultRunLoopMode];
    
    
    
    //    [self setUserInteractionEnabled:!recognized];
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        Stroke *stroke = [currentTouches objectForKey:key];
        [stroke setColor:[self randomColor]];
        
        if (stroke) {
            [completeStrokes addObject:stroke];
            [currentTouches removeObjectForKey:key];
        }
    }
    
    [self setNeedsDisplay];
}
-(void)sendNotification{
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated"
                                                        object:self];
    
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 5.0);

    CGContextSetLineCap(context, kCGLineCapRound);
    
    for (int i = 0; i < [completeStrokes count]; i++) {
        Stroke *stroke = [completeStrokes objectAtIndex:i];
        [self drawStroke:stroke inContext:context];
    }
    
    for (NSValue *touchValue in currentTouches) {
        Stroke *stroke = [currentTouches objectForKey:touchValue];
        [self drawStroke:stroke inContext:context];
    }
}

- (void)drawStroke:(Stroke *)stroke
         inContext:(CGContextRef)context {
    [[stroke color] set];
    
    NSMutableArray *points = [stroke points];
    CGPoint point = [points[0] CGPointValue];
    
    CGContextFillRect(context, CGRectMake(point.x - 5, point.y - 5, 10, 10));
    
    CGContextMoveToPoint(context, point.x, point.y);
    for (int i = 1; i < [points count]; i++) {
        point = [points[i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextStrokePath(context);
}

- (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)clearAll {
    [completeStrokes removeAllObjects];
    [currentTouches removeAllObjects];
    
    [self setNeedsDisplay];
}

@end

