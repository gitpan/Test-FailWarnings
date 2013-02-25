use 5.008001;
use strict;
use warnings;

package Test::FailWarnings;
# ABSTRACT: Add test failures if warnings are caught
our $VERSION = '0.001'; # VERSION

use Test::More 0.86;

$SIG{__WARN__} = sub {
    my $msg = shift;
    $msg = '' unless defined $msg;
    chomp $msg;
    my ($package, $filename, $line) = caller;
    if ( $msg !~ m/at .*? line \d/ ) {
        chomp $msg;
        $msg = "'$msg' at $filename line $line.";
    }
    else {
        $msg = "'$msg'";
    }
    my $builder = Test::More->builder;
    $builder->ok( 0, "Caught warning" )
        or $builder->diag("Warning was $msg");
};

1;


# vim: ts=4 sts=4 sw=4 et:

__END__

=pod

=head1 NAME

Test::FailWarnings - Add test failures if warnings are caught

=head1 VERSION

version 0.001

=head1 SYNOPSIS

Test file:

    use strict;
    use warnings;
    use Test::More;
    use Test::FailWarnings;

    ok( 1, "first test" );
    ok( 1 + "lkadjaks", "add non-numeric" );

    done_testing;

Output:

    ok 1 - first test
    not ok 2 - Caught warning
    #   Failed test 'Caught warning'
    #   at t/bin/main-warn.pl line 7.
    # Warning was 'Argument "lkadjaks" isn't numeric in addition (+) at t/bin/main-warn.pl line 7.'
    ok 3 - add non-numeric
    1..3
    # Looks like you failed 1 test of 3.

=head1 DESCRIPTION

This module hooks C<$SIG{__WARN__}> and converts warnings to L<Test::More>'s
C<fail()> calls.  It is designed to be used with C<done_testing>, when you
don't need to know the test count in advance.

Just as with L<Test::NoWarnings>, this does not catch warnings if other things
localize C<$SIG{__WARN__}>, as this is designed to catch I<unhandled> warnings.

=for Pod::Coverage method_names_here

=head1 SEE ALSO

=over 4

=item *

L<Test::NoWarnings> -- catches warnings and reports in an C<END> block.  Not (yet) friendly with C<done_testing>.

=item *

L<Test::Warn> -- test for warnings without triggering failures from this modules

=back

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/dagolden/test-failwarnings/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/dagolden/test-failwarnings>

  git clone git://github.com/dagolden/test-failwarnings.git

=head1 AUTHOR

David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
