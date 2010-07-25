//
//  TumblrFS_Controller.h
//  TumblrFS
//
//  Created by Romac on 24.07.10.
//  Copyright 2010 kryzalid. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GMUserFileSystem;
@class TumblrFS_Filesystem;

@interface TumblrFS_Controller : NSObject
{
	GMUserFileSystem    * fileSystem;
	TumblrFS_Filesystem * fileSystemDelegate;
}

- ( void )mountVolumeAtPath: ( NSString * )mountPath withName: ( NSString * )volumeName;

@end
