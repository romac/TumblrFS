//
//    TumblrFS_Controller.m
//    TumblrFS
//
//    Created by Romac on 24.07.10.
//    Copyright 2010 kryzalid. All rights reserved.
//
#import "TumblrFS_Controller.h"
#import "TumblrFS_Filesystem.h"
#import <MacFUSE/MacFUSE.h>

@implementation TumblrFS_Controller

#pragma mark -
#pragma mark Custom methods

- ( void )mountVolumeAtPath: ( NSString * )mountPath forBlog: ( NSString * )blogName
{
    fileSystemDelegate = [ [ TumblrFS_Filesystem alloc ] init ];
    fileSystem         = [ [ GMUserFileSystem alloc ] initWithDelegate: fileSystemDelegate isThreadSafe: NO ];
    
    NSMutableArray * options        = [ NSMutableArray array ];
    NSString       * volumeIconPath = [ [ NSBundle mainBundle ] pathForResource: @"TumblrFS" ofType: @"icns" ];
    NSString       * volumeName     = [ NSString stringWithFormat: @"%@ tumblog", blogName ];
    NSString       * volumePath     = [ NSString stringWithFormat: @"%@/%@", mountPath, volumeName ];
    
    [ options addObject: [ NSString stringWithFormat: @"volicon=%@", volumeIconPath ] ];
    [ options addObject: [ NSString stringWithFormat: @"volname=%@", volumeName ] ];
    [ options addObject: @"rdonly" ];
    
    [ fileSystemDelegate setBlogName: blogName ];
    [ fileSystem mountAtPath: volumePath withOptions: options ];
}

#pragma mark -
#pragma mark IBActions

- ( IBAction )mountButtonClicked: ( id )sender
{
    [ self mountVolumeAtPath: @"/Volumes" forBlog: [ blogNameField stringValue ] ];
    [ spin startAnimation: self ];
}

#pragma mark -
#pragma mark MacFUSE Callbacks

- ( void )mountFailed: ( NSNotification * )notification
{
    NSDictionary * userInfo = [ notification userInfo ];
    NSError      * error    = [ userInfo objectForKey: kGMUserFileSystemErrorKey ];
    
    NSLog( @"kGMUserFileSystem Error: %@, userInfo=%@", error, [ error userInfo ] );
    
    NSRunAlertPanel( @"Mount Failed", [ error localizedDescription ], nil, nil, nil );
    
    [ [ NSApplication sharedApplication ] terminate: nil ];
}

- ( void )didMount: ( NSNotification * )notification
{
    NSDictionary * userInfo   = [ notification userInfo ];
    NSString     * mountPath  = [ userInfo objectForKey: kGMUserFileSystemMountPathKey ];
    NSString     * parentPath = [ mountPath stringByDeletingLastPathComponent ];
    
    [ [ NSWorkspace sharedWorkspace ] selectFile: mountPath inFileViewerRootedAtPath: parentPath ];
    
    // [ window close ];
}

- ( void )didUnmount: ( NSNotification * )notification
{
    [ [ NSApplication sharedApplication ] terminate: nil ];
}

#pragma mark -
#pragma mark NSApplication Callbacks

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    NSNotificationCenter * center = [ NSNotificationCenter defaultCenter ];
    
    [ center addObserver: self selector: @selector( mountFailed: )
                                   name: kGMUserFileSystemMountFailed
                                 object: nil ];
    
    [ center addObserver: self selector: @selector( didMount: )
                                   name: kGMUserFileSystemDidMount
                                 object: nil ];
    
    [ center addObserver: self selector: @selector( didUnmount: )
                                   name: kGMUserFileSystemDidUnmount
                                 object: nil ];
}

- ( NSApplicationTerminateReply )applicationShouldTerminate: ( NSApplication * )sender
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
    
    [ fileSystem unmount ];
    [ fileSystem release ];
    [ fileSystemDelegate release ];
    
    return NSTerminateNow;
}

@end
