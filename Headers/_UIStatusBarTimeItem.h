@interface _UIStatusBarTimeItem
@property (copy) _UIStatusBarStringView *shortTimeView;
@property (copy) _UIStatusBarStringView *pillTimeView;
@property (nonatomic, retain) NSTimer *timer;
- (void)overwriteText:(NSTimer *)timer;
@end
