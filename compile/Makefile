filename=./../src/main
output=./../output

exam.tex: $(wildcard dir/../src/)
	find ./../src/bsp/test  -name *.tex | awk '{printf "\\input{%s}\n", $$1}' > ./../src/exam.tex

exercise.tex: $(wildcard dir/../src/)
	find ./../src/bsp/buch -name *.tex | awk '{printf "\\input{%s}\n", $$1}' > ./../src/exercise.tex

mdl.tex: $(wildcard dir/../src/)
	find  ./../src/mdl -name *.tex | awk '{printf "\\input{%s}\n", $$1}' > ./../src/mdl.tex

pdflatex: exam.tex exercise.tex mdl.tex
	pdflatex -synctex=1 -interaction=nonstopmode -output-directory='${output}' '${filename}.tex'
	mv ./../output/main.pdf ./../output/VU-351.019-Elektrodynamik.pdf

free: exercise.tex mdl.tex
	pdflatex -synctex=1 -interaction=nonstopmode -output-directory='${output}' './../src/free.tex'
	mv ./../output/free.pdf ./../output/VU-351.019-Elektrodynamik-Angaben-Buch-Mündlich.pdf
	
inputstest.tex: $(wildcard dir/../src/)
	find ./../src/bsp ./../src/mdl -name *.tex -mmin -20 | awk '{printf "\\input{%s}\n", $$1}' > ./../src/inputstest.tex
			
testpdflatex: inputstest.tex
	pdflatex -synctex=1 -interaction=errorstopmode -output-directory='${output}' './../src/test.tex'
	
latex:
	latex -synctex=1 -halt-on-error -interaction=errorstopmode -output-directory='${output}' '${filename}.tex'
pdf: ps
	ps2pdf ${filename}.ps

pdf-print: ps
	ps2pdf -dColorConversionStrategy=/LeaveColorUnchanged -dPDFSETTINGS=/printer ${filename}.ps

text: html
	html2text -width 100 -style pretty ${filename}/${filename}.html | sed -n '/./,$$p' | head -n-2 >${filename}.txt

ps:	dvi
	dvips -t letter ${filename}.dvi

dvi:
	latex ${filename}
	bibtex ${filename}||true
	latex ${filename}
	latex ${filename}

read:
	evince ${filename}.pdf &

aread:
	acroread ${filename}.pdf

clean:
	rm -f ${output}/main.{ps,pdf,log,aux,out,dvi,bbl,blg,toc,synctex.gz}
	rm ${output}/texput.log