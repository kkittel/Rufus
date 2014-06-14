/*

	ExampleWindow.h
	NSSpeechSynthesizerExample
	
	Copyright (c) 2003-2007 Apple Computer. All rights reserved.
*/

#import <Cocoa/Cocoa.h>
#import "OptionsSheet.h"
#import "SpeakingCharacterView.h"
#import "newPhraseWindowController.h"

@interface NSSpeechExampleWindow : NSWindowController <NSSpeechSynthesizerDelegate> {

    IBOutlet NSButton *				_startOrStopSpeakingButton;
    IBOutlet NSButton *				_pauseOrContinueSpeakingButton;
    IBOutlet NSButton *				_submitButton;
    IBOutlet NSButton *				_recordPermButton;
	IBOutlet NSButton *				_clrContextButton;
	IBOutlet NSButton *				_NewPhraseButton;
    
	IBOutlet NSTextView *			_textToSpeechExampleTextView;
    IBOutlet NSTextView *			_synthesizerLogTextView;
    IBOutlet NSSplitView *			_textAndLogSplitView;

    IBOutlet NSSpeechOptionsSheet *	_optionsSheet;
    IBOutlet SpeakingCharacterView *_characterView;
	
    NSSpeechBoundary				_currentStopPauseBoundary;
    NSUInteger						_offsetToSpokenText;
    NSRange							_orgSelectionRange;
    NSSpeechSynthesizer *			_synthesizer;
    NSMutableString *				_currentMutableLogString;
	NSString *						final;
	newPhraseWindowController *		winController;
	IBOutlet NSMenuItem	*			closeMenuItem;
}

@property (retain, nonatomic) NSString						*final;
@property (nonatomic, retain) newPhraseWindowController		*winController;
@property (nonatomic, retain) IBOutlet NSMenuItem			*closeMenuItem;

- (IBAction)startOrStopSpeaking:(id)sender;
- (IBAction)pauseOrContinueSpeaking:(id)sender;
- (IBAction)showOptions:(id)sender;
//- (IBAction)saveToFile:(id)sender;
//- (IBAction)savePhonemesToFile:(id)sender;
//- (IBAction)addDictionary:(id)sender;
- (IBAction)clearSynthesizerLog:(id)sender;
- (IBAction)questionDidChange:(id)sender;
- (IBAction)recordPermFact:(id)sender;
- (IBAction)clearContext:(id)sender;
- (IBAction)newPhraseWindow:(id)sender;
- (IBAction)callTextEdit:(id)sender;

@end

