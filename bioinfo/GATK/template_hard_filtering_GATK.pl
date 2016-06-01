use strict;

open(IN,"IDS");
my @archivos = <IN>;
chomp(@archivos);
close(IN);

# Comando para correr gatk
my $gatk ="java -jar ";

# Reference usada para el alineamiento de los reads
my $reference = "";

# bed manifest file de los amplicones
my $design_bed = "";

#Creo el archivo con la informacion de coverage
foreach my $file(@archivos)
{
	system("mkdir $file");
}

#Parseo lo que me interesa
foreach my $file(@archivos)
{
	# Guardo los SNPs
	#######################################################
	qx($gatk -T SelectVariants -R $reference -V $file.vcf -L $design_bed -selectType SNP -o $file/raw_snps.vcf);

	# Guardo los INDELs
	#######################################################
	qx($gatk -T SelectVariants -R $reference -V $file.vcf -L $design_bed -selectType INDEL -o $file/raw_indels.vcf);

	# Aplico los filtros a los SNPs
	#######################################################
	qx($gatk -T VariantFiltration -R $reference -V $file/raw_SNPs.vcf --filterExpression "QD < 2.0" --filterName "QD" -o $file/filtered_SNPs_QD.vcf);

	qx($gatk -T VariantFiltration -R $reference -V $file/raw_SNPs.vcf --filterExpression "FS > 60.0" --filterName "FS" -o $file/filtered_SNPs_QD_FS.vcf);

	qx($gatk -T VariantFiltration -R $reference -V $file/filtered_SNPs_QD_FS.vcf --filterExpression "MQ < 40.0" --filterName "MQ" -o $file/filtered_SNPs_QD_FS_MQ.vcf);

	qx($gatk -T VariantFiltration -R $reference -V $file/filtered_SNPs_QD_FS_MQ.vcf --filterExpression "MQRankSum < -12.5" --filterName "MQRS" -o $file/filtered_SNPs_QD_FS_MQ_MQRS.vcf);

	qx($gatk -T VariantFiltration -R $reference -V $file/filtered_SNPs_QD_FS_MQ_MQRS.vcf --filterExpression "ReadPosRankSum < -8.0" --filterName "RPRS" -o $file/filtered_SNPs_QD_FS_MQ_MQRS_RPRS.vcf);

	# Borro archivos temporarios
	#######################################################
	qx(rm $file/raw_snps.vcf $file/filtered_SNPs_QD.vcf $file/filtered_SNPs_QD_FS.vcf $file/filtered_SNPs_QD_FS_MQ.vcf $file/filtered_SNPs_QD_FS_MQ_MQRS.vcf)

	# Aplico los filtros a los indels
	#######################################################
	qx($gatk -T VariantFiltration -R $reference -V $file/raw_INDELs.vcf --filterExpression "QD < 2.0" --filterName "QD" -o $file/filtered_INDELs_QD.vc);

	qx($gatk -T VariantFiltration -R $reference -V $file/filtered_INDELs_QD.vcf --filterExpression "FS > 200.0" --filterName "FS" -o $file/filtered_INDELs_QD_FS.vcf);

	qx($gatk -T VariantFiltration -R $reference -V $file/filtered_INDELs_QD_FS.vcf --filterExpression "ReadPosRankSum < -20.0" --filterName "RPRS" -o $file/filtered_INDELs_QD_FS_RPRS.vcf);

	# Borro archivos temporarios
	#######################################################
	qx(rm $file/filtered_INDELs_QD.vcf $file/filtered_INDELs_QD_FS.vcf);

	# Hago un merge de los SNPs y indels filtrados
	#######################################################
	qx($gatk -T CombineVariants -R $reference --genotypemergeoption PRIORITIZE -V:$file $file/filtered_INDELs_QD_FS_RPRS.vcf -V:$file $file/filtered_SNPs_QD_FS_MQ_MQRS_RPRS.vcf -o $file/union.vcf -priority $file,$file);

	# Borro archivos temporarios
	#######################################################
	qx(rm $file/filtered_INDELs_QD_FS_RPRS.vcf $file/filtered_SNPs_QD_FS_MQ_MQRS_RPRS.vcf);	
}


system("mkdir all_files");

foreach my $file(@archivos)
{
	system("cp $file/union.vcf all_files/$file.vcf");	
}
