#import <Cocoa/Cocoa.h>
#import "TextEditorWindowController.h"

@interface ExampleWindow : NSWindowController {

	TextEditorWindowController *	winController;
}

@property (nonatomic, retain) TextEditorWindowController	*winController;


@end

