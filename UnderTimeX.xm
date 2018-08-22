#import "./Headers/_UIStatusBarStringView.h"
#import "./Headers/_UIStatusBarTimeItem.h"
#import "./Headers/_UIStatusBarBackgroundActivityView.h"
#import "./Headers/_UIStatusBarForegroundView.h"
#import "./Functions.h"

static NSString *const kSettingsPath = @"/var/mobile/Library/Preferences/jp.i4m1k0su.undertimex.plist";

NSMutableDictionary *preferences;
UILabel *rightSideLabel;

static void loadPreferences() {

	//設定ファイルの有無チェック
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath: kSettingsPath]) {

		//ない場合にデフォルト設定を作成
		NSDictionary *defaultPreferences = @{
			@"sw_enabled":@YES,
			@"sl_interval":@60.0,
			@"lst_left_top_item":@3,
			@"lst_left_bottom_item":@0,
			@"lst_right_top_item":@-1
		};

		preferences = [[NSMutableDictionary alloc] initWithDictionary: defaultPreferences];
		[defaultPreferences release];

		#ifdef DEBUG
			BOOL result = [preferences writeToFile: kSettingsPath atomically: YES];
			if (!result) {
				NSLog(@"ファイルの書き込みに失敗");
			}
		#else
			[preferences writeToFile: kSettingsPath atomically: YES];
		#endif

	} else {
		//あれば読み込み
		preferences = [[NSMutableDictionary alloc] initWithContentsOfFile: kSettingsPath];
	}

}

static NSString *getDetail(int detailId) {
	switch(detailId) {
		case 0:
			return [Functions getTime];
		case 1:
			return [Functions getDate];
		case 2:
			return [Functions getDayOfTheWeek];
		case 3:
			return [Functions getDateAndDayOfTheWeek];
		case 4:
			return [NSString stringWithFormat:@"%@ MB", [Functions getFreeMemory]];
		// case 5:
		// 	return [Functions getSpeed];
		default:
			return @"";
	}
}

%group Main
%hook _UIStatusBarStringView

%property (nonatomic, retain) NSString *leftSideText;
%property (nonatomic, retain) NSString *rightSideText;
%property (assign, nonatomic, getter=isLeftSideLabel) BOOL leftSideLabel;

- (void)setText:(NSString *)text {
	self.leftSideLabel = [text containsString:@":"];
	if(self.isLeftSideLabel) {
		// 右側
		if ([[preferences objectForKey:@"lst_right_top_item"]intValue] != -1) {
			[self setTextRightSide];
		}

		NSString *top = getDetail([[preferences objectForKey:@"lst_left_top_item"]intValue]);
		NSString *bottom = getDetail([[preferences objectForKey:@"lst_left_bottom_item"]intValue]);
		text = [NSString stringWithFormat:@"%@\n%@", top, bottom];
		// 変更がないときは何もしない
		if ([text isEqualToString:self.leftSideText]) {
			return;
		}
		self.leftSideText = [NSString stringWithString:text];
		self.numberOfLines = 2;
		self.textAlignment = NSTextAlignmentCenter;
		self.font = [self.font fontWithSize:12];
	}

	return %orig(text);
}

%new - (void)setTextRightSide {
	NSString *right = getDetail([[preferences objectForKey:@"lst_right_top_item"]intValue]);
	// 変更がないときは何もしない
	if ([right isEqualToString:self.rightSideText]) {
		return;
	}
	self.rightSideText = [NSString stringWithString:right];
	rightSideLabel.text = right;
}

// テーマは文字列をセットしたあとに反映される
- (void)applyStyleAttributes:(id)arg1 {
	%orig;

	if(self.isLeftSideLabel) {
		self.font = [self.font fontWithSize:12];

		// 右側
		if ([[preferences objectForKey:@"lst_right_top_item"]intValue] != -1) {
			// 右側ラベルのテーマ変更
			rightSideLabel.textColor = self.textColor;
			rightSideLabel.font = [self.font fontWithSize:12];
			rightSideLabel.hidden = self.hidden;
		}
	}
}

%end

// %hook _UIStatusBarTimeItem

// %property (nonatomic, retain) NSTimer *timer;

// - (instancetype)init {
// 	%orig;
// 	// self.timer = [NSTimer scheduledTimerWithTimeInterval:[[preferences objectForKey:@"sl_interval"]floatValue] target:self selector:@selector(interval:) userInfo:nil repeats:YES];
// 	return self;
// }

// %new - (void)interval:(NSTimer *)timer {
// 	[self overwriteText];
// }

// %new - (void)overwriteText {
// 	self.shortTimeView.text = @":";
// 	self.pillTimeView.text = @":";
// 	[self.shortTimeView setFont: [self.shortTimeView.font fontWithSize:12]];
// 	[self.pillTimeView setFont: [self.pillTimeView.font fontWithSize:12]];
// }

// - (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2 {
// 	id orig = %orig;
// 	// [self overwriteText];
// 	return orig;
// }

// %end

%hook _UIStatusBarBackgroundActivityView

- (void)setCenter:(CGPoint)point {
	point.y = 11;
	self.frame = CGRectMake(0, 0, self.frame.size.width, 31);
	self.pulseLayer.frame = CGRectMake(0, 0, self.frame.size.width, 31);
	%orig(point);
}

%end

%hook _UIStatusBarForegroundView

- (instancetype)initWithFrame:(CGRect)frame {
    %orig;
	if ([[preferences objectForKey:@"lst_right_top_item"]intValue] != -1) {
		[self initRightSideLabel];
    	[self addSubview:rightSideLabel];
	}
    return self;
}

%new - (void)initRightSideLabel {
    rightSideLabel = [[UILabel alloc]initWithFrame:CGRectMake(294, 2.2, 66.6, 14)];
    rightSideLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    // self.rightSideLabel.adjustsFontSizeToFitWidth = YES;
	rightSideLabel.textColor = [UIColor whiteColor];
    rightSideLabel.textAlignment = NSTextAlignmentCenter;
	rightSideLabel.text = @"hoge MB";
}

%end
%end

//起動時の処理
%ctor {
	loadPreferences();

	// 設定で有効にしている時のみ動作
	if ([[preferences objectForKey:@"sw_enabled"]boolValue]) {
		%init(Main);
	}
}
