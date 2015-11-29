#ifndef TEMPERATURE_H
#define TEMPERATURE_H

#include "message.h"

typedef nx_struct temp_light_packet
{
	nx_uint16_t src;
	nx_uint8_t unique_delimiter[0];	// zero-sized field marking the end of the unique section
	nx_uint16_t temp;
        nx_uint16_t light;

} temp_light_packet_t;

enum {
  APPID_COUNTER = 0x77,
};

#endif
