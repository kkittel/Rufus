//
//  newPhraseWindowController.m
//  Rufus
//
//  Created by Karl Kittel on 11/18/11.
//  Copyright 2011 Contryside Software. All rights reserved.
//

#import "newPhraseWindowController.h"
#import "snlup.h"
#import "io.h"


@implementation newPhraseWindowController

@synthesize newPhraseButton;
@synthesize editExistingPhraseButton;
@synthesize searchField;
@synthesize phraseField;
@synthesize actionField;
@synthesize purposeField;
@synthesize emotionField;
@synthesize createNewPhraseButton;
@synthesize nextPhraseButton;
@synthesize previousPhraseButton;
@synthesize applyChangesButton;
@synthesize phraseNumberField;
@synthesize lines;
@synthesize createPhraseAlert;
@synthesize deletePhraseAlert;
@synthesize editExisitingPhraseAlert;
@synthesize deletePhraseButton;

- (void)dealloc {
    [newPhraseButton release];
    [editExistingPhraseButton release];
	[searchField release];
    [phraseField release];
	[actionField release];
	[purposeField release];
	[emotionField release];
	[createNewPhraseButton release];
	[nextPhraseButton release];
	[previousPhraseButton release];
	[applyChangesButton release];
	[phraseNumberField release];
	[lines release];
	[deletePhraseButton release];
	[super dealloc];
}

