#!/bin/env perl
#
#

open FILE, "$ARGV[0]" or die "could not open $ARGV[0]: ".$!;
my @header;
open MAIN, ">", "$ARGV[0].trams" or die "could not open $ARGV[0].trams: ".$!;

while (<FILE>){
	next if($_ =~ /^##/);
	chomp;
	my @line = split/\t/, $_;
	if($line[0] =~ /^#/){
		@header = @line;
		splice(@header,0,9);
		print MAIN "Position\tRef";
		foreach my $sample (@header){
			print MAIN "\t$sample";
			open FILEOUT, ">", "$sample.trams" or die $!;
			print FILEOUT "Position\tRef\t$sample\n";
			close FILEOUT;
		}
		print MAIN "\n";
	}
	else{
		my $ref = $line[3];
		my $alt = $line[4];
		my $position = $line[1];
		print MAIN "$position\t$ref";
		my @temp = @line;
		splice(@temp, 0,9);
		foreach my $entry (@temp){
			if($entry =~ /^\./){
				print MAIN "\t$ref";
			}
			elsif($alt =~ /\,/){
				my @alts = split /,/, $alt;
				$entry =~ /^(\d+):.*/;
				my $value = $1 - 1;
				print MAIN "\t$alts[$value]";
			}
			else{
				print MAIN "\t$alt";
			}
		}
		print MAIN "\n";
		for(my $i = 0; $i < scalar(@temp); $i++){
			my $entry = $temp[$i];
			if($entry =~ /^\./){}
			else{
				#print "$position\t$header[$i]\n";
				open FILEOUT, ">>", "$header[$i].trams" or die $!;
				select FILEOUT;
				if($alt =~ /\,/){
                        	        my @alts = split /,/, $alt;
                                	$entry =~ /^(\d+):.*/;
                          	      my $value = $1 - 1;
                                	print "$position\t$ref\t$alts[$value]\n";
				}
				else{
					print "$position\t$ref\t$alt\n";
				}
				close FILEOUT;
				select STDOUT;
			}
		}	


	}

}	
