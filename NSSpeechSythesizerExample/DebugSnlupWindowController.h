//
//  DebugSnlupWindowController.h
//  Rufus
//
//  Created by Karl Kittel on 11/3/14.
//  Copyright 2014 Countryside Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DebugSnlupWindowController : NSWindowController{
	NSTimer * timer;
	IBOutlet NSTextView *textView1;
	IBOutlet NSTextView *textView2;
	IBOutlet NSTextView *textView3;
	IBOutlet NSTextView *textView4;
	IBOutlet NSTextView *textView5;
    IBOutlet NSTextView *textView6;
	IBOutlet NSTextView *textView7;
}

@property (nonatomic, retain) NSTimer * timer;
@property (retain, nonatomic) NSTextView	*textView1;
@property (retain, nonatomic) NSTextView	*textView2;
@property (retain, nonatomic) NSTextView	*textView3;
@property (retain, nonatomic) NSTextView	*textView4;
@property (retain, nonatomic) NSTextView	*textView5;
@property (retain, nonatomic) NSTextView	*textView6;
@property (retain, nonatomic) NSTextView	*textView7;

- (void)writeToTextView1;
- (void)writeToTextView2;
- (void)writeToTextView3;
- (void)writeToTextView4;
- (void)writeToTextView5;
- (void)writeToTextView6;
- (void)writeToTextView7;
- (void)targetMethod: (NSTimer * ) theTimer;
- (void)startTimer;
- (NSString*)getDataPath;

@end
