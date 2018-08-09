#import <mach/mach.h>
#import "./Headers/_UIStatusBarStringView.h"
#import "./Headers/_UIStatusBarTimeItem.h"
#import "./Headers/_UIStatusBarBackgroundActivityView.h"

static NSString *displayTime = @"";
static NSTimer *timer;

static NSNumber *getFreeMemory() {
  @autoreleasepool {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;

    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
      NSLog(@"FreeRAMUnderTimeX: Failed to fetch vm statistics");
	  return @-1;
	}

    natural_t mem_free = (vm_stat.free_count + vm_stat.inactive_count) * pagesize;

    NSNumber *freeMemory = [NSNumber numberWithUnsignedInt:round((mem_free / 1024) / 1024)];

    return freeMemory;
  }
}

%hook _UIStatusBarStringView

- (id)initWithFrame:(CGRect)arg1 {
	id orig = %orig;
	timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(interval:) userInfo:nil repeats:YES];
	return orig;
}

%new - (void)interval:(NSTimer *)timer {
    [self setText:displayTime];
}

- (void)setText:(NSString *)text {
	displayTime = [NSString stringWithString:text];
	if([text containsString:@":"]) {
		text = [NSString stringWithFormat:@"%@\n%@ MB", text, getFreeMemory()];
		self.numberOfLines = 2;
		self.textAlignment = 1;
		[self setFont: [self.font fontWithSize:12]];
	}

	return %orig(text);
}

%end

%hook _UIStatusBarTimeItem

- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2 {
	id orig = %orig;
	[self.shortTimeView setFont: [self.shortTimeView.font fontWithSize:12]];
	[self.pillTimeView setFont: [self.pillTimeView.font fontWithSize:12]];
	return orig;
}

%end

%hook _UIStatusBarBackgroundActivityView

- (void)setCenter:(CGPoint)point {
	point.y = 11;
	self.frame = CGRectMake(0, 0, self.frame.size.width, 31);
	self.pulseLayer.frame = CGRectMake(0, 0, self.frame.size.width, 31);
	%orig(point);
}

%end
