#!/usr/in/bash

for file in $(ls *.tsv)
do
	tar -zcvf $file.tar.gz $file
done
