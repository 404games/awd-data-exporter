CURRENT_DIR = $(shell pwd)
LIBS = $(shell ls libs)
LIB_PATH = $(foreach d, $(LIBS), -library-path+=./libs/$d)
SRC_PATH = -source-path+=./src/
MAIN = src/io/nfg/Main.as
OPT = -swf-version=27
CONSTS = -define+=CONFIG::RELEASE,false

build: build-desktop
run: run-desktop

build-desktop:
	amxmlc -debug=true $(LIB_PATH) $(SRC_PATH) -output=build/app.swf $(OPT) $(CONSTS) $(MAIN)

run-desktop:
	adl app.xml
