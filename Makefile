export PYTHONPATH=.

master_ttf/MehrNastaliqWeb-Regular.ttf: mehr.fea Mehr-Nastaliq.glyphs
	fontmake --master-dir . -g Mehr-Nastaliq.glyphs -o ttf

mehr.fea: mehr.fee anchors.fee rules.csv Mehr-Nastaliq.glyphs
	fee2fea -O0 Mehr-Nastaliq.glyphs mehr.fee > mehr.fea

clean:
	rm -f master_ttf/MehrNastaliqWeb-Regular.ttf mehr.fea anchors.fee rules.csv

anchors.fee: Mehr-Nastaliq.glyphs
	python3 dump-fee-anchors.py Mehr-Nastaliq.glyphs > anchors.fee

rules.csv: Mehr-Nastaliq.glyphs
	python3 dump-glyphs-rules.py  Mehr-Nastaliq.glyphs > rules.csv

test: master_ttf/MehrNastaliqWeb-Regular.ttf regressions.txt
	fontbakery check-profile -m FAIL -v ./gnipahs.py master_ttf/MehrNastaliqWeb-Regular.ttf

testproof: master_ttf/MehrNastaliqWeb-Regular.ttf regressions.txt
	gnipahs master_ttf/MehrNastaliqWeb-Regular.ttf regressions.txt

proof: master_ttf/MehrNastaliqWeb-Regular.ttf urdu-john.sil
	sile urdu-john.sil
