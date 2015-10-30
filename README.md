# CAPL-filter-for-Doxygen
Perl script that allows use Doxygen for programs written in CAPL (CAN Access Programming Language used in Vector CANoe and CANalyzer)

Install Perl on your computer and specify in your Doxyfile:

    EXTENSION_MAPPING      = can=c \
                             cin=c

    EXTRACT_ALL            = YES

    FILE_PATTERNS          = *.can \
                             *.cin
    
    RECURSIVE              = YES

    INPUT_FILTER           = capl_filter.pl
