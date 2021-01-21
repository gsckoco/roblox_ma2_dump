local info = {
	modules = {
		mainModule = {
			name = "Main Module";
			usedChannels = {1,2,3,4,5,6,7,8,9,10,11,12,13};
			attributes = {
				{attType="SHUTTER/MAINTENANCE"; pBreak=1; coarse=1; fine=nil; min = 0; max = 255; default=212; attribute = "shutter"; capabilities = {
					{
						dmxRange = {0,20};
						channelType = "SHUTTERSTROBE";
						shutterEffect = "closed";
					};
					{
						dmxRange = {21,39};
						channelType = "SHUTTERSTROBE";
						shutterEffect = "open";
					};
					{
						dmxRange = {40,80};
						channelType = "SHUTTERSTROBE";
						shutterEffect = "strobe";
						speedStart = 1; -- Hz
						speedEnd = 20; -- Hz
					};
					{
						dmxRange = {81,89};
						channelType = "SHUTTERSTROBE";
						shutterEffect = "dummy";
					};
					{
						dmxRange = {90,130};
						channelType = "SHUTTERSTROBE";
						shutterEffect = "randomStrobe";
						speedStart = 1; -- Hz
						speedEnd = 20; -- Hz
					};
					{
						dmxRange = {131,199};
						channelType = "MAINTENANCE";
						hold = 5;
						comment = "Reset";
					};
					{
						dmxRange = {200,225};
						channelType = "MAINTENANCE";
						hold = 2;
						comment = "Lamp on";
					};
					{
						dmxRange = {226,255};
						channelType = "MAINTENANCE";
						hold = 2;
						comment = "Lamp off";
					};
				}};
				{attType="DIM"; pBreak=1; coarse=2; fine=nil; min = 0; max = 255; default=0; attribute = "intensity"};
				{attType="Color"; pBreak=1; coarse=3; fine=nil; min = 0; max = 255; default=0; attribute = "COLORCYAN"};
				{attType="Color"; pBreak=1; coarse=4; fine=nil; min = 0; max = 255; default=0; attribute = "COLORMAGENTA"};
				{attType="Color"; pBreak=1; coarse=5; fine=nil; min = 0; max = 255; default=0; attribute = "COLORYELLOW"};
				{attType="Color"; pBreak=1; coarse=6; fine=nil; min = 0; max = 255; default=0; attribute = "COLORTEMP"};
				{attType="Color"; pBreak=1; coarse=7; fine=nil; min = 0; max = 255; default=0; attribute = "ColourWheel1"; capabilities = {
					{
						dmxRange = {0,63};
						channelType = "COLOUR";
						colour = "none";
					};
					{
						dmxRange = {64,126};
						channelType = "COLOUR";
						colour = "Colour1";
					};
					{
						dmxRange = {127,189};
						channelType = "COLOUR";
						colour = "Colour2";
					};
					{
						dmxRange = {190,252};
						channelType = "COLOUR";
						colour = "Colour3";
					};
					{
						dmxRange = {253,255};
						channelType = "COLOUR";
						colour = "Colour4";
					};
				}};
				{attType="Color"; pBreak=1; coarse=8; fine=nil; min = 0; max = 255; default=0; attribute = "ColourWheel2"; capabilities = {
					{
						dmxRange = {0,63};
						channelType = "COLOUR";
						colour = "none";
					};
					{
						dmxRange = {64,126};
						channelType = "COLOUR";
						colour = "Colour1";
					};
					{
						dmxRange = {127,189};
						channelType = "COLOUR";
						colour = "Colour2";
					};
					{
						dmxRange = {190,252};
						channelType = "COLOUR";
						colour = "Colour3";
					};
					{
						dmxRange = {253,255};
						channelType = "COLOUR";
						colour = "Colour4";
					};
				}};
				{attType="Beam"; pBreak=1; coarse=9; fine=nil; min = 0; max = 255; default=0; attribute = "ZOOM"};
				{attType="Position"; pBreak=1; coarse=10; fine=11; min = -270; max = 270; default=0; attribute = "PAN"};
				{attType="Position"; pBreak=1; coarse=12; fine=13; min = -133; max = 133; default=0; attribute = "TILT"};
			}
		};
	};
	instances = {
		{
			moduleType="mainModule";
			patch=1;
		};
	}
}

return info

