
OCAMLLIB := $(shell ocamlc -where)
OCAMLMKLIB_FLAGS= -lstdc++
CPPFFIDIR=$(shell ocamlfind query cppffigen)
OCAMLFIND=ocamlfind
CPPFFIGEN=$(OCAMLFIND) cppffigen/cppffigen
FLINTDIR=/home/chet/Hack/Camlp5/src/flint/flint2


RESULT=ocaml_flint
INCLUDES=-I. -I$(CPPFFIDIR) -I$(OCAMLLIB) \
	-I$(FLINTDIR) -I$(FLINTDIR)/build \
	-I/usr/local/include -I/usr/local/include
DEBUG=-g2
#DEBUG=-g2 -O2
CXXFLAGS += $(INCLUDES) -std=gnu++11 -fno-rtti  -pedantic -Wall -funroll-loops -mpopcnt $(DEBUG)

PACKS = result,threads,oUnit

MLI= $(RESULT).mli
ML=  $(RESULT).ml some_code.ml
CMO= $(patsubst %.ml,%.cmo, $(ML))
CMX= $(patsubst %.ml,%.cmx, $(ML))
CMI= $(patsubst %.ml,%.cmi, $(ML))
OBJECTS = $(CMO) $(CMX) $(CMI)

all: $(RESULT).cma $(RESULT).cmxa dll$(RESULT).so flint_tests.byte

test: flint_tests.byte
	mkdir -p _build
	./flint_tests.byte

LINKFLAGS= -cclib -L. \
	-cclib  -L$(FLINTDIR) \
	-cclib -Wl,-rpath=$(FLINTDIR) \
	-cclib -L/usr/local/lib \
	-cclib -lflint \
	-cclib -lmpfr \
	-cclib -lgmp \
	-cclib -lm \
	-cclib -lpthread

flint_tests.byte: $(RESULT).cma flint_tests.cmo
	ocamlfind ocamlc -custom -thread -package $(PACKS) -linkpkg -linkall -o flint_tests.byte $(RESULT).cma $(LINKFLAGS)  flint_tests.cmo

$(RESULT).cma $(RESULT).cmxa dll$(RESULT).so: $(OBJECTS) $(RESULT)_stubs.o flintstubs.o
	    ocamlmklib -verbose -o $(RESULT) $(CMO) $(CMX) $(RESULT)_stubs.o flintstubs.o $(OCAMLMKLIB_FLAGS)

flint_tests.cmo : flint_tests.ml
	ocamlfind ocamlc -thread -package $(PACKS) -c flint_tests.ml

$(CMO) $(CMI): $(ML)
	ocamlfind ocamlc -thread -package $(PACKS) -c $(MLI)
	ocamlfind ocamlc -thread -package $(PACKS) -c $(ML)

$(CMX): $(ML) $(CMI)
	ocamlfind ocamlopt -thread -package $(PACKS) -c $(ML)

$(RESULT).ml $(RESULT).mli $(RESULT)_stubs.cc: flint-ffi.idl
	$(CPPFFIGEN) --output ml < flint-ffi.idl > $(RESULT).ml
	$(CPPFFIGEN) --output mli < flint-ffi.idl > $(RESULT).mli
	$(CPPFFIGEN) --output cpp < flint-ffi.idl > $(RESULT)_stubs.cc

$(RESULT)_stubs.o: $(RESULT)_stubs.cc
	g++ -c -fPIC ${CXXFLAGS} -DPIC -o $(RESULT)_stubs.o $(RESULT)_stubs.cc

flintstubs.o: flintstubs.cc
	g++ -c -fPIC ${CXXFLAGS} -DPIC -o $@ $<

clean::
	rm -rf flint_tests.byte \
		META *.a *.cma *.cmi *.cmo *.cmx *.cmxa *.o *.so *.log *.cache _build \
		$(RESULT).ml $(RESULT).mli $(RESULT).top \
		$(RESULT)_stubs.c $(RESULT)_stubs.c.ORIG $(RESULT)_stubs.cc
