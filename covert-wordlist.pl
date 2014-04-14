#!/usr/bin/perl

$line_count = 0;
print "char *diceware_wordlist[] = {\n";
while(<STDIN>) {
  if (/(\d\d\d\d\d)\s*([^\s]*)/) {
    $line_count++;
    print "  \"$2\",\n";
  }
}
print "};\n";

print STDERR "Output $line_count lines\n"
