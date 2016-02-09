# waifu
Lists jpg, png, and gif files in a directory, builds a HTML page to display them.

Put images in the ```/s``` directory.  Images will be renamed to the first 12 characters of their SHA1 hash and 400px wide thumbnails created.  Clearing the ```/t``` directory is recommended after removing an image from ```/s```; it will not be removed on its own.

It looks like this in action: https://homu.us/waifu/

Optionally, run the script with ```--optipng -o[1-7]``` to compress PNGs prior to hashing.

### Dependencies:
* Perl
* ImageMagick ```convert``` program in system path
* ```sha1sum``` program in system path
* GNU coreutils ```ls```, ```mv```, and ```mkdir``` in system path
* ```optipng``` in system path [OPTIONAL]
* A waifu
