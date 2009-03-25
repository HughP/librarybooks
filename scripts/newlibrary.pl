#!/usr/bin/perl
#
# Script to make a new library file.

use strict;
use warnings;
use File::Basename;

my $existingLibrary = $ARGV[0];
my $newLibrary = $ARGV[1];

die "please specify an existing and new library\n"
	unless (defined $existingLibrary && defined $newLibrary);

foreach my $ext (qw(m h))
{
	print "creating $newLibrary.$ext\n";

	my $existingFile = "Source/Libraries/$existingLibrary.$ext";
	my $newFile = "Source/Libraries/$newLibrary.$ext";

	die "$newLibrary.$ext already exists\n" if (-f $newFile);

	open IN_M_FILE, "<$existingFile"
		or die "$existingLibrary.$ext file does not exist\n";
	open OUT_M_FILE, ">$newFile";

	my $existingLibraryName = basename $existingLibrary;
	my $newLibraryName = basename $newLibrary;

	my $existingUnCamelName = unCamelCase($existingLibraryName);
	my $newUnCamelName = unCamelCase($newLibraryName);

	while (my $line = <IN_M_FILE>)
	{
		$line =~ s/$existingLibraryName/$newLibraryName/;
		$line =~ s/$existingUnCamelName/$newUnCamelName/;
		print OUT_M_FILE $line;
	}

	close OUT_M_FILE;
	close IN_M_FILE;

	system ("open $newFile") if ($ext eq 'm');
}

# Convert "CamelCaseNames" to "Camel Case Names".  Also deal with special
# cases like "Of" -> "of".
sub
unCamelCase
{
	my $s = shift;

	$s =~ s/\p{IsUpper}/ $&/g;
	$s =~ s/^ //;
	$s =~ s/ Of/ of/g;

	return $s;
}
