/*

	ExampleWindow.m
	NSSpeechSynthesizerExample
	
	Copyright (c) 2003-2005 Apple Computer. All rights reserved.
*/

#import "ExampleWindow.h"
#import "snlup.h"
#import "globals.h"
#import "io.h"
#import "hypothesis.h"
#import "newPhraseWindowController.h"
#import "DebugSnlupWindowController.h"

@interface NSSpeechExampleWindow (NSSpeechExampleWindowPrivate)
- (void)_appendLogString:(NSString *)string;
- (void)_startSpeakingTextViewToURL:(NSURL *)url;
@end


@implementation NSSpeechExampleWindow

@synthesize final;
@synthesize winController;
@synthesize closeMenuItem;
@synthesize debugController;

#pragma mark Public Methods
- (void)awakeFromNib
{
	_synthesizer 	= [NSSpeechSynthesizer new];
	[_synthesizer setDelegate:self];
	[_characterView setExpression:kCharacterExpressionIdentifierIdle];
	[_pauseOrContinueSpeakingButton setEnabled:false];
	_currentStopPauseBoundary = NSSpeechImmediateBoundary;
	_currentMutableLogString = [NSMutableString new];

	[_textAndLogSplitView setPosition:[_textAndLogSplitView frame].size.height/2 ofDividerAtIndex:0];
	[self _startSpeakingTextViewToURL:NULL];
}

- (IBAction)startOrStopSpeaking:(id)sender
{
    [self _startSpeakingTextViewToURL:NULL];
}

