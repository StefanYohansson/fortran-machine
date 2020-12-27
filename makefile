# vim: noexpandtab: tabstop=4:

FLIBS=flibs-0.9/flibs/src
LIBSQLITE3=$(shell find /usr -name libsqlite3.a -print -quit)
LIBODBC=$(shell find /usr -name libodbc.a -print -quit)

FORTRAN=gfortran
FORTRANFLAGS=-ldl -lfcgi -pthread -Wl,-rpath -Wl,/usr/lib

ifndef $(LIBSQLITE3)
FORTRANFLAGS=-ldl -lfcgi -lsqlite3 -pthread -Wl,-rpath -Wl,/usr/lib
endif

ifndef $(LIBODBC)
FORTRANFLAGS=-ldl -lfcgi -lltdl -lodbc -pthread -Wl,-rpath -Wl,/usr/lib
endif

OBJECTS = \
	queries.o \
	jade.o \
	string_helpers.o \
	fodbc.o \
	cgi_protocol.o \
	fcgi_protocol.o \
	codbc.o

fortran_fcgi: fortran_fcgi.f90 $(OBJECTS)
	$(FORTRAN) -o $@ $^ $(LIBODBC) $(FORTRANFLAGS)

queries.o: queries.f90 string_helpers.o fodbc.o
	$(FORTRAN) -c $<

jade.o: jade.f90 string_helpers.o
	$(FORTRAN) -c $<

string_helpers.o: string_helpers.f90
	$(FORTRAN) -c $<

cgi_protocol.o: $(FLIBS)/cgi/cgi_protocol.f90
	$(FORTRAN) -c $<

fcgi_protocol.o: $(FLIBS)/cgi/fcgi_protocol.f90
	$(FORTRAN) -c $<

fodbc.o: $(FLIBS)/odbc/fodbc.f90
	$(FORTRAN) -c $<

codbc.o: $(FLIBS)/odbc/codbc.c
	cd $(FLIBS)/odbc && make codbc.o >/dev/null
	cp $(FLIBS)/odbc/codbc.o .

fsqlite.o: $(FLIBS)/sqlite/fsqlite.f90
	$(FORTRAN) -c $<

csqlite.o: $(FLIBS)/sqlite/csqlite.c
	cd $(FLIBS)/sqlite && make csqlite.o >/dev/null
	cp $(FLIBS)/sqlite/csqlite.o .

clean:
	rm -f -v fortran_fcgi *.o *.mod $(FLIBS)/sqlite/*.o

.PHONY: clean
