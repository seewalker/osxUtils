## screen_samples.app

# What is it? screen_samples uses the apple automator tool to take a screenshot and save the image in a designated place with sequentially-increasing-integer file names. That is, if screen_samples has taken 5 images, the next will be called '6'. By installing the crontab, a screenshot can be taken periodically at intervals of your choosing. Over time, this images will accumulate in the folder you chose, and you can look back on what you spend your time doing.

# How to set it up?
- open up screen_samples.app with automator and replace " " with the folder you want to store the screenshots in.
- open up terminal and type "crontab -e". Add to the buffer the line from the file 'crontab' from this repository.

# dependencies?
none

# Does it send the images to malicious, nosy people?
Nope.

## label.pl

# What is it?  
OSX associates a so-called 'label' with files (including directories), which Finder represents as a colored dot. Running this script will recursively traverse all the directories within a designated chroot (v.i.z starting point), labeleing directories based on what they contain. The scheme the script comes with associates directories containing 
- source code (.c, .py, .hs, etc)
- textual stuff (pdfs, doc, txt, md, rtf, etc)
- audiovisual stuff (mp3, mp4, mov, aiff, etc)
- a project root (indicated by presence of something like a Makefile, setup.py, project.clj, etc)
- object files
- executables

The current colorscheme of associating yellow, orange, and red with source code, object files, and executables respectively makes a good deal of sense, given those colors forming a gradient and those file-types being a gradient in common compilation-processes. 

# How to set it up?
Set the value of the `$root` variable.
Change the pairings in the `%label_map` variable to your liking if the colorscheme here does not appeal to you.
`perl label.pl label` - runs it.

# dependencies
perl, and the File::Temp module (which can be easily installed with CPAN).

## only_work.app

This closes all applications, except those associated with work. Naturally, this means the applications in this list are custom, and they can be changed straightforwardly by opening the app with automator and modifying the list. I find myself doing this often, and making it a single action feels resolute. It does the sane thing and asks you about saving changes, with software done by apple so you do not have to trust me as implementing check-before-quitting properly.

## only_browse.app

Similar to only_work; you get the idea.

## 
