Rufus
=====

Simplified Natural Language Understanding Program for Mac OS X

This project strives to create a child AI that learns. It is the "middle" part of the software, it does not include a speech recognition frontend. This version does have a text-to-speech generator on the backend, however. It uses pattern matching, grouping, logic, memory, substitution, and search to achieve its learning and to answer questions bases on the learning. You are supposed to teach it, by feeding in a complete sentence or paragraph as input. Then, you can ask it questions, and if it has learned correctly, it will answer the question correctly.

My goal for this software was for it to be an AI Learning kit for kids to play with. I have other versions that I intended to be virtual assistants, the hardware consisting of a small single board computer with audio speakers and michrophone. I think this might be able to be done with the Raspberry Pi and the Jasper software now available. Of course back in 1998 when I first created this software, single board computers were not so cheap and widely available as they are now.

There is a minimal phrase file included. Not all english sentences are understood. The software looks up each input in the phrase file, and then performs the action associated with that phrase. The phrases are stored as such : object  phrase object where each object represents a variable word, or even another phrase altogether. Phrase respresents a literal word or phrase which will match to the input. There are three types of these currently in use: object phrase object, object phrase and phrase object. By doing it ths way, it is not specific to English or any other language, although it uses the standard ASCII character set for English, which can be altered to accept others of course. This program provides a nice GUI for creating, deleting, and editing phrases in the phrase file. It can also be edited by hand with a text editor. Facts that are learned are stored in a knowledge base area, and facts can be added to the knowledge base by hand if you like.

So far, I have only achieved roughly 75% of correct responses for a first grade reading comprehension test. The big thing about passing the test is that the child needs to demonstrate the ability to count; I haven't gotten that far with Rufus yet.

- Karl
