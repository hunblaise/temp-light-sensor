import static java.lang.System.out;
import net.tinyos.packet.*;
import net.tinyos.message.*;
import net.tinyos.util.PrintStreamMessenger;
import java.io.*;

class Homero implements MessageListener{
	
	private MoteIF moteIF;
		
	public Homero(MoteIF moteIF){
		this.moteIF=moteIF;
		this.moteIF.registerListener(new HomeroMsg(),this);
	}
	
	public void messageReceived(int dest_addr,Message msg){
		if (msg instanceof HomeroMsg) {
			HomeroMsg homeroData = (HomeroMsg)msg;
      out.println("Temperature: " + (-39.4+(0.01*(double)homeroData.get_temp())));
	    out.println("Light: " + homeroData.get_light());
	    out.println("Src: " + homeroData.get_src());
		}
	}
	
	public static void main(String[] args) throws Exception 
	{
		PhoenixSource phoenix = null;
		MoteIF mif = null;
		
		if( args.length == 0 ){
			phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
		} else if( args.length == 2 && args[0].equals("-comm") ) {
			phoenix = BuildSource.makePhoenix(args[1], PrintStreamMessenger.err);
		} else {
			System.err.println("usage: java Homero [-comm <source>]");
			System.exit(1);
		}
		mif = new MoteIF(phoenix);
		Homero app= new Homero(mif);
	}
}

	

	
	
	
