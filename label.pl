#Note: One iteration of 'label' took about 0.3 s on my system. That time adds up for using this on a large search space.

use strict;
use v5.16;
use File::Temp qw/tempfile/;
my %label_map = ( 'none' => 0, 'orange' => 1, 'red' => 2, 'yellow' => 3, 'blue' => 4, 'purple' => 5, 'green' => 6, 'gray' => 7); #these are osascript labels.
my %meaning_map = (0 => 'no label', 1 => 'object files', 2 => 'executables', 3 => 'source code', 4 => 'project root', 5 => 'textual content', 6 => 'audiovisual content');
my $root = "/Users/shalom";
my @src_exts = ("c", "h", "hpp", "cpp", "cxx", "py", "pl", "pm", "rb", "r", "sh", "bash", "zsh", "scm", "clj", "xtm", "hs", "lhs", "vim", "el");
my @txt_exts = ("txt", "rtf", "doc", "docx", "pdf", "swd", "epub", "tex");
my @audiovisual_exts = ("mp3","mp4","wav","aiff","jpg","png","gif","tiff","mov");
my @obj_exts=("o", "so", "dll", "dylib", "a", "hi", "pyc");
my $usageStmt = "Usage: label.sh ( label | unlabel)\n";
my $colorcodeStmt = <<EOF;
Orange means object files are in the directory.
Red means executables are in the directory.
Yellow means source code is in the directory.
Blue means the directory is the root directory of some known software template (like a c library, clojure app), or that it is under version control.
Purple means the directory contains textual stuff.
Green means audiovisual stuff is in the directory.
EOF
sub contains_ext {
    my ($dir, @exts) = @_;
    opendir(my $dh, $dir);
    while (my $d = readdir $dh) {
        next if ($d eq "." or $d eq "..");
        my @parts = split(qr/\./, $d);
        #This checks, in the perliest perl, whether the extension is in the set of matchable extensions.
        return 1 if ($parts[-1] ~~ @exts);
    }
    closedir($dh);
    return 0;
}

sub contains_executable {
    my $dir = shift;
    opendir(my $dh, $dir);
    while (my $f = readdir $dh) {
        next if ($f eq "." or $f eq "..");
        #The file must not be a directory. Executableness has a different meaning for directories than for regular files.
        return 1 if (-x "$dir/$f" and (not -d "$dir/$f")); 
    }
    closedir($dh);
    return 0;
}
sub contains_project {
    my $dir = shift;
    opendir(my $dh, $dir);
    while (my $f = readdir $dh) {
        next if ($f eq "." or $f eq "..");
        if (($f =~ /Makefile/) or ($f eq "project.clj") or ($f eq "configure") or ($f =~ /README/i) or ($f =~ /Setup\.l?hs/) or ($f eq "setup.py")
            or ($f eq ".git") or ($f eq ".scm-settings")) {
            return 1; 
        }
    }
    closedir($dh);
    return 0;
}

sub label {
    my ($label, $dir) = @_;
    my ($fh, $filename) = tempfile();
    print $fh <<EOF;
set theFile to POSIX file "$dir" as alias
tell application "Finder" to set label index of theFile to $label
EOF
    print "$dir is getting label ";
    system "osascript $filename"; #this prints the label and a newline
    print sprintf("Which means %s\n", $meaning_map{$label});
}

sub recur {
    my ($node, $isUnlabel) = @_;
    opendir(my $dh, $node) or die "$node is not a directory";
    while (my $dt = readdir $dh) {
        my $d = "$node/$dt";
        next unless (-d $d);
        next if ($dt eq '.' or $dt eq '..');
        if ($isUnlabel) {
            label($label_map{'none'}, $d);
        }
        elsif (contains_ext($d, @audiovisual_exts)) {
            label($label_map{'green'}, $d);
        }
        elsif (contains_ext($d, @txt_exts)) {
            label($label_map{'purple'}, $d);
        }
        elsif (contains_project($d)) {
            label($label_map{'blue'}, $d);
        }
        elsif (contains_ext($d, @src_exts)) {
            label($label_map{'yellow'}, $d);
        }
        elsif (contains_ext($d, @obj_exts)) {
            label($label_map{'orange'}, $d);
        }
        elsif (contains_executable($d)) {
            label($label_map{'red'}, $d);
        }
        recur($d, $isUnlabel);
    }
    closedir($dh);
}

if (scalar(@ARGV) != 1) {
    print $usageStmt; exit 1;
}
if ($ARGV[0] eq "unlabel" or $ARGV[0] eq "label") {
    print $colorcodeStmt;
    recur($root, $ARGV[0] eq "unlabel");
}
else {
    print $usageStmt; exit 1;
}
