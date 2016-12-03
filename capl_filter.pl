# CAPL filter for Doxygen
#
# ISC License:
# Copyright (c) 2016, Bretislav Rychta
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;

my $input = $ARGV[0];
my $includes = 0;
my $variables = 0;
my $line;

main();
exit(0);

sub main
{
    open file_handler, "<$input" or die "Can't open $input for reading: $!";

    foreach my $line (<file_handler>)
    {
        #remove include and brackets
        if ($line =~ /^includes/)
        {
            $includes = 1;
            $line =~ s/includes//;
        }
        $line =~ s/#include.*//;
        if ($includes == 1)
        {
            if ($line =~ /\{/)
            {
                $line =~ s/\{//;
            }
            if ($line =~ /\}/)
            {
                $line =~ s/\}//;
                $includes = 0;
            }
        }

        #remove pragma
        $line =~ s/#pragma.*//;

        #remove variables and brackets
        if ($line =~ /^variables/)
        {
            $variables = 1;
            $line =~ s/variables//;
        }
        if ($variables > 0)
        {
            if ($line =~ /\{/)
            {
                if ($variables == 1)
                {
                    $line =~ s/\{//;
                }

                $variables = $variables + 1;
            }
            if ($line =~ /\}/)
            {
                $variables = $variables - 1;

                if ($variables == 1)
                {
                    $line =~ s/\}//;
                    $variables = 0;
                }
            }
        }

        #replace "on xyz abc" => "on_xyz_abc()"
        if($line =~ /^[Oo]n\s(\S+)\s(\S+)/)
        {
            $line =~ s/::/_/g; #replace "::" => "_"
            $line =~ s/\*/asterisk/; #replace "*" => "asterisk"
            $line =~ s/^[Oo]n\s(\S+)\s(\S+)/on_$1_$2\(\)/;
        }

        #replace "on xyz" => "on_xyz()"
        $line =~ s/^[Oo]n\s(\S+)/on_$1\(\)/;

        #replace "testcase xyz" => "testcase_xyz"
        $line =~ s/^testcase\s/testcase_/;

        print $line;
    }

    close file_handler;
}
