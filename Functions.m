#import "Functions.h"
#import <mach/mach.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <net/if.h>

@interface Functions()
@end

@implementation Functions

+ (NSNumber *)getFreeMemory {
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

+ (NSString *)getTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"HHmm" options:0 locale:[NSLocale currentLocale]]];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"Md" options:0 locale:[NSLocale currentLocale]]];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getDayOfTheWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale currentLocale]]];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getDateAndDayOfTheWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MdEEEEE" options:0 locale:[NSLocale currentLocale]]];
    return [dateFormatter stringFromDate:[NSDate date]];
}

// + (long)getBytesTotal {
// 	@autoreleasepool {
// 		uint32_t iBytes = 0;
// 		uint32_t oBytes = 0;
// 		struct ifaddrs *ifa_list = NULL, *ifa;
// 		if ((getifaddrs(&ifa_list) < 0) || !ifa_list || ifa_list==0) {
// 			return 0;
// 		}
// 		for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
// 			if (ifa->ifa_addr == NULL) {
// 				continue;
// 			}
// 			if (AF_LINK != ifa->ifa_addr->sa_family) {
// 				continue;
// 			}
// 			if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
// 				continue;
// 			}
// 			if (ifa->ifa_data == NULL || ifa->ifa_data == 0) {
// 				continue;
// 			}
// 			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
// 			iBytes += if_data->ifi_ibytes;
// 			oBytes += if_data->ifi_obytes;
// 		}
// 		if(ifa_list) {
// 			freeifaddrs(ifa_list);
// 		}

//         return iBytes + oBytes;
//     }
// }

// + (NSString *)getSpeed {

//     @autoreleasepool {
//         long nowData = [self getBytesTotal];
//         if(!oldSpeed) {
// 			oldSpeed = nowData;
// 		}

// 		if(nowData<=0) {
// 			return @"";
// 		}

// 		long speed = nowData - oldSpeed;
// 		oldSpeed = nowData;

//         if(speed < 1024) {
// 			return [NSString stringWithFormat:@"%ldB/s", speed];
// 		}

//         if(speed >= 1024 && speed < 1024 * 1024) {
// 			return [NSString stringWithFormat:@"%.1fK/s", (double)speed / 1024];
// 		} 

//         if(speed >= 1024 * 1024 && speed < 1024 * 1024 * 1024) {
// 			return [NSString stringWithFormat:@"%.2fM/s", (double)speed / (1024 * 1024)];
// 		}

// 		return [NSString stringWithFormat:@"%.3fG/s", (double)speed / (1024 * 1024 * 1024)];
// 	}
// }

@end
