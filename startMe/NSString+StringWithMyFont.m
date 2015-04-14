//
//  NSString+StringWithMyFont.m
//  startMe
//
//  Created by sheng rong on 4/10/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "NSString+StringWithMyFont.h"

@implementation NSString (StringWithMyFont)

-(CGSize)sizeWithMyFont:(UIFont *)fontToUse
{
    if([self respondsToSelector:@selector(sizeWithAttributes:)]){
        NSDictionary *attributes = @{NSFontAttributeName: fontToUse};
        return [self sizeWithAttributes:attributes];
    }
    return [self sizeWithMyFont:fontToUse];
}

-(CGSize)sizeWithMyFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        NSDictionary *attributes = @{NSFontAttributeName: font};
        return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    return [self sizeWithMyFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
}
@end
