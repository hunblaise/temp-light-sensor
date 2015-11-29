#ifndef HOMERO_H
#define HOMERO_H

#include "message.h"

enum{
	AM_HOMEROMSG = 6,
	TEMPERATURE_TRESHOLD = 30,
	LIGHT_TRESHOLD = 1000
};

typedef nx_struct HomeroMsg {
	nx_uint16_t src;
	nx_uint8_t unique_delimiter[0];	// zero-sized field marking the end of the unique section
	nx_uint16_t temp;
	nx_uint16_t light;
} HomeroMsg;

enum {
  APPID_HOMERO = 0x77,
};

#endif 
