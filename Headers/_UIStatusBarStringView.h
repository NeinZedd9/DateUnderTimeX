@interface _UIStatusBarStringView : UILabel
@property (nonatomic, retain) NSString *leftSideText;
@property (nonatomic, retain) NSString *rightSideText;
@property (assign, nonatomic, getter=isLeftSideLabel) BOOL leftSideLabel;
- (void)setTextRightSide;
@end
