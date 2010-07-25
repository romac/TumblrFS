//
//  TumblrFS_Filesystem.m
//  TumblrFS
//
//  Created by Romac on 24.07.10.
//  Copyright 2010 kryzalid. All rights reserved.
//
#import <sys/xattr.h>
#import <sys/stat.h>
#import "NSError+POSIX.h"
#import "TumblrFS_Filesystem.h"
#import <MacFUSE/MacFUSE.h>

// NOTE: It is fine to remove the below sections that are marked as 'Optional'.

// The core set of file system operations. This class will serve as the delegate
// for GMUserFileSystemFilesystem. For more details, see the section on 
// GMUserFileSystemOperations found in the documentation at:
// http://macfuse.googlecode.com/svn/trunk/core/sdk-objc/Documentation/index.html

@implementation TumblrFS_Filesystem

#pragma mark -
#pragma mark Filesystem Lifecycle

- ( void )willMount
{
	
}

- ( void )willUnmount
{
	
}


#pragma mark -
#pragma mark Directory Contents

- ( NSArray * )contentsOfDirectoryAtPath: ( NSString * )path error: ( NSError ** )error
{
	return nil;
}

#pragma mark -
#pragma mark Getting Attributes

- ( NSDictionary * )attributesOfItemAtPath: ( NSString * )path
                                  userData: ( id )userData
                                     error: ( NSError ** )error
{
	return nil;
}

- ( NSDictionary * )attributesOfFileSystemForPath: ( NSString * )path
                                            error: ( NSError ** )error
{
	// Default file system attributes.
    return [ NSDictionary dictionary ];
}

#pragma mark -
#pragma mark File Contents

- ( NSData * )contentsAtPath: ( NSString * )path
{
	return nil;
}


@end
