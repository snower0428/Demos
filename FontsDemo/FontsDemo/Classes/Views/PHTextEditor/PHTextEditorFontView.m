//
//  PHTextEditorFontView.m
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import "PHTextEditorFontView.h"

#define kCellRowHeight				44.f
#define kTextLabelTag				1612291400

@interface PHTextEditorFontView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PHTextEditorFontView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		self.dateArray = [NSMutableArray array];
		
		[self loadSystemFonts];
		[self createTableView];
	}
	
	return self;
}

#pragma mark - Private

- (void)loadSystemFonts
{
	NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
	NSArray *fontNames;
	NSInteger indFamily, indFont;
	for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
	{
		NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
		fontNames = [[NSArray alloc] initWithArray:
					 [UIFont fontNamesForFamilyName:
					  [familyNames objectAtIndex:indFamily]]];
		for (indFont=0; indFont<[fontNames count]; ++indFont)
		{
			NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
			
			[_dateArray addObject:[fontNames objectAtIndex:indFont]];
		}
	}
}

- (void)createTableView
{
	self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.showsHorizontalScrollIndicator = NO;
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self addSubview:_tableView];
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIFont *font = [UIFont systemFontOfSize:14.f*iPhoneWidthScaleFactor];
		UIColor *color = [UIColor whiteColor];
		CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, kCellRowHeight);
		
		UILabel *lbText = [UILabel labelWithName:@"" font:font frame:frame color:color alignment:NSTextAlignmentCenter];
		lbText.tag = kTextLabelTag;
		[cell.contentView addSubview:lbText];
#if 0
		// Separator
		UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.f, kCellRowHeight-1.f, SCREEN_WIDTH, 1.f)];
		separator.backgroundColor = RGB(227, 227, 227);
		[cell.contentView addSubview:separator];
#endif
	}
	
	if (row < [_dateArray count]) {
		NSString *fontName = _dateArray[row];
		
		UILabel *lbText = (UILabel *)[cell.contentView viewWithTag:kTextLabelTag];
		if (lbText) {
			UIFont *font = [UIFont fontWithName:fontName size:14.f*iPhoneWidthScaleFactor];
			if (font) {
				lbText.font = font;
				lbText.text = fontName;
			}
		}
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger row = indexPath.row;
	
	if (row < [_dateArray count]) {
		NSString *fontName = _dateArray[row];
		
		if (_delegate && [_delegate respondsToSelector:@selector(didSelectedFont:)]) {
			[_delegate didSelectedFont:fontName];
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellRowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView.backgroundColor = [UIColor clearColor];
}

@end
