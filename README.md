# waifu
Lists jpg, png, and gif files in a directory, builds a HTML page to display them.

Put images in the s/ directory.  Images will be renamed to the first 12 characters of their SHA1 hash and 400px wide thumbnails created.

It looks like this in action: https://homu.us/waifu/

# Dependencies:
* Perl
* ImageMagick 'convert' program in system path
* 'sha1sum' program in system path
* GNU coreutils 'ls', 'mv', and 'mkdir' in system path
