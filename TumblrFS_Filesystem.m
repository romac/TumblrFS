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

// The core set of file system operations. This class will serve as the delegate
// for GMUserFileSystemFilesystem. For more details, see the section on 
// GMUserFileSystemOperations found in the documentation at:
// http://macfuse.googlecode.com/svn/trunk/core/sdk-objc/Documentation/index.html

@implementation TumblrFS_Filesystem

@synthesize files, blogName;

#pragma mark -
#pragma mark File system Lifecycle

- ( void )willMount
{
    NSString * urlString = [ NSString stringWithFormat: @"http://projects.dev/TumblrFS/files.php?blog=%@", blogName ];
    NSURL    * url       = [ NSURL URLWithString: urlString ];
    
    self.files           = [ NSArray arrayWithContentsOfURL: url ];
}

#pragma mark -
#pragma mark Directory Contents

- ( NSArray * )contentsOfDirectoryAtPath: ( NSString * )path error: ( NSError ** )error
{
    NSMutableArray * keys = [ [ NSMutableArray alloc ] init ];
    
    for( NSUInteger i = 0; i < [ files count ]; i++ )
    {
        [ keys addObject: [ [ files objectAtIndex: i ] objectForKey: @"File Name" ] ];
    }
    
    return keys;
}

#pragma mark -
#pragma mark Getting Attributes

- ( NSDictionary * )attributesOfItemAtPath: ( NSString * )path
                                  userData: ( id )userData
                                     error: ( NSError ** )error
{
    return [ NSDictionary dictionary ];
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
    // return [ path dataUsingEncoding: NSASCIIStringEncoding ];
    
    NSCharacterSet  * toTrim   = [ NSCharacterSet characterSetWithCharactersInString: @"/" ];
    NSString        * key      = [ path stringByTrimmingCharactersInSet: toTrim ];
    NSDictionary    * fileDesc = NULL;
    
    for( NSUInteger i = 0; i < [ files count ]; i++ )
    {
        NSDictionary * file = [ files objectAtIndex: i ];
        
       if( [ [ file objectForKey: @"File Name" ] isEqualToString: key ] )
       {
           fileDesc = file;
          
          break;
       }
    }
    
    if( !fileDesc )
    {
        return nil;
    }
    
    NSString * type = [ fileDesc objectForKey: @"Type" ];
    
    if( [ type isEqualToString: @"Quote" ] )
    {
        return [ [ fileDesc objectForKey: @"Text" ] dataUsingEncoding: NSUnicodeStringEncoding ];
    }
    
    if( [ type isEqualToString: @"Photo" ] )
    {
       // TODO: Uncomment next line and cache results.
       // return [ NSData dataWithContentsOfURL: [ NSURL URLWithString: [ fileDesc objectForKey: @"URL" ] ] ];
    }
    
    return nil;
}


@end
