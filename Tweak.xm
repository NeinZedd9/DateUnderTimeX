@interface _UIStatusBarStringView : UIView
@property (copy) NSString *text;
@property NSInteger numberOfLines;
@property (copy) UIFont *font;
@property NSInteger textAlignment;
@end

%hook _UIStatusBarStringView

- (void)setText:(NSString *)text {
	if([text containsString:@":"]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = NSLocale.autoupdatingCurrentLocale;
		[dateFormatter setLocalizedDateFormatFromTemplate:@"dd/MM"];
		NSDate *now = [NSDate date];
		NSString *shortDate = [dateFormatter stringFromDate:now];
		NSString *newString = [NSString stringWithFormat:@"%@\n%@", text, shortDate];
		self.numberOfLines = 2;
		self.textAlignment = 1;
		[self setFont: [self.font fontWithSize:12]];
		%orig(newString);
	}
	else {
		%orig(text);
	}
}

%end

@interface _UIStatusBarTimeItem
@property (copy) _UIStatusBarStringView *shortTimeView;
@property (copy) _UIStatusBarStringView *pillTimeView;
@end

%hook _UIStatusBarTimeItem

- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2 {
	id returnThis = %orig;
	[self.shortTimeView setFont: [self.shortTimeView.font fontWithSize:12]];
	[self.pillTimeView setFont: [self.pillTimeView.font fontWithSize:12]];
	return returnThis;
}

%end

@interface _UIStatusBarBackgroundActivityView : UIView
@property (copy) CALayer *pulseLayer;
@end

%hook _UIStatusBarBackgroundActivityView

- (void)setCenter:(CGPoint)point {
	point.y = 11;
	self.frame = CGRectMake(0, 0, self.frame.size.width, 31);
	self.pulseLayer.frame = CGRectMake(0, 0, self.frame.size.width, 31);
	%orig(point);
}

%end
