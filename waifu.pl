#!/usr/bin/perl
#
#	Waifu Page Generator
#	Lists jpg, png, and gif files in a directory, builds an html page to display them
#	https://github.com/YandereSkylar/waifu
#
use List::Util 'shuffle';
use strict;

my $title = "waifu4laifu";	# Page title
my $favicon = "../favicon.ico";	# Path to favicon

print "Waifu Page Generator  Copyright (C) 2016  Skylar Gasai\n";
print "This program comes with ABSOLUTELY NO WARRANTY.\n";
print "This is free software, and you are welcome to redistribute it\n";
print "under certain conditions; see LICENSE for details.\n\n";

print "Run with --optipng -o[1-7] if you want to compress PNGs before hashing.\n";

open (html, ">", "index.html");
print html '<!doctype html>' . "\n";
print html '<html>' . "\n";
print html '<head>' . "\n";
print html '<meta charset="UTF-8">' . "\n";
print html '<!-- Page generated with https://github.com/YandereSkylar/waifu -->' . "\n";
print html '<title>' . $title . '</title>' . "\n";
print html '<link rel="shortcut icon" href="' . $favicon . '" />' . "\n";
print html '<link rel="stylesheet" href="./waifu.css">' . "\n";
print html '</head>' . "\n";
print html '<body>' . "\n";
print html '<div id="photos">' . "\n";

system('mkdir t');	# Creates a thumb directory if it doesn't already exist, preventing errors later on.

my @waifus;
my @lsjpg = qx/ls -1 s\/*.jpg/;
my @lspng = qx/ls -1 s\/*.png/;
my @lsgif = qx/ls -1 s\/*.gif/;

if ($ARGV[0] =~ /\-\-optipng/) {
	foreach (@lspng) {
		chomp($_);
		system('optipng ' . $ARGV[1] . ' "' . $_ . '"');
	}
}

unshift (@waifus, @lsjpg);
unshift (@waifus, @lspng);
unshift (@waifus, @lsgif);
@waifus = shuffle(@waifus);	# Comment out this line to display waifus in numeric order (0-F) by their SHA1 hash.
foreach (@waifus) {
	chomp($_);
	$_ =~ s/s\///;
	my @sha1 = qx/sha1sum "s\/$_"/;
	$sha1[0] =~ m/\.(\w{3})$/;
	my $filename = substr($sha1[0], 0, 12) . "." . $1;
	system('mv "s/' . $_ . '" ' . 's/' . $filename);
	system('convert s/' . $filename . ' -resize 400 t/' . $filename);
	print html '<a href="./s/' . $filename . '"><img src="./t/' . $filename . '" alt="waifu"></a>' . "\n";
}

print "Found " . scalar(@waifus) . " waifus: " . scalar(@lsjpg) . " jpgs, " . scalar(@lspng) . " pngs, " . scalar(@lsgif) . " gifs\n";

print html '</div>' . "\n";
print html '</body>' . "\n";
print html '</html>' . "\n";
close html;
