//
//  AppDelegate.m
//  二级菜单
//
//  Created by friday on 16/8/23.
//  Copyright © 2016年 friday. All rights reserved.
//

#import "AppDelegate.h"
#import "HTMLKit.h"
#import "Staff.h"
#import "isExpand.h"
#import "XMLDictionary.h"
#import "XMLKit.h"
#import <QuickLook/QuickLook.h>
#import <CoreImage/CoreImage.h>



@interface NSFileShowFine : NSObject
@property(nonatomic,retain)NSString *name;
@property(nonatomic,assign)BOOL      hasSubFiles;
@property(nonatomic,assign)BOOL      isDirectory;
@property(nonatomic,retain)NSString *filePath;
@property(nonatomic,retain)NSArray<NSFileShowFine*>  *subFiles;
-(id)initWithHomePath:(NSString*)aPath;
@end

@implementation NSFileShowFine

-(id)initWithHomePath:(NSString *)aPath
{
    if(self = [super init])
    {
        _filePath = aPath;
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        NSString *lastComment = [aPath lastPathComponent];
        _name = lastComment;
        if ([defaultManager fileExistsAtPath:aPath isDirectory:&isDirectory]) {
            _isDirectory = isDirectory;
            
            if (isDirectory) {
                NSArray *subDire = [defaultManager contentsOfDirectoryAtPath:aPath error:nil];
                if(subDire.count>0)
                {
                    _hasSubFiles = YES;
                }else{
                    _hasSubFiles = NO;
                }
                NSMutableArray *array = [NSMutableArray array];
               

                [subDire enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSFileShowFine *fileFine = [[NSFileShowFine alloc]initWithHomePath:[aPath stringByAppendingPathComponent:obj]];
                    [array addObject:fileFine];
                }];
                self.subFiles = array;
                NSLog(@"<-------------------------->");
                NSLog(@"%@,%@",lastComment,array);
                NSLog(@"<-------------------------->");
                array = nil;
              
                
            }else{
                _hasSubFiles = NO;
                _name        = lastComment;
            }
        }
        
    }
    return self;
}

@end
#import "RootViewController.h"

@interface AppDelegate ()<NSOutlineViewDataSource,NSOutlineViewDelegate,NSTableViewDataSource,NSTabViewDelegate>
{
    
    __weak IBOutlet NSView *mView;
    
    __weak IBOutlet NSImageView *mImageView;
    NSMutableArray *company;
    __weak IBOutlet NSOutlineView *mOutlineView;
    HTMLParser *aParser ;
    HTMLElement   *rootElement;
    HTMLElement   *expandElement;
    NSArray *files;
    NSFileShowFine *mFileFines;
    NSFileShowFine *mOpenFines;
    __weak IBOutlet NSPopUpButton *mButton;
    
    
    __weak IBOutlet NSComboBox *mComBox;
}
@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    self.window.contentViewController = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
    
    mOutlineView.delegate = self;
    mOutlineView.dataSource = self;
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"File" ofType:@"html"];
//    unsigned long a = 4;
//    NSStringEncoding *encod = &a;
//
//    NSString *xmlString = [[NSString alloc]initWithContentsOfFile:filePath usedEncoding:encod error:nil];
//    XMLElement *ele = [XMLKit parseXMLString:xmlString];
//    NSArray *array = [ele findElements:@"text"];
//       [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString*string = [(XMLElement*)obj text];
//        NSLog(@"%@",[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//    }];
//    
//    
//    
//    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:filePath usedEncoding:encod error:nil];
//    
//
//    aParser = [[HTMLParser alloc]initWithString:htmlString];
//    NSLog(@"%@",[aParser parseErrors]);
//    NSLog(@"%@",[aParser parseDocument]);
//    NSLog(@"%@",aParser.document.rootElement.name);
//    rootElement = aParser.document.rootElement;
//    expandElement = rootElement;
//    
    [[[NSThread alloc]initWithTarget:self selector:@selector(loadFilePath) object:nil]start];
//    
//    
//    [mOutlineView reloadData];
}
-(void)reloadData
{
    [mOutlineView reloadData];
}
-(void)loadFilePath
{
    NSString *homePath = @"/Users/friday/Desktop/百联文档";
    
    NSFileShowFine *fileShowFine = [[NSFileShowFine alloc ]initWithHomePath:homePath];
    mFileFines = fileShowFine;
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}
-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(NSFileShowFine*)item
{
    if(item!=nil)
    {
       
        
            return   item.subFiles.count;
        
    }
    return   1;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item
{
    if (item != nil) {
        
        return [(NSFileShowFine*)item subFiles][index];
    }
    return mFileFines;
    
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (!item) {
        return NO;
    }
    return [(NSFileShowFine*)item hasSubFiles];
}


//
-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [(NSFileShowFine*)item name];
}

-(void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSFileShowFine *show = [mOutlineView itemAtRow:mOutlineView.selectedRow];
    NSURL *url = [NSURL fileURLWithPath:show.filePath];
    CGSize size = [mView frame].size;
    if ([show.name hasSuffix:@".PNG"]||[show.name hasSuffix:@".png"]) {
        
        
        NSImage * myImage  = [[NSImage alloc]initWithContentsOfFile:show.filePath];
        
        mImageView.image = myImage;
    }
}


- (CGImageRef)nsImageToCGImageRef:(NSImage*)image;
{
    NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef;
    if(imageData)
    {
        CGImageSourceRef imageSource =
        CGImageSourceCreateWithData(
                                    (CFDataRef)imageData,  NULL);
        
        imageRef = CGImageSourceCreateImageAtIndex(
                                                   imageSource, 0, NULL);
    }
    
    
    return imageRef;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
