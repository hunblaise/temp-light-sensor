#include "Homero.h"

module HomeroP
{
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli>;
    uses interface Read<uint16_t> as Temperature;
    uses interface Read<uint16_t> as Light;
    uses interface SplitControl;
    uses interface AMSend as SerialSend;
    uses interface AMPacket;
    uses interface DfrfSend;
    uses interface DfrfReceive;
}
implementation
{
    bool busy = FALSE;
    nx_uint16_t temp;
    nx_uint16_t light;
    message_t pkt;
    
    task void sendPacket()
    {
        HomeroMsg data;            
        call Leds.led1Toggle();
            
        data.temp = temp;
        data.light = light;
        data.src = call AMPacket.address() & 0xff;
            
        call DfrfSend.send(&data);
    }
    
    event void Boot.booted()
    {
        call SplitControl.start();
    }
    
    event void SplitControl.startDone(error_t err)
    {
        if (err == SUCCESS)
        {
            call Timer.startPeriodic(1000);
        }
        else
        {
            call SplitControl.start();
        }
    }
    
    event void SplitControl.stopDone(error_t err) {}
    
    event void Timer.fired()
    {
        call Temperature.read();
        call Light.read();
    }
    
    event void Temperature.readDone(error_t result, uint16_t readTemperature)
    {
        if(result == SUCCESS && !busy)
        {
            HomeroMsg* btrpkt = (HomeroMsg*) call SerialSend.getPayload(&pkt, sizeof(HomeroMsg));
            btrpkt->temp = readTemperature;

            if (call SerialSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(HomeroMsg))==SUCCESS)
            {
                busy = TRUE;
            }

            if (readTemperature > TEMPERATURE_TRESHOLD)
            {
                post sendPacket();
            }
            temp = readTemperature;
        }
    }
    
    event void Light.readDone(error_t result, uint16_t readLight)
    {     
        if (result == SUCCESS && !busy)
        {
            HomeroMsg* btrpkt = (HomeroMsg*) call SerialSend.getPayload(&pkt, sizeof(HomeroMsg));
            btrpkt->light = readLight;

            if (call SerialSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(HomeroMsg)) == SUCCESS)
            {
                busy = TRUE;
            }

            if (readLight > LIGHT_TRESHOLD)
            {
                post sendPacket();
            }
            light = readLight;
        }
    }
    
    event void SerialSend.sendDone(message_t* msg, error_t error)
    {
        busy = FALSE;
    }
    
    event bool DfrfReceive.receive(void* packet)
    {
        HomeroMsg *data = packet;
        call Leds.led2Toggle();
            
        if (call SerialSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(HomeroMsg)) == SUCCESS)
        {
            busy = TRUE;
        }

        return TRUE;
    }
        
    event void DfrfSend.sendDone(void *data)
    {
        call Leds.led0Toggle();
    }

}
