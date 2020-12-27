# Makefile for "fsqlite" library
#
# NOTE:
# The source code uses the C-Fortran interface features of Fortran 2003.
# This takes care of the naming and calling conventions.
#
# $Id: makefile,v 1.1 2008/05/04 13:23:56 arjenmarkus Exp $
#
include ../../config/config.mk
include ../../config/options.mk

LIBRARIES	=	libfodbc.a \

INC_ODBC	=	"/usr/lib/x86_64-linux-gnu"

#
# Use the correct macro for interfacing between Fortran and C and
# add the directory where the odbc header file can be found
#
#DEFINES	=	-DDBL_UNDERSCORE -I../../../odbc
DEFINES	=	-DLOWERCASE -I$(INC_ODBC)
#DEFINES	=	-I../../../odbc


all:	$(LIBRARIES)

libfodbc.a:	fodbc.o codbc.o
	ar r libfodbc.a fodbc.o codbc.o

fodbc.o:	fodbc.f90
	$(FC) -c $(FFLAGS) fodbc.f90

codbc.o:	codbc.c
	$(CC) -c $(CFLAGS) codbc.c $(DEFINES) -lodbc

clean:
	$(DELETE) *$(OBJEXT)
	$(DELETE) $(PROGRAMS)
	$(DELETE) *$(MODEXT)

