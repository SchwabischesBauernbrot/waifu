use List::Util 'shuffle';
use strict;

open (html, ">", "index.html");

print html '<!doctype html>' . "\n";
print html '<html>' . "\n";
print html '<head>' . "\n";
print html '<meta charset="UTF-8">' . "\n";
print html '<title>Homuhomu~</title>' . "\n";
print html '<link rel="shortcut icon" href="../i/HomuraSoulGemTransformed.ico" />' . "\n";
print html '<link rel="stylesheet" href="./waifu.css">' . "\n";
print html '</head>' . "\n";
print html '<body>' . "\n";
print html '<section id="photos">' . "\n";

my @waifus;
my @lsjpg = qx/ls -1 *.jpg/;
my @lspng = qx/ls -1 *.png/;
my @lsgif = qx/ls -1 *.gif/;
unshift (@waifus, @lsjpg);
unshift (@waifus, @lspng);
unshift (@waifus, @lsgif);
@waifus = shuffle(@waifus);

foreach (@waifus) {
	chomp($_);
	print html '<img src="' . $_ . '" alt="waifu">' . "\n";
}

print "Found " . scalar(@waifus) . " waifus: " . scalar(@lsjpg) . " jpgs, " . scalar(@lspng) . " pngs, " . scalar(@lsgif) . " gifs\n";

print html '</section>' . "\n";
print html '</body>' . "\n";
print html '</html>' . "\n";
close html;