input=./src/main/
output=./output/tmp
name= $(shell cat ./src/conf/name)


hybrid=bsp exm lab mdl skp ue
modes-ang= $(addsuffix -ang,$(hybrid))
modes-lsg= $(addsuffix -lsg,$(hybrid))
modes-hyb= $(addsuffix -hyb,$(hybrid))
modes= $(modes-ang) $(modes-lsg) $(modes-hyb)

all: clean $(hybrid) $(modes) final

$(hybrid): $(wildcard dir/$@/)
	find ./src/$@/ ./closed/src/$@/ -name *.tex | sort -g| awk '{printf "\\input{%s}\n", $$1}' > ./src/tmp/$@.tex;\
	
test:$(wildcard dir/src/)
	find ./src/bsp/ ./src/mdl/ ./src/ue/ ./src/lab/ ./src/exm/ ./src/skp/ ./closed/src/bsp/ ./closed/src/mdl/ ./closed/src/ue/ ./closed/src/lab/ ./closed/src/exm/ ./closed/src/skp/ -name *.tex -mmin -20 | sort -g| awk '{printf "\\input{%s}\n", $$1}' > ./src/tmp/test.tex;\
	latexmk -pdf -synctex=1 -interaction=errorstopmode -output-directory='${output}' '${input}test.tex';\
	
$(modes): $(hybrid)
	latexmk -f -pdf -synctex=1 -interaction=nonstopmode -output-directory='${output}' '${input}$@.tex';\
	sleep 1s
	mv ${output}/*.pdf ./output/
final:
	mv ./output/bsp-ang.pdf ./output/bsp/$(name)-Beispiele-Angabe.pdf;\
	mv ./output/bsp-lsg.pdf ./output/bsp/'$(name)-Beispiele-Lösung'.pdf;\
	mv ./output/bsp-hyb.pdf ./output/bsp/$(name)-Beispiele-Hybrid.pdf;\
	mv ./output/exm-ang.pdf ./output/exm/'$(name)-Prüfung-Angabe'.pdf;\
	mv ./output/exm-lsg.pdf ./output/exm/'$(name)-Prüfung-Lösung'.pdf;\
	mv ./output/exm-hyb.pdf ./output/exm/'$(name)-Prüfung-Hybrid'.pdf;\
	mv ./output/lab-ang.pdf ./output/lab/$(name)-Labor-Angabe.pdf;\
	mv ./output/lab-lsg.pdf ./output/lab/'$(name)-Labor-Lösung'.pdf;\
	mv ./output/lab-hyb.pdf ./output/lab/$(name)-Labor-Hybrid.pdf;\
	mv ./output/mdl-ang.pdf ./output/mdl/'$(name)-Mündlich-Angabe'.pdf;\
	mv ./output/mdl-lsg.pdf ./output/mdl/'$(name)-Mündlich-Lösung'.pdf;\
	mv ./output/mdl-hyb.pdf ./output/mdl/'$(name)-Mündlich-Hybrid'.pdf;\
	mv ./output/skp-ang.pdf ./output/skp/$(name)-Skriptum.pdf;\
	mv ./output/ue-ang.pdf ./output/ue/'$(name)-Übung-Angabe'.pdf;\
	mv ./output/ue-lsg.pdf ./output/ue/'$(name)-Übung-Lösung'.pdf;\
	mv ./output/ue-hyb.pdf ./output/ue/'$(name)-Übung-Hybrid'.pdf;\

clean: 
	rm -f ${output}/*.{ps,pdf,fls,fdb,log,aux,out,dvi,bbl,blg,toc,synctex.gz}*
	rm -f ./src/tmp/*