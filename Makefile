SRC = Application/Main.cpp IO/IO.cpp DSP/DSP.cpp Library/AIS.cpp DSP/Model.cpp Library/Utilities.cpp DSP/Demod.cpp Device/RTLSDR.cpp Device/AIRSPYHF.cpp Device/AIRSPY.cpp Device/FileRAW.cpp Device/FileWAV.cpp Device/SDRPLAY.cpp Device/RTLTCP.cpp Device/HACKRF.cpp
OBJ = Main.o IO.o DSP.o AIS.o Model.o Utilities.o Demod.o RTLSDR.o AIRSPYHF.o AIRSPY.o FileRAW.o FileWAV.o SDRPLAY.o RTLTCP.o HACKRF.o

CC = gcc
override CFLAGS += -Ofast -std=c++11
override LFLAGS += -lstdc++ -lpthread -lm -o AIS-catcher

CFLAGS_RTL = -DHASRTLSDR $(shell pkg-config --cflags librtlsdr)
CFLAGS_AIRSPYHF = -DHASAIRSPYHF $(shell pkg-config --cflags libairspyhf)
CFLAGS_AIRSPY = -DHASAIRSPY $(shell pkg-config --cflags libairspy)
CFLAGS_SDRPLAY = -DHASSDRPLAY
CFLAGS_HACKRF = -DHASHACKRF $(shell pkg-config --cflags libhackrf) -I /usr/include/libhackrf/

LFLAGS_RTL = $(shell pkg-config --libs librtlsdr)
LFLAGS_AIRSPYHF = $(shell pkg-config --libs libairspyhf)
LFLAGS_AIRSPY = $(shell pkg-config --libs libairspy)
LFLAGS_SDRPLAY = -lsdrplay_api 
LFLAGS_HACKRF = $(shell pkg-config --libs libhackrf)

all: lib
	$(CC) $(OBJ) $(LFLAGS_AIRSPYHF) $(LFLAGS_AIRSPY) $(LFLAGS_RTL) $(LFLAGS) $(LFLAGS_RTLTCP) $(LFLAGS_HACKRF)

rtl-only: lib-rtl
	$(CC) $(OBJ) $(LFLAGS) $(LFLAGS_RTL)

airspyhf-only: lib-airspyhf
	$(CC) $(OBJ) $(LFLAGS) $(LFLAGS_AIRSPYHF)

airspy-only: lib-airspy
	$(CC) $(OBJ) $(LFLAGS) $(LFLAGS_AIRSPY)

sdrplay-only: lib-sdrplay
	$(CC) $(OBJ) $(LFLAGS) $(LFLAGS_SDRPLAY)

hackrf-only: lib-hackrf
	$(CC) $(OBJ) $(LFLAGS) $(LFLAGS_HACKRF)

lib:
	$(CC) -c $(SRC) $(CFLAGS) $(CFLAGS_AIRSPYHF) $(CFLAGS_AIRSPY) $(CFLAGS_RTL) $(CFLAGS_RTLTCP) $(CFLAGS_HACKRF)

lib-rtl:
	$(CC) -c $(SRC) $(CFLAGS) $(CFLAGS_RTL)

lib-airspyhf:
	$(CC) -c $(SRC) $(CFLAGS) $(CFLAGS_AIRSPYHF)

lib-airspy:
	$(CC) -c $(SRC) $(CFLAGS) $(CFLAGS_AIRSPY)

lib-sdrplay:
	$(CC) -c $(SRC) $(CFLAGS) $(CFLAGS_SDRPLAY)

lib-hackrf:
	$(CC) -c $(SRC) $(CFLAGS) $(CFLAGS_HACKRF)

clean:
	rm *.o 
	rm AIS-catcher

install:
	cp AIS-catcher /usr/local/bin/AIS-catcher
