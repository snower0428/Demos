//
//  DataRequestDefines.h
//  DIYCollage
//
//  Created by leihui on 17/3/21.
//  Copyright © 2017年 Felink. All rights reserved.
//

#ifndef DataRequestDefines_h
#define DataRequestDefines_h

typedef NS_ENUM(NSInteger, TypeId) {
	TypeIdCollage		= 80007,
	TypeIdBackground	= 80008,
};

#define	kBaseUrl			@"http://pandahome.sj.91launcher.com"
#define kThemeActionUrl		kBaseUrl"/action.ashx/themeaction/"

#define kGlobalParamUrl		@"http://pandahome.ifjing.com/appstore/getdata.aspx?"

#endif /* DataRequestDefines_h */
