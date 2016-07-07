# waifu
Lists jpg, png, and gif files in a directory, builds a HTML page to display them.

Put images in the ```/s``` directory.  Images will be renamed to the first 12 characters of their SHA1 hash and 400px wide thumbnails created.  Clearing the ```/t``` directory is recommended after removing an image from ```/s```; it will not be removed on its own.


### Optional switches:
* ```--optipng=[1-7]``` to compress PNGs prior to hashing with the optipng program.
* ```--page=[number]``` to specify the number of waifus per page.  If not set, all waifus will appear on one page.  If greater than the number of waifus, all will appear on one page and no navigation links will be created.

### Dependencies:
* Perl
* ImageMagick ```convert``` program in system path
* ```sha1sum``` program in system path
* GNU coreutils ```ls```, ```mv```, and ```mkdir``` in system path
* ```optipng``` in system path (if using optional switch)
* A waifu

### Examples:
```perl waifu.pl --optipng=4 --page=100``` runs optipng on PNG waifus before hashing, and creates HTML pages with 100 waifus per page.