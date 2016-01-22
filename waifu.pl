#!/usr/bin/perl
#
#	Waifu shrine
#	Lists jpg, png, and gif files in a directory, builds a html page to display them
#	https://github.com/homura/waifu
#
use List::Util 'shuffle';
use strict;

my $title = "Homuhomu~";	# Page title
my $favicon = "../i/HomuraSoulGemTransformed.ico";	# Path to favicon


open (html, ">", "index.html");
print html '<!doctype html>' . "\n";
print html '<html>' . "\n";
print html '<head>' . "\n";
print html '<meta charset="UTF-8">' . "\n";
print html '<title>' . $title . '</title>' . "\n";
print html '<link rel="shortcut icon" href="' . $favicon . '" />' . "\n";
print html '<link rel="stylesheet" href="./waifu.css">' . "\n";
print html '</head>' . "\n";
print html '<body>' . "\n";
print html '<div id="photos">' . "\n";

system('mkdir thumb');	# Creates a thumb directory if it doesn't already exist, preventing errors later on.

my @waifus;
my @lsjpg = qx/ls -1 src\/*.jpg/;
my @lspng = qx/ls -1 src\/*.png/;
my @lsgif = qx/ls -1 src\/*.gif/;

unshift (@waifus, @lsjpg);
unshift (@waifus, @lspng);
unshift (@waifus, @lsgif);
@waifus = shuffle(@waifus);	# Comment out this line to display waifus in numeric order (0-F) by their SHA1 hash.
foreach (@waifus) {
	chomp($_);
	$_ =~ s/src\///;
	my @sha1 = qx/sha1sum src\/$_/;
	$sha1[0] =~ m/\.(\w{3})/;
	my $filename = substr($sha1[0], 0, 40) . "." . $1;
	system('mv src/' . $_ . ' ' . 'src/' . $filename);
	system('convert src/' . $filename . ' -resize 400 thumb/' . $filename);
	print html '<a href="./src/' . $filename . '"><img src="./thumb/' . $filename . '" alt="waifu"></a>' . "\n";
}

print "Found " . scalar(@waifus) . " waifus: " . scalar(@lsjpg) . " jpgs, " . scalar(@lspng) . " pngs, " . scalar(@lsgif) . " gifs\n";

print html '</div>' . "\n";
print html '</body>' . "\n";
print html '</html>' . "\n";
close html;