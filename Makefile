COMPONENT=HomeroC
BUILD_EXTRA_DEPS = HomeroMsg.java Homero.class
CLEAN_EXTRA = *.class HomeroMsg.java
CFLAGS += -DLOW_POWER_LISTENING
CFLAGS += -DLPL_DEF_LOCAL_WAKEUP=512
CFLAGS += -DLPL_DEF_REMOTE_WAKEUP=512
CFLAGS += -DDELAY_AFTER_RECEIVE=20
CFLAGS += -I$(TOSDIR)/lib/Dfrf

HomeroMsg.java: Homero.h
	mig java -target=null -java-classname=HomeroMsg Homero.h HomeroMsg -o $@

HomeroMsg.class: HomeroMsg.java
	javac HomeroMsg.java

Homero.class: Homero.java
	javac Homero.java
	
include $(MAKERULES)

