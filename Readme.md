# screen_samples.app

## What is it?
screen_samples uses the apple automator tool to take a screenshot and save the image in a designated place with sequentially-increasing-integer file names. That is, if screen_samples has taken 5 images, the next will be called '6'. By installing the crontab, a screenshot can be taken periodically at intervals of your choosing. Over time, this images will accumulate in the folder you chose, and you can look back on what you spend your time doing.

## How to set it up?
- open up screen_samples.app with automator and replace "~/automation/screen_samples" with the folder you want to store the screenshots in.
- open up terminal and type "crontab -e". Add to the buffer the line from the file 'crontab' from this repository.
- note, if you are concerned about disk space, you might want to delete some of these images every so often.

Some information on what a crontab is.

## dependencies?
none

## Does it send the images to malicious, nosy people?
Nope.

# label.pl

## What is it?
OSX associates a so-called 'label' with files (including directories), which Finder represents as a colored dot. Running this script will recursively traverse all the directories within a designated chroot (v.i.z starting point), labeleing directories based on what they contain. The scheme the script comes with associates directories containing
- <span style="color:yellow"> source code (.c, .py, .hs, etc) </span>
- <span style="color:orange">object files</span>
- <span style="color:red">executables</span>
- <span style="color:green">a project root (indicated by presence of something like a Makefile, setup.py, project.clj, etc)</span>
- <span style="color:blue">textual stuff (pdfs, doc, txt, md, rtf, etc)</span>
- <span style="color:purple">audiovisual stuff (mp3, mp4, mov, aiff, etc)</span>

The current colorscheme of associating yellow, orange, and red with source code, object files, and executables respectively makes a good deal of sense, given those colors forming a gradient and those file-types being a gradient in common compilation-processes. Green indicates a software project root, due to qualitative similarities with yellow rather than blue or purple. Textual and audiovisual stuff are blue and purple respectively, and are similar to indicate them both being content.

## How to set it up?
- Set the value of the `$root` variable.
- Change the pairings in the `%label_map` variable to your liking if the colorscheme here does not appeal to you.
- `perl label.pl label` - runs it. you can execute `perl label.pl unlabel` if you wish to remove labels later.
- You may want to put running this in your crontab as well, though not as often because this can take a few hours.

## dependencies
perl, and the File::Temp module (which can be easily installed with CPAN).

# disk_delta.app

## What is it?
Looks up current amount of free disk space, compares this value to the that of the previous time disk_delta ran, and displays a notification of the difference.

## How to set it up?

- Open the app in automator and click on the "shell script" icon in the body of the notification. In that buffer, change the value of '$parking' to the file where you would like to store disk usage information. The script "disk_delta.bash" in the repository is not actually invoked by disk_delta.app; it is a mirror so you can read it if curious about the mechanism.
- Update your crontab to invoke this app periodically. See 'crontab' in this directory for an example.

## dependencies

The script uses awk for selecting the column of output it is interested in.

# only_work.app

This closes all applications, except those associated with work. Naturally, this means the applications in this list are custom, and they can be changed straightforwardly by opening the app with automator and modifying the list. I find myself doing this often, and making it a single action feels resolute. It does the sane thing and asks you about saving changes, with software done by apple so you do not have to trust me as implementing check-before-quitting properly.

# only_browse.app

Similar to only_work; you get the idea.
