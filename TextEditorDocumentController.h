//
//  TextEditorDocumentController.h
//  Rufus
//
//  Created by Karl Kittel on 11/23/11.
//  Copyright 2011 Contryside Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyDocument.h"

@interface TextEditorDocumentController : NSDocumentController {

	IBOutlet MyDocument	*myDocument;
}

@property (nonatomic, retain)IBOutlet MyDocument	*myDocument;

@end
