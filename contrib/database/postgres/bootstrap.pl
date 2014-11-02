#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use File::Fetch;

my %nics = (
            arin    => { host => 'ftp.arin.net', name => 'arin' },
            apnic   => { host => 'ftp.apnic.net', name => 'apnic' },
            afrinic => { host => 'ftp.afrinic.net', name => 'afrinic'},
            ripe    => { host => 'ftp.ripe.net',    name => 'ripencc'}
    );

my @files = get_stats_files();

if (! @files) {
    print "No files to process found!\n";
    exit -1;
}

foreach (@files) {
    parse_file($_);
}
# delegated-arin-extended-latest
# delegated-ripencc-latest
# delegated-ripencc-extended-latest
# assigned-apnic-latest
# delegated-apnic-latest
# delegated-apnic-latest
# delegated-apnic-ipv6-assigned-latest
# delegated-apnic-latest
# delegated-apnic-extended-latest
# delegated-afrinic-latest
# delegated-afrinic-extended

my %cfg;

sub parse_file {
    my ($fn, $fh, @lines, %version, @summaries, @records);

    $fn = $_[0];

    $version{version}   = 0;
    $version{registry}  = 0;
    $version{serial}    = 0;
    $version{records}   = 0;
    $version{startdate} = 0;
    $version{enddate}   = 0;
    $version{UTCoffset} = 0;

    print 'Parsing ' . $fn . "\n";

    if (! open($fh, '<:encoding(UTF-8)', $fn)) {
        print "Failed to ope $fn: $!\n";
        return;
    }

    while (<$fh>) {
        chomp $_;
        $_ =~ s/#.*//;
        $_ =~ s/^\s+//;
        $_ =~ s/\s+$//;

        next unless length($_);
        push(@lines, $_);
    }

    close $fh;

    if (! @lines) {
        print "$fn" . ' is a blank file after removing comments/etc' . "\n";
        return;
    }

    # ... Gee I wonder how PERL didn't become the dominant language ...
    if ($lines[0] =~ /^\s?(2.*)\s?\|\s?(\w+)\s?\|\s?(\d+)\s?\|\s?(\d+)\s?\|\s?(\d+)?\s?\|\s?(\d+)?\s?\|\s?([+-]?\s?\d+)$/igs) {
        $version{version}   = $1;
        $version{registry}  = $2;
        $version{serial}    = $3;
        $version{records}   = $4;
        $version{startdate} = $5;
        $version{enddate}   = $6;
        $version{UTCoffset} = $7;

        #foreach (keys %version) {
        #   print $_ . ":" . $version{$_} . "\n";
        #}

    } else {
        print "File does not begin with a file header!\n";
        return;
    }

    shift @lines;

    while ($lines[0] =~ /^(\w+)\|\*\|(asn|ipv4|ipv6)\|\*\|(\d+)\|summary/igs) {
        my %tmp = ();
        $tmp{registry}  = $1;
        $tmp{type}      = $2;
        $tmp{count}     = $3;

        push(@summaries, \%tmp);
        shift @lines;
    }

    if (! @summaries) {
        print "File is invalid; it did not contain any summary lines.\n";
        return;
    }

    foreach (@lines) {
        my %tmp = ();
        my @rec = split(/\|/, $_, -1);

        if (@rec < 7) {
            print "Malformed record with not enough records encountered!\n";
            next;
        }

        $tmp{registry}  = $rec[0];
        $tmp{country}   = $rec[1];
        $tmp{type}      = $rec[2];
        $tmp{start}     = $rec[3];
        $tmp{value}     = $rec[4];
        $tmp{date}      = $rec[5];
        $tmp{status}    = $rec[6];

        splice @rec, 0, 7;

        if ( @rec) {
            $tmp{extension} = join('|', @rec);
        }

        print "Registry: '$tmp{registry}' Country: '$tmp{country}' Type: '$tmp{type}' Start: '$tmp{start}' Value: '$tmp{value}' Date: '$tmp{date}' Status: '$tmp{status}'\n";
        push(@records, \%tmp);
    }

    print "Processed records: " . $#records . "\n";
    return;
}
sub fetch_file {
    my ($uri, $ff, $where);

    $uri = $_[0];

    print "Attempting to retrieve: $uri\n";

    $ff = File::Fetch->new(uri => $uri);
    $where = $ff->fetch();

    if (! defined($where)) {
        return;
    }

    return $where;
}

sub fetch_retry_file {
    my $uri     = $_[0];
    my $where   = fetch_file($_[0]);

    if (! defined($where)) {
        print "Error retrieving file, retrying...\n";

        for (my $i = 0; $i < 5; $i++) {
            $where = fetch_file($uri);

            if ( defined($where)) {
                return $where;
            }
        }

        print "Failed to retrieve file.\n";
        return undef;
    }

    return $where;
}

sub get_stats_files {
    my (@files, $where, $key, $base, $extended, $uri);

    foreach $key (keys %nics) {
        $base       = 'delegated-' . $nics{$key}->{name} . '-latest';
        $extended   = 'delegated-' . $nics{$key}->{name} . '-extended-latest';

        if (-e $base) {
            print "Skipping $base as a local copy already exists...\n";
            push(@files, $base);

        } else {
            $uri = 'http://' . $nics{$key}->{host} .
                    '/pub/stats/' .
                    $nics{$key}->{name} .
                    '/' . $base;

            $where = fetch_retry_file($uri);

            if ( defined($where)) {
                push(@files, $where);
            }
        }

        if (-e $extended) {
            print "Skipping $extended as a local copy already exists...\n";
           push(@files, $extended);

        } else {
            $uri = 'http://' . $nics{$key}->{host} .
                    '/pub/stats/' .
                    $nics{$key}->{name} .
                    '/' . $extended;

            $where = fetch_retry_file($uri);

            if ( defined($where)) {
                push(@files, $where);
            }
        }
    }

    return @files;
}

sub parse_opts {
    my ($cfg)   = @_;
    my $ret     = 0;

    Getopt::Long::Configure("prefix_pattern=(-|\/)");

    $ret = GetOptions(  $cfg,
                        qw(
                            input|i=s
                            help|?|h
                        )
            );


}
