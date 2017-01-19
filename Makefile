input=./src/main/
output=./output
name= $(shell cat ./src/conf/name)


hybrid=bsp exm lab mdl skp ue
modes-ang= $(addsuffix -ang,$(hybrid))
modes-lsg= $(addsuffix -lsg,$(hybrid))
modes-hyb= $(addsuffix -hyb,$(hybrid))
modes= $(modes-ang) $(modes-lsg) $(modes-hyb)

all: clean $(hybrid) $(modes)

$(hybrid): $(wildcard dir/$@/)
	find ./src/$@/ ./closed/src/$@/ -name *.tex | sort -g| awk '{printf "\\input{%s}\n", $$1}' > ./src/tmp/$@.tex
	
test:$(wildcard dir/src/)
	find ./src/bsp/ ./src/mdl/ ./src/ue/ ./src/lab/ ./src/exm/ ./src/skp/ ./closed/src/bsp/ ./closed/src/mdl/ ./closed/src/ue/ ./closed/src/lab/ ./closed/src/exm/ ./closed/src/skp/ -name *.tex -mmin -20 | sort -g| awk '{printf "\\input{%s}\n", $$1}' > ./src/tmp/test.tex;\
	latexmk -pdf -synctex=1 -interaction=errorstopmode -output-directory='${output}' '${input}test.tex';\
	
$(modes): $(hybrid)
	latexmk -f -pdf -synctex=1 -interaction=nonstopmode -output-directory='${output}' '${input}$@.tex'; \
	mv ./output/$@.pdf ./output/bsp/$(name)-$@.pdf;\

clean: 
	rm -f ${output}/*.{ps,pdf,fls,fdb,log,aux,out,dvi,bbl,blg,toc,synctex.gz}*
	rm -f ./src/tmp/*