SHELL := /bin/bash

out.jl: in.json
	jq -r '.[]' $< > temp_input.txt
	parallel -n1 -j1 --ungroup ./generate-completions 127.0.0.1:24498 "{}" :::: temp_input.txt > $@.tmp
	rm temp_input.txt
	mv -f $@.tmp $@

out.json: out.jl
	printf "[" > $@.tmp
	tr "\n" "," < $< >> $@.tmp
	printf "]\n" >> $@.tmp
	sed -i '' -e '$$s/,]$$/]/' $@.tmp
	mv -f $@.tmp $@
