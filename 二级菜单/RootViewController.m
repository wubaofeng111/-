//
//  RootViewController.m
//  二级菜单
//
//  Created by friday on 16/8/23.
//  Copyright © 2016年 friday. All rights reserved.
//

#import "RootViewController.h"
#import "HTMLKit.h"
@interface RootViewController ()<NSOutlineViewDelegate,NSOutlineViewDataSource>
{
    
    __weak IBOutlet NSOutlineView *mOutLineView;
    HTMLElement *rootElement;
    HTMLParser *parser;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mOutLineView.delegate = self;
    mOutLineView.dataSource = self;
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"QQLogin" ofType:@"html"];
        unsigned long a = 4;
        NSStringEncoding *encod = &a;
    
    
    
    
        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:filePath usedEncoding:encod error:nil];
    
    
        parser = [[HTMLParser alloc]initWithString:htmlString];
        NSLog(@"%@",[parser parseErrors]);
        NSLog(@"%@",[parser parseDocument]);
        NSLog(@"%@",parser.document.rootElement.name);
    rootElement = parser.document.rootElement;
}

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item != nil) {
        HTMLElement *element = item;
        return  element.childNodesCount;
    }
    return 1;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item
{
    if (item != nil) {
        HTMLElement *element = item;
        return element.childNodes[index];
    }
    return rootElement;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (item!=nil) {
        HTMLElement *element = item;
        return element.childNodesCount > 0;
    }
    return YES;
}
- (nullable id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn byItem:(nullable id)item
{
    HTMLElement *element = item;
    
    if ([tableColumn.identifier isEqualToString:@"header"]) {
        return element.name;
    }
    if ([tableColumn.identifier isEqualToString:@"string"]) {
        return element.innerHTML;
    }
    return element.className;
}

@end
