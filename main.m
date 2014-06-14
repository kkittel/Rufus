//
//  main.m
//  Rufus
//
//  Created by Karl Kittel on 8/22/11.
//  Copyright 2011 Countryside Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <stdio.h>
#import <stdlib.h>
#import "snlup.h"
#import "utilities.h"
#import "io.h"

int main(int argc, char *argv[])
{
	init(); // Init Snlup
    return NSApplicationMain(argc,  (const char **) argv);
}
