
#import "ExampleWindow.h"

#import "TextEditorWindowController.h"




@implementation ExampleWindow

@synthesize winController;


- (IBAction)newFile:(id)sender
{
	// Open the Text Editor Window

	winController = [[TextEditorWindowController alloc] init];
    [winController showWindow:self];
	
	[winController helloKitty];
}

- (void)dealloc
{
    [winController release];
    [super dealloc];
}

@end


