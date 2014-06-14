//
//  newPhraseWindowController.h
//  Rufus
//
//  Created by Karl Kittel on 11/18/11.
//  Copyright 2011 Contryside Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define OK		1000
#define CANCEL	1001

@interface newPhraseWindowController : NSWindowController {
	IBOutlet NSButtonCell	*NewPhraseButton;
	IBOutlet NSButtonCell	*editExistingPhraseButton;
	IBOutlet NSSearchField	*searchField;
	IBOutlet NSTextField	*phraseField;
	IBOutlet NSComboBox		*actionField;
	IBOutlet NSComboBox		*purposeField;
	IBOutlet NSComboBox		*emotionField;
	IBOutlet NSButton		*createNewPhraseButton;
	IBOutlet NSButton		*nextPhraseButton;
	IBOutlet NSButton		*previousPhraseButton;
	IBOutlet NSButton		*applyChangesButton;
	IBOutlet NSButton		*deletePhraseButton;
	IBOutlet NSTextField	*phraseNumberField;
	NSMutableArray			*lines;
	int						numPhrases;
	int						currentPhrase;
	NSAlert					*createPhraseAlert;
	NSAlert					*deletePhraseAlert;
	NSAlert					*editExisitingPhraseAlert;
	int						createPhrase;
	
}

@property (nonatomic, retain) IBOutlet NSButtonCell		*NewPhraseButton;
@property (nonatomic, retain) IBOutlet NSButtonCell		*editExistingPhraseButton;
@property (nonatomic, retain) IBOutlet NSSearchField	*searchField;
@property (nonatomic, retain) IBOutlet NSTextField		*phraseField;
@property (nonatomic, retain) IBOutlet NSComboBox		*actionField;
@property (nonatomic, retain) IBOutlet NSComboBox		*purposeField;
@property (nonatomic, retain) IBOutlet NSComboBox		*emotionField;
@property (nonatomic, retain) IBOutlet NSButton			*createNewPhraseButton;
@property (nonatomic, retain) IBOutlet NSButton			*nextPhraseButton;
@property (nonatomic, retain) IBOutlet NSButton			*previousPhraseButton;
@property (nonatomic, retain) IBOutlet NSButton			*applyChangesButton;
@property (nonatomic, retain) IBOutlet NSButton			*deletePhraseButton;
@property (nonatomic, retain) IBOutlet NSTextField		*phraseNumberField;
@property (nonatomic, retain) NSMutableArray			*lines;
@property (nonatomic, retain) NSAlert					*createPhraseAlert;
@property (nonatomic, retain) NSAlert					*deletePhraseAlert;
@property (nonatomic, retain) NSAlert					*editExisitingPhraseAlert;

- (void) displayPhrase;
- (IBAction) incrementPhraseNum:(id) sender;
- (IBAction) decrementPhraseNum:(id) sender;
- (IBAction) clearPhrase:(id) sender;
- (IBAction) editExistingPhrase:(id) sender;
- (IBAction) search:(id) sender;
- (IBAction) enableSearch:(id) sender;
- (IBAction) gotoPhraseNum:(id) sender;
- (IBAction) createNewPhrase:(id) sender;
- (IBAction) deletePhrase:(id) sender;
- (IBAction) applyChanges:(id) sender;

@end
