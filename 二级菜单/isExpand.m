//
//  isExpand.m
//  二级菜单
//
//  Created by friday on 16/8/23.
//  Copyright © 2016年 friday. All rights reserved.
//

#import "isExpand.h"
#import <objc/runtime.h>

void *isExpandKey = "isExpand";
@implementation HTMLNode( isExpand)
-(void)setIsExpand:(BOOL)isExpand
{
    objc_setAssociatedObject(self, isExpandKey, @(isExpand), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isExpand
{
    return [objc_getAssociatedObject(self, isExpandKey) boolValue];
}
@end
