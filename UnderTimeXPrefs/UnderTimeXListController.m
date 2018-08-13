#include "UnderTimeXListController.h"

@implementation UnderTimeXListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"UnderTimeXPrefs" target:self] retain];
	}

	return _specifiers;
}

@end
