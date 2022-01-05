#!/bin/sh

cd ../TestResults || { echo "no ../TestResults/ ?"; exit 1; }

for f in *.trx
do
	b=${f%.trx}

	xsltproc -o $b.html ../Batch/make-html.xsl $f
done
