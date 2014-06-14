/*

    ExampleWindow.m
	NSSpeechSynthesizerExample
	
	Copyright (c) 2003-2005 Apple Computer. All rights reserved.
*/

#import "OptionsSheet.h"

const NSUInteger kNumOfFixedMenuItemsInVoicePopup = 2;

@interface NSSpeechOptionsSheet (NSSpeechOptionsSheetPrivate)
- (void)_updateVoicesPopup;
@end

@implementation NSSpeechOptionsSheet

- (void)updateWithSettings:(NSMutableDictionary *)settings
{
	// Set up voices popup
	[self _updateVoicesPopup];
	[_voicePopupButton selectItemAtIndex:0];
	
	// Retain the passed in settings
	[_currentSettings release];
    _currentSettings = [settings retain];

	id valueObject = [_currentSettings objectForKey:NSSpeechRateProperty];
	if (valueObject) {
		[_rateSlider setFloatValue:[valueObject floatValue]];
	}
	else {
		[_rateSlider setEnabled:false];
	}
	
	valueObject = [_currentSettings objectForKey:NSSpeechVolumeProperty];
	if (valueObject) {
		[_volumeSlider setFloatValue:[valueObject floatValue]];
	}
	else {
		[_volumeSlider setEnabled:false];
	}
	
	valueObject = [_currentSettings objectForKey:NSSpeechPitchBaseProperty];
	if (valueObject) {
		[_pitchBaseSlider setFloatValue:[valueObject floatValue]];
	}
	else {
		[_pitchBaseSlider setEnabled:false];
	}
	
	valueObject = [_currentSettings objectForKey:NSSpeechPitchModProperty];
	if (valueObject) {
		[_pitchModSlider setFloatValue:[valueObject floatValue]];
	}
	else {
		[_pitchModSlider setEnabled:false];
	}

	valueObject = [_currentSettings objectForKey:NSSpeechInputModeProperty];
	if (valueObject) {
		[_phonemeModeCheckboxButton setIntValue:([valueObject isEqualToString:NSSpeechModePhoneme])?true:false];
	}
	else {
		[_phonemeModeCheckboxButton setEnabled:false];
	}
	
	valueObject = [_currentSettings objectForKey:NSSpeechCharacterModeProperty];
	if (valueObject) {
		[_charByCharCheckboxButton setIntValue:([valueObject isEqualToString:NSSpeechModeLiteral])?true:false];
	}
	else {
		[_charByCharCheckboxButton setEnabled:false];
	}
	
	valueObject = [_currentSettings objectForKey:NSSpeechNumberModeProperty];
	if (valueObject) {
		[_digitByDigitCheckboxButton setIntValue:([valueObject isEqualToString:NSSpeechModeLiteral])?true:false];
	}
	else {
		[_digitByDigitCheckboxButton setEnabled:false];
	}

	[_voicePopupButton selectItemAtIndex:0];
	valueObject = [_currentSettings objectForKey:@"NSSpeechVoice"];
	if (valueObject) {
		NSUInteger	foundIndex = [_voiceIdentifierList indexOfObjectIdenticalTo:valueObject];
		if (foundIndex != NSNotFound) {
			[_voicePopupButton selectItemAtIndex:foundIndex + kNumOfFixedMenuItemsInVoicePopup];
		}
	}

	valueObject = [_currentSettings objectForKey:@"NSSpeechBoundary"];
	if (valueObject) {
		[_immediatelyRadioButton setIntValue:([valueObject intValue] == NSSpeechImmediateBoundary)?true:false];
		[_afterWordRadioButton setIntValue:([valueObject intValue] == NSSpeechWordBoundary)?true:false];
		[_afterSentenceRadioButton setIntValue:([valueObject intValue] == NSSpeechSentenceBoundary)?true:false];
	}
	else {
		[_immediatelyRadioButton setEnabled:false];
		[_afterWordRadioButton setEnabled:false];
		[_afterSentenceRadioButton setEnabled:false];
	}
}

