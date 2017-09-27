//
//  FontsViewController.m
//  FontsDemo
//
//  Created by leihui on 16/12/29.
//  Copyright © 2016年 ND WebSoft Inc. All rights reserved.
//

#import "FontsViewController.h"
#import <CoreText/CoreText.h>

#define kCellRowHeight				(50.0f*iPhoneWidthScaleFactor)

@interface FontsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dateArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL bSystemFont;

@end

@implementation FontsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (SYSTEM_VERSION >= 7.0) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			[self setEdgesForExtendedLayout:UIRectEdgeNone];
		}
	}
	
	self.title = @"System Fonts";
	self.view.backgroundColor = [UIColor whiteColor];
	
	_bSystemFont = YES;
	[self loadSystemFonts];
	[self createNavagationItem];
	[self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)loadSystemFonts
{
	NSMutableArray *array = [NSMutableArray array];
	
	NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
	NSArray *fontNames;
	NSInteger indFamily, indFont;
	for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
	{
		//NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
		NSLog(@"字体族: %@", [familyNames objectAtIndex:indFamily]);
		fontNames = [[NSArray alloc] initWithArray:
					 [UIFont fontNamesForFamilyName:
					  [familyNames objectAtIndex:indFamily]]];
		for (indFont=0; indFont<[fontNames count]; ++indFont)
		{
			//NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
			NSLog(@"    字体名称: %@", [fontNames objectAtIndex:indFont]);
			
			[array addObject:[fontNames objectAtIndex:indFont]];
		}
	}
	
	self.dateArray = array;
}

- (void)dynamicLoadFonts
{
	NSMutableArray *array = [NSMutableArray array];
	
	NSString *path = nil;
	NSString *fontsPath = [NSString stringWithFormat:@"%@/Resource/Fonts", [[NSBundle mainBundle] resourcePath]];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:fontsPath];
	while ((path = [enumerator nextObject]) != nil) {
		NSLog(@"path:%@", path);
		
		NSString *fontPath = [fontsPath stringByAppendingPathComponent:path];
		NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
		if (fontData) {
			CFErrorRef error;
			CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)fontData);
			CGFontRef font = CGFontCreateWithDataProvider(providerRef);
			if (CTFontManagerRegisterGraphicsFont(font, &error)) {
				NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(font));
				if (fontName) {
					[array addObject:fontName];
				}
			}
			else {
				CFStringRef errorDesc = CFErrorCopyDescription(error);
				NSLog(@"Failed to load font: %@", errorDesc);
				CFRelease(errorDesc);
			}
			CFRelease(font);
			CFRelease(providerRef);
		}
	}
	
	self.dateArray = array;
}

- (void)dymanicUnloadFonts
{
	NSString *path = nil;
	NSString *fontsPath = [NSString stringWithFormat:@"%@/Resource/Fonts", [[NSBundle mainBundle] resourcePath]];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:fontsPath];
	while ((path = [enumerator nextObject]) != nil) {
		NSLog(@"path:%@", path);
		
		NSString *fontPath = [fontsPath stringByAppendingPathComponent:path];
		NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
		if (fontData) {
			CFErrorRef error;
			CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)fontData);
			CGFontRef font = CGFontCreateWithDataProvider(providerRef);
			if (CTFontManagerUnregisterGraphicsFont(font, &error)) {
				NSLog(@"Unregister font successful!");
			}
			else {
				CFStringRef errorDesc = CFErrorCopyDescription(error);
				NSLog(@"Failed to load font: %@", errorDesc);
				CFRelease(errorDesc);
			}
			CFRelease(font);
			CFRelease(providerRef);
		}
	}
}

- (void)createNavagationItem
{
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createTableView
{
	CGRect tableViewFrame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, kAppView_Height);
	
	self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.showsHorizontalScrollIndicator = NO;
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_tableView];
}

#pragma mark - Actions

- (void)rightAction:(id)sender
{
	_bSystemFont = !_bSystemFont;
	if (_bSystemFont) {
		self.title = @"System Fonts";
		[self dymanicUnloadFonts];
		[self loadSystemFonts];
	}
	else {
		self.title = @"Local Fonts";
		[self dynamicLoadFonts];
	}
	[_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_dateArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellIdentifier";
	
	NSInteger row = indexPath.row;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		// Separator
		UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.f, kCellRowHeight-1.f, SCREEN_WIDTH, 1.f)];
		separator.backgroundColor = RGB(227, 227, 227);
		[cell.contentView addSubview:separator];
	}
	
	if (row < [_dateArray count]) {
		NSString *title = _dateArray[row];
		cell.textLabel.text = title;
		
		UIFont *font = [UIFont fontWithName:title size:14.f*iPhoneWidthScaleFactor];
		if (font) {
			cell.textLabel.font = font;
		}
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellRowHeight;
}

@end
