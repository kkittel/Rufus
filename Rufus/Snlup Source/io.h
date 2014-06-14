// io.h

//void interact_with_screen(char textstring[SENTSIZE]);

FILE *openfile(char filename[FILELEN], char flags[3]);

int parse(char sentence[SENTLEN][WORDSIZE], FILE *input_file, char text[SENTSIZE]);

void process_input(char input[SENTLEN][WORDSIZE], int num_sent_words, char text[SENTSIZE]);

int renamefile(char oldfile[FILELEN], char newfile[FILELEN]);

int removefile(char filename[FILELEN]);

int preprocess(char input[SENTLEN][WORDSIZE], int num_sent_words);

int access_file(char filename[FILELEN]);

int copyfile(char oldfile[FILELEN], char newfile[FILELEN]);

int concatfile(char oldfile[FILELEN], char newfile[FILELEN]);

void closefile(FILE *filehandle);

void add_log_entry(char entry[WORDSIZE]);

void record_objects(void);

void clear_context(void);