- (IBAction)pauseOrContinueSpeaking:(id)sender
{
	if ([[[_synthesizer objectForProperty:NSSpeechStatusProperty error:NULL] objectForKey:NSSpeechStatusOutputPaused] integerValue]) {
		[_synthesizer continueSpeaking];
		[_pauseOrContinueSpeakingButton setTitle:NSLocalizedString(@"Pause Speaking", @"Pausing button name (pause)")];
		[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Did continue speaking.\n", @"Log continue speaking"), [[NSCalendarDate calendarDate] description]]];
	}
    else if([_synthesizer isSpeaking]) {
		[_synthesizer pauseSpeakingAtBoundary:_currentStopPauseBoundary];
		[_pauseOrContinueSpeakingButton setTitle:NSLocalizedString(@"Continue Speaking", @"Pausing button name (continue)")];
		[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Did pause speaking.\n", @"Log pause speaking"), [[NSCalendarDate calendarDate] description]]];
	}
}
 
- (IBAction)showOptions:(id)sender
{
    [_synthesizer stopSpeaking];

	NSMutableDictionary * currentSynthesizerSettings = [NSMutableDictionary new];

	id valueObject = [_synthesizer objectForProperty:NSSpeechPitchBaseProperty error:NULL];
	if (valueObject) {
		[currentSynthesizerSettings setObject:valueObject forKey:NSSpeechPitchBaseProperty];
	}
	
	valueObject = [_synthesizer objectForProperty:NSSpeechPitchModProperty error:NULL];
	if (valueObject) {
		[currentSynthesizerSettings setObject:valueObject forKey:NSSpeechPitchModProperty];
	}
	
	valueObject = [_synthesizer objectForProperty:NSSpeechRateProperty error:NULL];
	if (valueObject) {
		[currentSynthesizerSettings setObject:valueObject forKey:NSSpeechRateProperty];
	}
	
	valueObject = [_synthesizer objectForProperty:NSSpeechVolumeProperty error:NULL];
	if (valueObject) {
		[currentSynthesizerSettings setObject:valueObject forKey:NSSpeechVolumeProperty];
	}
	
	valueObject = [_synthesizer objectForProperty:NSSpeechInputModeProperty error:NULL];
	if (valueObject) {
		[currentSynthesizerSettings setObject:valueObject forKey:NSSpeechInputModeProperty];
	}
	
	valueObject = [_synthesizer objectForProperty:NSSpeechCharacterModeProperty error:NULL];
	if (valueObject) {
		[currentSynthesizerSettings setObject:valueObject forKey:NSSpeechCharacterModeProperty];
	}
	
	valueObject = [_synthesizer objectForProperty:NSSpeechNumberModeProperty error:NULL];
	if (valueObject) {
		[currentSynthesizerSettings setObject:valueObject forKey:NSSpeechNumberModeProperty];
	}

	valueObject = [_synthesizer voice];
	if (valueObject && ! [(NSString *)valueObject isEqualToString:[NSSpeechSynthesizer defaultVoice]]) {
		[currentSynthesizerSettings setObject:valueObject forKey:@"NSSpeechVoice"];
	}

	[currentSynthesizerSettings setObject:[NSNumber numberWithLong:_currentStopPauseBoundary] forKey:@"NSSpeechBoundary"];

	[_optionsSheet updateWithSettings:currentSynthesizerSettings];
	[NSApp beginSheet:[_optionsSheet window] modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(_optionsSheetEnded:returnCode:contextInfo:) contextInfo:currentSynthesizerSettings];
	[currentSynthesizerSettings release];
}

/*
- (IBAction)savePhonemesToFile:(id)sender
{
	NSString * phonemesString = [_synthesizer phonemesFromText:[_synthesizerLogTextView string]];
	if (phonemesString) {
		NSSavePanel *	theSavePanel = [NSSavePanel new];
		[theSavePanel setPrompt:NSLocalizedString(@"Save", @"Save button name")];
		if (NSFileHandlingPanelOKButton == [theSavePanel runModalForDirectory:NULL file:NSLocalizedString(@"Phonemes.txt", @"Default phonemes filename")]) {
			[phonemesString writeToURL:[theSavePanel URL] atomically:false encoding:NSUTF8StringEncoding error:NULL];
		}
		[theSavePanel release];
	}
	else {
		NSRunAlertPanel(@"An error occurred while generating the phonemes.", @"Please try again.", @"OK", NULL, NULL);
	}
}
*/

/*
- (IBAction)saveToFile:(id)sender
{
    if([_synthesizer isSpeaking] || [[[_synthesizer objectForProperty:NSSpeechStatusProperty error:NULL] objectForKey:NSSpeechStatusOutputPaused] integerValue]) {
        [_synthesizer stopSpeakingAtBoundary:_currentStopPauseBoundary];
	}
    else {    
        NSSavePanel *	theSavePanel = [NSSavePanel new];
        [theSavePanel setPrompt:NSLocalizedString(@"Save", @"Save button name")];
        if (NSFileHandlingPanelOKButton == [theSavePanel runModalForDirectory:NULL file:NSLocalizedString(@"Synthesized Speech.aiff", @"Default save filename")]) {
            [self _startSpeakingTextViewToURL:[theSavePanel URL]];
        }
		[theSavePanel release];
    }
}
*/

/*
- (IBAction)addDictionary:(id)sender
{
	NSOpenPanel *	theOpenPanel = [NSOpenPanel new];
	if (NSFileHandlingPanelOKButton == [theOpenPanel runModalForDirectory:NULL file:NULL types:[NSArray arrayWithObject:@"plist"]]) {
		NSDictionary * theDictionary = [[NSDictionary alloc] initWithURL:[[theOpenPanel URLs] objectAtIndex:0]];
		[_synthesizer addSpeechDictionary:theDictionary];
		[theDictionary release];
	}
	[theOpenPanel release];
}

*/

- (IBAction)clearSynthesizerLog:(id)sender
{
	[_currentMutableLogString setString:NSLocalizedString(@"Synthesizer Log\n", @"Synthesizer Log Title")];
	//[_synthesizerLogTextView setString:NSLocalizedString(@"Synthesizer Log\n", @"Synthesizer Log Title")];
}


#pragma mark Callback Handlers
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender willSpeakPhoneme:(short)phonemeOpcode
{
    [_characterView setExpressionForPhoneme:[NSNumber numberWithShort:phonemeOpcode]];
	[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Will speak phoneme: %d\n", @"Log phoneme delegate message"), [[NSCalendarDate calendarDate] description], phonemeOpcode]];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking
{
    [_synthesizerLogTextView setSelectedRange:_orgSelectionRange];	// Set selection length to zero.

	// Update button states
    [_startOrStopSpeakingButton setTitle:NSLocalizedString(@"Start Speaking", @"Speaking button name (start)")];
    [_startOrStopSpeakingButton setEnabled:YES];
	[_pauseOrContinueSpeakingButton setEnabled:NO];
	[_pauseOrContinueSpeakingButton setTitle:NSLocalizedString(@"Pause Speaking", @"Pausing button name (pause)")];

	if (finishedSpeaking) {
		[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Speaking finished.\n\n", @"Log finished speaking delegate message"), [[NSCalendarDate calendarDate] description]]];
	}
	else {
		[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Speaking was stopped.\n\n", @"Log finished speaking (but didn't finish) delegate message"), [[NSCalendarDate calendarDate] description]]];
	}
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender willSpeakWord:(NSRange)characterRange ofString:(NSString *)string
{
    NSUInteger	selectionPosition = characterRange.location + _offsetToSpokenText;
    NSUInteger	wordLength = characterRange.length;
	
    [_synthesizerLogTextView scrollRangeToVisible:NSMakeRange(selectionPosition, wordLength)];
    [_synthesizerLogTextView setSelectedRange:NSMakeRange(selectionPosition, wordLength)];
    [_synthesizerLogTextView display];

	[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Will speak word: %@\n", @"Log word delegate message"), [[NSCalendarDate calendarDate] description], [string substringWithRange:characterRange]]];
}


- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didEncounterErrorAtIndex:(NSUInteger)characterIndex ofString:(NSString *)string message:(NSString *)message;
{
	[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Encountered error: %@\n", @"Log error delegate message"), [[NSCalendarDate calendarDate] description], message]];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didEncounterSyncMessage:(NSString *)message
{
	[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Encountered sync message: %@\n", @"Log sync delegate message"), [[NSCalendarDate calendarDate] description], message]];
}


#pragma mark Private Methods
- (void)_optionsSheetEnded:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{

	if (returnCode == kOptionsSaveReturnCode) {
	
		// Set synthesizer settings. Set voice first, since it potentially resets other values.
		if ([(NSMutableDictionary *)contextInfo objectForKey:@"NSSpeechVoice"]) {
			[_synthesizer setVoice:[(NSMutableDictionary *)contextInfo objectForKey:@"NSSpeechVoice"]];
		}
		
		NSString * key = NULL;
		NSEnumerator * settingsEnumerator = [(NSMutableDictionary *)contextInfo keyEnumerator];
		while(key = [settingsEnumerator nextObject]) {

			id valueObject = [(NSMutableDictionary *)contextInfo objectForKey:key];
			if ([key isEqualToString:@"NSSpeechBoundary"]) {
				_currentStopPauseBoundary = [valueObject intValue];
			}
			else {
				[_synthesizer setObject:valueObject forProperty:key error:NULL];
			}
		}
	}
	else if (returnCode == kOptionsResetReturnCode) {
		[_synthesizer setVoice:[NSSpeechSynthesizer defaultVoice]];
		[_synthesizer setObject:NULL forProperty:NSSpeechResetProperty error:NULL];
	}
	
    [sheet orderOut:self];
}

- (void)_appendLogString:(NSString *)string
{
	// Let's keep the log from getting too long.
	if ([_currentMutableLogString length] > 20000) {
		[_currentMutableLogString deleteCharactersInRange:NSMakeRange(0, 2000)];
	}
	
	// Add and set it.
	[_currentMutableLogString appendString:string];
	//[_synthesizerLogTextView setString:_currentMutableLogString];
}

- (void)_startSpeakingTextViewToURL:(NSURL *)url
{
	// If speaking or paused, then stop it.
    if([_synthesizer isSpeaking] || [[[_synthesizer objectForProperty:NSSpeechStatusProperty error:NULL] objectForKey:NSSpeechStatusOutputPaused] intValue]) {
        [_synthesizer stopSpeakingAtBoundary:_currentStopPauseBoundary];
	}
    else {

        // Grab the selection substring, or if no selection then grab entire text.
        _orgSelectionRange = [_synthesizerLogTextView selectedRange];
        
        NSString *	theViewText;
        if (_orgSelectionRange.length == 0) {
            theViewText = [_synthesizerLogTextView string];
            _offsetToSpokenText = 0;
        }
        else {
            theViewText = [[_synthesizerLogTextView string] substringWithRange:_orgSelectionRange];
            _offsetToSpokenText = _orgSelectionRange.location;
        }
		
		[self _appendLogString:[NSString stringWithFormat:NSLocalizedString(@"%@ Starting to speak: %@\n", @"Log beginning to speak"), [[NSCalendarDate calendarDate] description], theViewText]];
        
        if (url) {
            [_synthesizer startSpeakingString:theViewText toURL:url];
            [_startOrStopSpeakingButton setEnabled:NO];
        }
        else {
		
			// Update button states if we start speaking successfully
			if ([_synthesizer startSpeakingString:theViewText]) {
				[_startOrStopSpeakingButton setTitle:NSLocalizedString(@"Stop Speaking", @"Speaking button name (stop)")];
				[_pauseOrContinueSpeakingButton setEnabled:YES];
				[_pauseOrContinueSpeakingButton setTitle:NSLocalizedString(@"Pause Speaking", @"Pausing button name (pause)")];
			}
        }
        
    }
}

- (void)speak
{
	[_synthesizerLogTextView setString: final];
	[self _startSpeakingTextViewToURL:NULL];
	
}

- (void)respond
{
	// Response
	FILE *file;
	char textout[SENTSIZE];
	char bigbuf[SENTSIZE*50];

	final = [NSString string];
	
	file = openfile("output.txt", "r");
	
	if(file==NULL) 
	{
		printf("Error: can't open output file.\n");
		//return 1;
	}
	else 
	{
		printf("Output file opened successfully.\n");
		if (fgets(textout, SENTSIZE, file)!=NULL)
		{
			//printf("%s", textout);
			sprintf(bigbuf, "%s", textout);
		}
		while (!feof(file))
		{
			if (fgets(textout, SENTSIZE, file)!=NULL)
			{
				//printf("%s", textout);
				strcat(bigbuf, textout);
			}
		}
		
		fclose(file);
		
		NSString *newText = [[NSString alloc] initWithFormat:@"%s", bigbuf];
		final = [final stringByAppendingString:newText];
		[newText release];
	}
	
	
}


- (void)processQuestion
{
	// Main Sentence Input
	int words = 0;
	char user_input[SENTLEN][WORDSIZE];
	
	// Get input to SNLUP
	char text[SENTSIZE] = " ";
	NSString *test;
	test = [_textToSpeechExampleTextView string];
	
    // See if there are multiple sentences
	
	NSArray *sentences = [test componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".?!"]];
	int numSentences = [sentences count]-1;
	
	if (numSentences==0)
		numSentences = 1;
	
	NSLog(@"Num Sentences: %d", numSentences);
	
	for (int i = 0; i<numSentences; i++)
	{
		NSString *input = [sentences objectAtIndex:i];
		
		// Convert to a C String for Snlup
		const char *cString = [input UTF8String];   
		sprintf(text, "%s", cString);
		
		process_input(user_input, words, text);
		
		[self respond];

	}
	
	[self speak];
	removefile("output.txt");	// Remove old output file so reply() will start a new one	
}

- (IBAction)questionDidChange:(id)sender
{	
	[self processQuestion];
}

- (IBAction)recordPermFact:(id)sender
{
	NSLog(@"Record Perm Fact\n");
	write_to_kb = TRUE;
	[self processQuestion];
}

- (IBAction)clearContext:(id)sender
{
	NSLog(@"Clear Context\n");
	clear_context();
	[self respond];
	[self speak];
	removefile("output.txt");	// Remove old output file so reply() will start a new one
}

- (IBAction)newPhraseWindow:(id)sender
{
	winController = [[newPhraseWindowController alloc] init];
    [winController showWindow:self];
}

- (IBAction)debugRufus:(id)sender
{
	debugController = [[DebugSnlupWindowController alloc] init];
    [debugController showWindow:self];
}

- (IBAction)openFactsper:(id)sender
{
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/Applications/TextEdit.app/Contents/MacOS/TextEdit"];
	NSArray *args = [NSArray arrayWithObjects: @"/Users/klkittel/Documents/Rufus/Data/facts.per", nil];
    [task setArguments: args];
	[task launch];
	[task release];
}

- (IBAction)callTextEdit:(id)sender
{
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/Applications/TextEdit.app/Contents/MacOS/TextEdit"];
	//NSArray *args = [NSArray arrayWithObjects: @"/Users/klkittel/Documents/Rufus/Data/anoknok.scr", nil];
    //[task setArguments: args];
	[task launch];
	[task release];
}


- (IBAction)openfile:(id)sender
{
	// Create the File Open Dialog class.
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];

	// Enable the selection of files in the dialog.
	[openDlg setCanChooseFiles:YES];

	// Enable the selection of directories in the dialog.
	[openDlg setCanChooseDirectories:YES];
    
    // Get the path to the Data folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/Rufus/Data"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:documentsDirectory];
    
    // Default to open Rufus/Data
    [openDlg setDirectoryURL:fileURL];
     
	// Display the dialog.  If the OK button was pressed,
	// process the files.
	if ( [openDlg runModal] == NSOKButton )
	{
        // Loop through all the files and process them.
        for( NSURL* URL in [openDlg URLs] )
        {
            NSLog( @"Filename: %@", [URL path] );
            
            NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:@"/Applications/TextEdit.app/Contents/MacOS/TextEdit"];
            NSArray *args = [NSArray arrayWithObjects:[URL path], nil];
            [task setArguments: args];
            [task launch];
            [task release];
		}
	}
}


- (void)dealloc
{
    [winController release];
    [super dealloc];
}

@end


