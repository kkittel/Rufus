// Utilities.c

#import <Cocoa/Cocoa.h>
#import <stdio.h>
#import <stdlib.h>
//#import <curses.h>
#import <time.h>
#import "snlup.h"
#import "externs.h"
#import "io.h"
#import "groups.h"
#import "phrases.h"
#import "utilities.h"
#import "facts.h"
#import "hypothesis.h"
#import "database.h"

/*
void cspause(void)
{
	// Pause for debugging only
	
	int key = 0;
	
	printf("Press any key...\n");
	key = getch();
	if (key == 27)
		// esc key
		exit_snlup(0);
}
*/
//***************************************************************************
void viewglobals(char procname[WORDSIZE])
{ 
  int loop = 0;

  printf("Entering Proc %s\n", procname);

  printf("\nNum Object1 Words %d, object1: ", num_object1_words);
  for (loop = 0; loop < num_object1_words; loop++)
    printf("%s ", object1[loop]);

  printf("\nNum Object2 Words %d, object2: ", num_object2_words);
  for (loop = 0; loop < num_object2_words; loop++)
    printf("%s ", object2[loop]);
  printf("\n");

  //printf("frsfile: %s\n", frsfiles[0]);
  //cspause();
}

//***************************************************************************

void exit_snlup(int ecode)
{
  if (phase != CLEANUP)
    cleanup();
  exit(ecode);
}

//***************************************************************************
/* DISABLE FREETIME FOR NOW
int freetime(void)
{
  // During free time (lag time between input), do some housekeeping.

  if (kbhit())
    return (0);
  if (housekeeping == CHECKPERFACTS || housekeeping == CHECKALLPERS || 
	  housekeeping == ALL)
  {
    prune_group_file("facts.per", 0, ELIMDUPS, 0);
    housekeeping = 0;
  }
  if (kbhit())
    return (0);
  if (housekeeping == CHECKTMPFACTS || housekeeping == CHECKALLTMPS ||
	  housekeeping == ALL)
  {
    prune_group_file("facts.tmp", 0, ELIMDUPS, 0);
    housekeeping = 0;
  }
  if (kbhit())
    return (0);
  if (housekeeping == CHECKPERRULES || housekeeping == CHECKALLPERS ||
	  housekeeping == ALL)
  {
    prune_group_file("rules.per", 0, ELIMDUPS, 0);
    housekeeping = 0;
  }
  if (kbhit())
    return (0);
  if (housekeeping == CHECKTMPRULES || housekeeping == CHECKALLTMPS ||
	  housekeeping == ALL)
  {
    prune_group_file("rules.tmp", 0, ELIMDUPS, 0);
    housekeeping = 0;
  }
  if (kbhit())
    return (0);

  // expand_new_phrases();

  combine_facts("facts.tmp", 0);

  return (0);

} // End proc freetime
*/
//***************************************************************************

void init(void)
{
  // One-time initialization at the start of the main program.

  if (!no_banner)
  {
    printf("\nSimplified Natural Language Understanding Program\n");
    printf("Copyright (c) 1998  Karl L. Kittel\n");
    printf("\nInitializing...\n");
  }

  mid_script=FALSE;
  skip_commands = 0;
	
  set_global_seed();
	
  // Setup Auto Release Pool
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
  // Get Documents directory filepath and setup the datapath
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  documentsDirectory = [documentsDirectory stringByAppendingString:@"/Rufus/Data"];
  const char *cString = [documentsDirectory UTF8String];
  printf("documents directory: %s\n", cString);	
  //sprintf(datapath, "%s/Rufus/Data", cString);
  sprintf(datapath, "%s", cString);
  printf("datapath: %s\n", datapath);
	
  sprintf(frsfiles[0], "phrases.frs"); // Init phrase file list
  num_frs_files = 1;
  
  // Create data files
  //create_phrase_file();
  //create_preproc_file();
  //create_response_file();
  //create_color_file();
  //create_personality_file();
	
  erase_temp_fact_file();

  //tmpfacts = openfile("facts.tmp", "w");
  //fprintf(tmpfacts, "today is saturday g\n"); // Put in code to add real day
  //closefile(tmpfacts);

  // Log File Activity  
  //filelog = TRUE;
  //removefile("filelog.txt");
	
  //[paths release];
  //[documentsDirectory release];
  [pool release];

} // End proc init

//***************************************************************************


int random_num(int low, int high)
{
  // Generate a Random Number between low and high
  // Depends on the global variable global_seed.

  int result = 0, loop = 0;

  if (low < 0 || high < 0)
  {
    printf("** Error: negative value passed to random_num\n");
    return (0);
  }
  if (low == high)
    result = low;
  else if ((high - low) == 1)
    result = ((global_seed % 2) + low);
  else
  {
	result = low;  
    for (loop = 0; loop < global_seed; loop++)
	{
		result++;
		if (result > high)
			result = low;
	}
//    while (result < low || result > high)
//      result = rand();
  }
  //   global_seed = (global_seed) + result % 1000;
  set_global_seed();

  return result;

} // End proc random_num

//***************************************************************************

void set_global_seed(void)
{
  // sets the global seed used for random number generation

  time_t *timer;

  timer = calloc(1, sizeof(time_t));
  time(timer); //  record time of program start */
  global_seed = global_seed + (abs((int)(*timer))) % 1000;
    // Start a global seed

} // End proc set_global_seed

//***************************************************************************

void cleanup(void)
{
  // One-time cleanup at the end of the main program.

  phase = CLEANUP;

  collect_hypotheses();

  removefile("facts.tmp");
  removefile("rules.tmp");
  removefile("junk.tmp");
  removefile("output.txt");
  removefile("ready.txt");	 

} // End proc cleanup