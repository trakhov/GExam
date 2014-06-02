#!/bin/bash

ruby exam_all.rb

for file in tex/$1/*tex; do
	latex -output-format pdf -output-directory output "$file"
done

rm output/*{aux,gz,out,log}

exit 0
