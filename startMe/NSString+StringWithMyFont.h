//
//  NSString+StringWithMyFont.h
//  startMe
//
//  Created by sheng rong on 4/10/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringWithMyFont)
-(CGSize)sizeWithMyFont:(UIFont *)fontToUse;
-(CGSize)sizeWithMyFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