- (IBAction)saveSettingsButtonSelected:(id)sender
{

	if ([_rateSlider isEnabled]) {
		[_currentSettings setObject:[NSNumber numberWithFloat:[_rateSlider floatValue]] forKey:NSSpeechRateProperty];
	}
	
	if ([_volumeSlider isEnabled]) {
		[_currentSettings setObject:[NSNumber numberWithFloat:[_volumeSlider floatValue]] forKey:NSSpeechVolumeProperty];
	}
	
	if ([_pitchBaseSlider isEnabled]) {
		[_currentSettings setObject:[NSNumber numberWithFloat:[_pitchBaseSlider floatValue]] forKey:NSSpeechPitchBaseProperty];
	}
	
	if ([_pitchModSlider isEnabled]) {
		[_currentSettings setObject:[NSNumber numberWithFloat:[_pitchModSlider floatValue]] forKey:NSSpeechPitchModProperty];
	}
	
	if ([_phonemeModeCheckboxButton isEnabled]) {
		[_currentSettings setObject:([_phonemeModeCheckboxButton intValue])?NSSpeechModePhoneme:NSSpeechModeText forKey:NSSpeechInputModeProperty];
	}
	
	if ([_digitByDigitCheckboxButton isEnabled]) {
		[_currentSettings setObject:([_digitByDigitCheckboxButton intValue])?NSSpeechModeLiteral:NSSpeechModeNormal forKey:NSSpeechNumberModeProperty];
	}
	
	if ([_charByCharCheckboxButton isEnabled]) {
		[_currentSettings setObject:([_charByCharCheckboxButton intValue])?NSSpeechModeLiteral:NSSpeechModeNormal forKey:NSSpeechCharacterModeProperty];
	}

	if ([_voicePopupButton isEnabled]) {
		if ([_voicePopupButton indexOfSelectedItem] >= kNumOfFixedMenuItemsInVoicePopup) {
			id voiceIdentifier = [_voiceIdentifierList objectAtIndex:[_voicePopupButton indexOfSelectedItem] - kNumOfFixedMenuItemsInVoicePopup];
			if (voiceIdentifier) {
				[_currentSettings setObject:voiceIdentifier forKey:@"NSSpeechVoice"];
			}
		}
		else {
			[_currentSettings setObject:[NSSpeechSynthesizer defaultVoice] forKey:@"NSSpeechVoice"];
		}
	}

	if ([_immediatelyRadioButton isEnabled] && [_afterWordRadioButton isEnabled] && [_afterSentenceRadioButton isEnabled]) {
		
		if ([_immediatelyRadioButton intValue]) {
			[_currentSettings setObject:[NSNumber numberWithLong:NSSpeechImmediateBoundary] forKey:@"NSSpeechBoundary"];
		}
		else if ([_afterWordRadioButton intValue]) {
			[_currentSettings setObject:[NSNumber numberWithLong:NSSpeechWordBoundary] forKey:@"NSSpeechBoundary"];
		}
		else if ([_afterSentenceRadioButton intValue]) {
			[_currentSettings setObject:[NSNumber numberWithLong:NSSpeechSentenceBoundary] forKey:@"NSSpeechBoundary"];
		}
	}

	[NSApp endSheet:[self window] returnCode:kOptionsSaveReturnCode];
}

- (IBAction)cancelButtonSelected:(id)sender
{
	[NSApp endSheet:[self window] returnCode:kOptionsCancelReturnCode];
}

- (IBAction)useDefaultsButtonSelected:(id)sender
{
	[NSApp endSheet:[self window] returnCode:kOptionsResetReturnCode];
}

- (void)_updateVoicesPopup 
{
	[_voiceIdentifierList release];
	_voiceIdentifierList = [NSMutableArray new];

    // Delete any items in the voice menu
    while([_voicePopupButton numberOfItems] > kNumOfFixedMenuItemsInVoicePopup) {
        [_voicePopupButton removeItemAtIndex:[_voicePopupButton numberOfItems] - 1];
	}
    
	NSString * aVoice = NULL;
	NSEnumerator * voiceEnumerator = [[NSSpeechSynthesizer availableVoices] objectEnumerator];
	while(aVoice = [voiceEnumerator nextObject]) {
		[_voiceIdentifierList addObject:aVoice];
		[_voicePopupButton addItemWithTitle:[[NSSpeechSynthesizer attributesForVoice:aVoice] objectForKey:NSVoiceName]];
	}
}


@end


