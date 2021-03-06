#include "Homero.h"

configuration HomeroC
{
}
implementation
{
    components MainC;
    components LedsC;
    components new TimerMilliC();
    components new SensirionSht11C();
    components new HamamatsuS10871TsrC();
    components SerialActiveMessageC;
    components new SerialAMSenderC(AM_HOMEROMSG);
    components BroadcastPolicyC as DfrfPolicy;
    components new DfrfClientC(APPID_HOMERO, sizeof(HomeroMsg), sizeof(HomeroMsg), 15) as DfrfService;
    components ActiveMessageC as ActiveMessage;
    components HomeroP;

    HomeroP.Boot-> MainC;
    HomeroP.Leds -> LedsC;
    HomeroP.Timer -> TimerMilliC;
    HomeroP.Temperature -> SensirionSht11C.Temperature;
    HomeroP.Light -> HamamatsuS10871TsrC.Read;
    HomeroP.SplitControl -> SerialActiveMessageC;
    HomeroP.SerialSend -> SerialAMSenderC;
    HomeroP.DfrfSend -> DfrfService;
    HomeroP.DfrfReceive -> DfrfService;
    DfrfService.DfrfPolicy -> DfrfPolicy;
    HomeroP.AMPacket -> ActiveMessage;
}
