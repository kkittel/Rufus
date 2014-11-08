//
//  DebugSnlupWindowController.m
//  Rufus
//
//  Created by Karl Kittel on 11/3/14.
//  Copyright 2014 Countryside Software. All rights reserved.
//

#import "DebugSnlupWindowController.h"

@interface DebugSnlupWindowController ()

@end

@implementation DebugSnlupWindowController

@synthesize timer;
@synthesize textView1;
@synthesize textView2;
@synthesize textView3;
@synthesize textView4;
@synthesize textView5;
@synthesize textView6;
@synthesize textView7;

- (NSString*)getDataPath
{
    // Get Documents directory filepath and setup the datapath
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0];
    dataPath = [dataPath stringByAppendingString:@"/Rufus/Data"];
    //NSLog(@"dataPath: %@", dataPath);
    
    return dataPath;
    
}

- (void)startTimer
{
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(targetMethod:) userInfo:nil repeats: YES];
}

-(void) targetMethod: (NSTimer * ) theTimer
{
	[self writeToTextView1];
	[self writeToTextView2];
	[self writeToTextView3];
	[self writeToTextView4];
	[self writeToTextView5];
    [self writeToTextView6];
	[self writeToTextView7];
}

- (void)writeToTextView1
{
	NSError **error;
    NSString *fileName = [[self getDataPath] stringByAppendingString:@"/group.grp"];
	NSString *content = [NSString stringWithContentsOfFile:fileName
												  encoding:NSUTF8StringEncoding	error:error];
	//NSLog(@"@", content);
	[textView1 setString:content];
}

- (void)writeToTextView2
{
	NSError **error;
    NSString *fileName = [[self getDataPath] stringByAppendingString:@"/curphrase.txt"];
	NSString *content = [NSString stringWithContentsOfFile:fileName
												  encoding:NSUTF8StringEncoding	error:error];
	//NSLog(@"@", content);
	[textView2 setString:content];
}

- (void)writeToTextView3
{
	NSError **error;
    NSString *fileName = [[self getDataPath] stringByAppendingString:@"/group2.grp"];
	NSString *content = [NSString stringWithContentsOfFile:fileName
												  encoding:NSUTF8StringEncoding	error:error];
	//NSLog(@"@", content);
	[textView3 setString:content];
}

- (void)writeToTextView4
{
	NSError **error;
    NSString *fileName = [[self getDataPath] stringByAppendingString:@"/temp.grp"];
	NSString *content = [NSString stringWithContentsOfFile:fileName
												  encoding:NSUTF8StringEncoding	error:error];
	//NSLog(@"@", content);
	[textView4 setString:content];
}

- (void)writeToTextView5
{
	NSError **error;
    NSString *fileName = [[self getDataPath] stringByAppendingString:@"/think.tmp"];
	NSString *content = [NSString stringWithContentsOfFile:fileName
												  encoding:NSUTF8StringEncoding	error:error];
	//NSLog(@"@", content);
	[textView5 setString:content];
}

- (void)writeToTextView6
{
	NSError **error;
    NSString *fileName = [[self getDataPath] stringByAppendingString:@"/oldobjects.txt"];
	NSString *content = [NSString stringWithContentsOfFile:fileName
												  encoding:NSUTF8StringEncoding	error:error];
	//NSLog(@"@", content);
	[textView6 setString:content];
}

- (void)writeToTextView7
{
	NSError **error;
    NSString *fileName = [[self getDataPath] stringByAppendingString:@"/facts.per"];
	NSString *content = [NSString stringWithContentsOfFile:fileName
												  encoding:NSUTF8StringEncoding	error:error];
	//NSLog(@"@", content);
	[textView7 setString:content];
}

- (id)init
{
    self=[super initWithWindowNibName:@"DebugSnlupWindowController"];
    if(self)
    {
		// Do init here
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
	[self startTimer];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
