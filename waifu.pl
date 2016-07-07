#!/usr/bin/perl
#
#	Waifu Page Generator
#	Lists jpg, png, and gif files in a directory, builds an html page to display them
#	https://github.com/YandereSkylar/waifu
#
use List::Util 'shuffle';
use POSIX qw(ceil);
use strict;

my $title = "waifu4laifu";	# Page title
my $favicon = "../favicon.ico";	# Path to favicon

print "Waifu Page Generator  Copyright (C) 2016  Skylar Gasai\n";
print "This program comes with ABSOLUTELY NO WARRANTY.\n";
print "This is free software, and you are welcome to redistribute it\n";
print "under certain conditions; see LICENSE for details.\n\n";

print "Run with --optipng=[1-7] if you want to compress PNGs before hashing.\n";
print "Run with --page=[number] if you want to [number] waifus per page instead of all on one.\n\n";

system('mkdir t');	# Creates a thumb directory if it doesn't already exist, preventing errors later on.

my @waifus;
my @lsjpg = qx/ls -1 s\/*.jpg/;
my @lspng = qx/ls -1 s\/*.png/;
my @lsgif = qx/ls -1 s\/*.gif/;

my $optipng = 0;
my $page = 0;

foreach (@ARGV) {	# Check for any arguments
	if ($_ =~ /\-\-optipng=\d/) {
		$_ =~ m/(\d)/;
		$optipng = $1;
		print "Optimizing PNGs at level " . $optipng . "\n";
	}
	if ($_ =~ /\-\-page=\d+/) {
		$_ =~ m/(\d+)/;
		$page = $1;
		print "Splitting waifus into " . $page . " per page.\n";
	}
}

if ($optipng > 0) {	# Optimize PNGs
	foreach (@lspng) {
		chomp($_);
		system('optipng -o' . $optipng . ' "' . $_ . '"');
	}
}

unshift (@waifus, @lsjpg);
unshift (@waifus, @lspng);
unshift (@waifus, @lsgif);
@waifus = shuffle(@waifus);

# Build the waifu page
if ($page == 0) {
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

	print "\nFound " . scalar(@waifus) . " waifus: " . scalar(@lsjpg) . " jpgs, " . scalar(@lspng) . " pngs, " . scalar(@lsgif) . " gifs\n";

	print html '</div>' . "\n";
	print html '</body>' . "\n";
	print html '</html>' . "\n";
	close html;
} else {
	my $i = 1;
	my $p = 1;
	my $totalpages = ceil(scalar(@waifus) / $page);
	print "Found " . scalar(@waifus) . " waifus: " . $totalpages . " pages at " . $page . " waifus per page: " . scalar(@lsjpg) . " jpgs, " . scalar(@lspng) . " pngs, " . scalar(@lsgif) . " gifs\n";

	# Build the pages
	while ($p <= $totalpages) {
		$i = 1;
		if ($p == 1) {
			open (html, ">", "index.html");
		} else {
			open (html, ">", $p . ".html");
		}
		print html '<!doctype html>' . "\n";
		print html '<html>' . "\n";
		print html '<head>' . "\n";
		print html '<meta charset="UTF-8">' . "\n";
		print html '<!-- Page generated with https://github.com/YandereSkylar/waifu -->' . "\n";
		print html '<title>' . $title . ': ' . $p . '</title>' . "\n";
		print html '<link rel="shortcut icon" href="' . $favicon . '" />' . "\n";
		print html '<link rel="stylesheet" href="./waifu.css">' . "\n";
		print html '</head>' . "\n";
		print html '<body>' . "\n";
		print html '<div id="photos">' . "\n";
		while ($i <= $page and @waifus) {	
			my $image = shift @waifus;
			chomp($image);
			$image =~ s/s\///;
			my @sha1 = qx/sha1sum "s\/$image"/;
			$sha1[0] =~ m/\.(\w{3})$/;
			my $filename = substr($sha1[0], 0, 12) . "." . $1;
			system('mv "s/' . $image . '" ' . 's/' . $filename);
			system('convert s/' . $filename . ' -resize 400 t/' . $filename);
			print html '<a href="./s/' . $filename . '"><img src="./t/' . $filename . '" alt="waifu"></a>' . "\n";
			$i++;
		}
		print html '</div>' . "\n";
		print html '</body>' . "\n";
		print html '</html>' . "\n";
		close html;
		$p++;
	}
}