- (IBAction) deletePhrase:(id) sender
{
	deletePhraseAlert = [[NSAlert alloc] init];
    [deletePhraseAlert addButtonWithTitle:@"OK"];
    [deletePhraseAlert addButtonWithTitle:@"Cancel"];
    [deletePhraseAlert setMessageText:@"Delete the Current Phrase Record?"];
    [deletePhraseAlert setInformativeText:@"Deleted Phrases Can Not Be Restored, Unless you Create a New Phrase."];
    [deletePhraseAlert setAlertStyle:NSWarningAlertStyle];
    [deletePhraseAlert beginSheetModalForWindow:[searchField window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction) createNewPhrase:(id) sender
{
	createPhraseAlert = [[NSAlert alloc] init];
    [createPhraseAlert addButtonWithTitle:@"OK"];
    [createPhraseAlert addButtonWithTitle:@"Cancel"];
    [createPhraseAlert setMessageText:@"Create the Phrase record?"];
    [createPhraseAlert setInformativeText:[NSString stringWithFormat: @"The phrase will be inserted at position: %d", currentPhrase+1]];
    [createPhraseAlert setAlertStyle:NSWarningAlertStyle];
    [createPhraseAlert beginSheetModalForWindow:[searchField window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void) writePhraseFile
{
	int i=0;
	FILE *phrase_file;

	// Unfortunately we need to write out the file C style
	// so that the legacy SNLUP code can read it properly
	
	// Open the phrase file
	phrase_file = openfile("phrases.frs", "w");
	//phrase_file = openfile("temp.frs", "w");
	
	// Write the array to the phrases file
	// Loop through the array
	for (i=0; i< [lines count]; i++)
	{
		// Convert the NSString to a C string
		const char *cString = [[lines objectAtIndex:i] UTF8String];
		fprintf(phrase_file,  "%s\n", cString);	
	}
	
	// Close the phrase file
	closefile(phrase_file);
}

- (IBAction) applyChanges: (id) sender
{
	int index = currentPhrase * 4;
	
	[lines replaceObjectAtIndex:index withObject:[phraseField stringValue]];
	[lines replaceObjectAtIndex:index+1 withObject:[actionField stringValue]];
	[lines replaceObjectAtIndex:index+2 withObject:[purposeField stringValue]];
	[lines replaceObjectAtIndex:index+3 withObject:[emotionField stringValue]];
	
	// Calculate new number of phrases in array
	numPhrases = [lines count] / 4;
	
	// Write the array to the phrase file
	[self writePhraseFile];
	
}

- (void) deleteExistingPhrase
{
	int index = currentPhrase * 4;

	[lines removeObjectAtIndex:index];
	[lines removeObjectAtIndex:index];
	[lines removeObjectAtIndex:index];
	[lines removeObjectAtIndex:index];

	// Calculate new number of phrases in array
	numPhrases = [lines count] / 4;
	
	// Write the array to the phrase file
	[self writePhraseFile];
	
	// Display the Current Phrase
	[self displayPhrase];

}

- (void) insertNewPhrase
{
	int index = currentPhrase * 4;
	
	[lines insertObject:[phraseField stringValue] atIndex:index];
	[lines insertObject:[actionField stringValue] atIndex:index+1];
	[lines insertObject:[purposeField stringValue] atIndex:index+2];
	[lines insertObject:[emotionField stringValue] atIndex:index+3];
	
	// Calculate new number of phrases in array
	numPhrases = [lines count] / 4;
	
	// Write the array to the phrase file
	[self writePhraseFile];
		
}

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	if (alert == createPhraseAlert)
	{
		NSLog(@"createPhraseAlert");
		NSLog(@"Button pressed: %ld", returnCode);
		if (returnCode == OK)
			[self insertNewPhrase];
	}
	
	if (alert == deletePhraseAlert)
	{
		NSLog(@"deletePhraseAlert");
		NSLog(@"Button pressed: %ld", returnCode);
		if (returnCode == OK)
			[self deleteExistingPhrase];
	}
}

- (IBAction) gotoPhraseNum:(id) sender
{
	currentPhrase = [phraseNumberField intValue] - 1;
	if (!createPhrase)
		[self displayPhrase];
}

- (IBAction) enableSearch:(id) sender
{
	[self clearPhrase:self];
	
	// Disable the Apply Changes Button
	[applyChangesButton setEnabled:NO];
	
	// Disable the Delete Phrase Button
	[deletePhraseButton setEnabled:NO];

	// Disable the Create New Phrase Button
	[createNewPhraseButton setEnabled:NO];
	
	// Enable the search field
	[searchField setEnabled:YES];
	
	// Set the Flag
	createPhrase = FALSE;
}

- (IBAction) search:(id) sender
{
	int i = 0;
	
	NSString *temp = [searchField stringValue];
    NSString *string1 = [temp lowercaseString];
	
	// Loop through all values in the array
	
	for(i=0; i<numPhrases; i++)
	{
        temp = [lines objectAtIndex:i*4];
		NSString *string2 = [temp lowercaseString];
		
		if ([string1 isEqualToString:string2])
		{
			currentPhrase = i;
			[self displayPhrase];
			break;
		}
	}
							  
}

- (IBAction) clearPhrase:(id) sender
{
	// Clear all the field values
	[phraseField  setStringValue:@""];
	[actionField  setStringValue:@""];
	[purposeField setStringValue:@""];
	[emotionField setStringValue:@""];
		
	// Disable the search field
	[searchField setEnabled:NO];
	
	// Disable the Apply Changes Button
	[applyChangesButton setEnabled:NO];
	
	// Disable the Delete Phrase Button
	[deletePhraseButton setEnabled:NO];

	// Enable the Create New Phrase Button
	[createNewPhraseButton setEnabled:YES];
	
	// Set the phrase number field
	[phraseNumberField setStringValue:[NSString stringWithFormat: @"%d", currentPhrase+1 ]];

	createPhrase = TRUE;
	
}

- (IBAction) editExistingPhrase:(id) sender
{
	//currentPhrase = 0;
	
	// Disable the search field
	[searchField setEnabled:NO];
	
	// Enable the Apply Changes Button
	[applyChangesButton setEnabled:YES];
	
	// Ensable the Delete Phrase Button
	[deletePhraseButton setEnabled:YES];
	
	// Disable the Create New Phrase Button
	[createNewPhraseButton setEnabled:NO];
	
	createPhrase = FALSE;

	[self displayPhrase];
}

- (void) displayPhrase
{
	int index = currentPhrase * 4;
	
	[phraseField  setStringValue:[lines objectAtIndex:index]];
	[actionField  setStringValue:[lines objectAtIndex:index+1]];
	[purposeField setStringValue:[lines objectAtIndex:index+2]];
	[emotionField setStringValue:[lines objectAtIndex:index+3]];
	
	// Set the phrase number field
	[phraseNumberField setStringValue:[NSString stringWithFormat: @"%d", currentPhrase+1 ]];
	
}

- (IBAction) incrementPhraseNum:(id) sender
{
	currentPhrase++;
	
	if (currentPhrase > numPhrases-1)
		currentPhrase = numPhrases-1;
	
	[self displayPhrase];
}

- (IBAction) decrementPhraseNum:(id) sender
{
	currentPhrase--;
	
	if (currentPhrase < 0)
		currentPhrase = 0;
	
	[self displayPhrase];
}

- (NSString *)phraseFileName
{
	// Get Documents directory filepath and setup the datapath
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	documentsDirectory = [documentsDirectory stringByAppendingString:@"/Rufus/Data/"];
	
	// Setup filename
	NSString *fileName = @"phrases.frs";
	//NSString *fileName = @"temp.frs";
	NSString *fullName = [documentsDirectory stringByAppendingString:fileName];
	return fullName;
}

- (void) awakeFromNib
{	
	NSLog(@"Awake from nib");
	
	// Load Data into Combo Boxes
	
	// Actions
	
	[actionField addItemWithObjectValue:@"yes"];
	[actionField addItemWithObjectValue:@"no"];
	[actionField addItemWithObjectValue:@"replace last"];
	[actionField addItemWithObjectValue:@"record fact temporary"];
	[actionField addItemWithObjectValue:@"find one fact"];	
	[actionField addItemWithObjectValue:@"find one fact plus <words>"];
	[actionField addItemWithObjectValue:@"find one fact yesno"];
	[actionField addItemWithObjectValue:@"find one facts plus <words> yesno"];
	[actionField addItemWithObjectValue:@"find two facts"];	 
	[actionField addItemWithObjectValue:@"find two facts plus <words>"];
	[actionField addItemWithObjectValue:@"find two facts yesno"];	
	[actionField addItemWithObjectValue:@"find two facts plus <words> yesno"];
	[actionField addItemWithObjectValue:@"find all facts"];
	[actionField addItemWithObjectValue:@"find all facts yesno"];
	[actionField addItemWithObjectValue:@"find all facts plus <words>"];	 
	[actionField addItemWithObjectValue:@"find all facts plus <words> yesno"];
	[actionField addItemWithObjectValue:@"record rule temporary"];	
	[actionField addItemWithObjectValue:@"run script"];
	[actionField addItemWithObjectValue:@"run script <scriptname>"];
	[actionField addItemWithObjectValue:@"read"];
	[actionField addItemWithObjectValue:@"acknowledge"];
	[actionField addItemWithObjectValue:@"reduce"];	 
	[actionField addItemWithObjectValue:@"greeting"];
	[actionField addItemWithObjectValue:@"say not sure"];	
	[actionField addItemWithObjectValue:@"elaborate"];
	[actionField addItemWithObjectValue:@"record adjective <adjective>"];
	[actionField addItemWithObjectValue:@"undefined"];
	 
	// Purposes
	
	[purposeField addItemWithObjectValue:@"thing"];
	[purposeField addItemWithObjectValue:@"a implies b"];
	[purposeField addItemWithObjectValue:@"a impliesnot b"];
	[purposeField addItemWithObjectValue:@"see if a implies b"];
	[purposeField addItemWithObjectValue:@"see if b implies a"];
	[purposeField addItemWithObjectValue:@"see if a impliesnot b"];
	[purposeField addItemWithObjectValue:@"say a fact with two objects"];
	[purposeField addItemWithObjectValue:@"ask a question with one object"];
	[purposeField addItemWithObjectValue:@"ask a question with two objects"];
	[purposeField addItemWithObjectValue:@"if a then b"];
	[purposeField addItemWithObjectValue:@"say yes"];
	[purposeField addItemWithObjectValue:@"say no"];
	[purposeField addItemWithObjectValue:@"none"];
	[purposeField addItemWithObjectValue:@"acknowledge"];
	[purposeField addItemWithObjectValue:@"greeting"];
	[purposeField addItemWithObjectValue:@"say not sure"];
	[purposeField addItemWithObjectValue:@"elaborate"];
	[purposeField addItemWithObjectValue:@"<OBJECT>"];
	[purposeField addItemWithObjectValue:@"add <adjective> adjective"];
	
	// Emotions
	
	[emotionField addItemWithObjectValue:@"normal"];
	[emotionField addItemWithObjectValue:@"none"];
		
	// Get buffer from file
	NSString *buffer = [[NSString alloc] initWithContentsOfFile:[self phraseFileName]];
	
	// Break up buffer into seperate lines of file
	lines = [[NSMutableArray alloc] initWithArray:[buffer componentsSeparatedByString:@"\n"]];
	
	// Calculate number of phrases in file
	numPhrases = [lines count] / 4;
	
	//NSLog(@"%d", numPhrases);

	// Init the currentPhrase
	currentPhrase = 0;
	
	// Set up create new phrase
	[self clearPhrase:self];
	
	[buffer release];

}

- (id)init
{
    self=[super initWithWindowNibName:@"newPhraseWindow"];
    if(self)
    {
		// Do init here
    }
    return self;
}

@end
