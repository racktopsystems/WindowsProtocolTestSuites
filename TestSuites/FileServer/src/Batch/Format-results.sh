#!/bin/sh

cd ../TestResults || { echo "no ../TestResults/ ?"; exit 1; }

for f in *.trx
do
	b=${f%.trx}

	if [ ! -e $b.html ] ; then
		xsltproc -o $b.html ../Batch/make-html.xsl $f
		touch -r $f $b.html
	fi
done
