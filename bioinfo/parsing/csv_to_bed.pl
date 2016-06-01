use strict;

open(IN,$ARGV[0]);
while(my $line =<IN>)
{
	chomp($line);
	my @splitted = split("\t",$line);
	my $gene = $splitted[0];
	my $transcripto = $splitted[1];
	my $exon_start_bp = $splitted[2];
	my $exon_end_bp = $splitted[3];
	my $cDNA_start = $splitted[4];
	my $cDNA_end = $splitted[5];
	my $CDS_start = $splitted[6];
	my $CDS_end = $splitted[7];
	my $chr = $splitted[8];
	if($cDNA_start != "" && $CDS_start != "")
	{
		print "$chr\t$exon_start_bp\t$exon_end_bp\t$gene-$transcripto\n";
	}
}
close(IN);
