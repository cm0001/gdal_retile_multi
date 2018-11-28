#!/usr/bin/perl -w
use strict;

# perl script to create gdal_retile_multi_N_p copies and edit variables in each copy
#
# REQUIRED: one "starter/seed" file in a folder
#
# ex: "gdal_retile_multi_16_1"  located in folder  C:\somepath\16\
#
#      run this perl script: C:\perl create_gdal_retile_multi_copies.pl
#
#      files created in C:\somepath\16\copies folder
#  
#      ie. - C:\somepath\16\copies\gdal_retile_multi_16_1.py
#            C:\somepath\16\copies\gdal_retile_multi_16_2.py
#            ...
#            C:\somepath\16\copies\gdal_retile_multi_16_16.py
#

# INPUTS
my $no_of_copies = 16;
my $fn_pre = "C:\\somepath\\$no_of_copies\\copies\\gdal_retile_multi_" . $no_of_copies . "_";
my $fn_to_copy = "C:\\somepath\\$no_of_copies\\gdal_retile_multi_" . $no_of_copies . "_1.py";
# end INPUTS


for my $n (1 .. $no_of_copies) {

  open(FILE, $fn_to_copy) || die "File not found";
  my @lines = <FILE>;
  close(FILE);
  my @newlines;


  foreach(@lines) {
    $_ =~ s/thisProc=\d+/thisProc=$n/g;
    $_ =~ s/totalProcs=\d+/totalProcs=$no_of_copies/g;
    push(@newlines,$_);
    
  }

  my $fn = $fn_pre . $n . ".py";

  open(FILE, ">$fn") || die "File not found: $!";
  print FILE @newlines;
  close(FILE);

}
