/*

	OptionsSheet.h
	NSSpeechSynthesizerExample
	
	Copyright (c) 2003-2007 Apple Computer. All rights reserved.
*/


enum {
	kOptionsResetReturnCode = -1,
	kOptionsCancelReturnCode = 0,
	kOptionsSaveReturnCode = 1
};

#import <Cocoa/Cocoa.h>

@interface NSSpeechOptionsSheet : NSWindowController {

    IBOutlet NSPopUpButton *	_voicePopupButton;
    IBOutlet NSSlider *			_rateSlider;
    IBOutlet NSSlider *			_volumeSlider;
    IBOutlet NSSlider *			_pitchBaseSlider;
    IBOutlet NSSlider *			_pitchModSlider;
    IBOutlet NSButtonCell *		_immediatelyRadioButton;
    IBOutlet NSButtonCell *		_afterWordRadioButton;
    IBOutlet NSButtonCell *		_afterSentenceRadioButton;
    IBOutlet NSButton *			_charByCharCheckboxButton;
    IBOutlet NSButton *			_digitByDigitCheckboxButton;
    IBOutlet NSButton *			_phonemeModeCheckboxButton;
    
    NSMutableDictionary *		_currentSettings;
	NSMutableArray *			_voiceIdentifierList;
}

- (void)updateWithSettings:(NSMutableDictionary *)settings;

- (IBAction)saveSettingsButtonSelected:(id)sender;
- (IBAction)cancelButtonSelected:(id)sender;
- (IBAction)useDefaultsButtonSelected:(id)sender;

@end

