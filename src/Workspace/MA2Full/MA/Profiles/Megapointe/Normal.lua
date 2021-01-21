local info = {
	modules = {
		mainModule = {
			name = "Main Module";
			usedChannels = {1,2,3,4,5,6,7,8,9,10,11,12,13};
			attributes = {
				{attType="Position"; pBreak=1; coarse=1; fine=2; min = -270; max = 270; default=0; attribute = "PAN"};
				{attType="Position"; pBreak=1; coarse=3; fine=4; min = -132; max = 132; default=0; attribute = "TILT"};
				{attType="SHUTTER/MAINTENANCE"; pBreak=1; coarse=5; fine=nil; min = 0; max = 255; default=212; attribute = "shutter"; capabilities = {
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
				{attType="Color"; pBreak=1; coarse=6; fine=nil; min = 0; max = 255; default=0; attribute = "COLORCYAN"};
				{attType="Color"; pBreak=1; coarse=7; fine=nil; min = 0; max = 255; default=0; attribute = "COLORMAGENTA"};
				{attType="Color"; pBreak=1; coarse=8; fine=nil; min = 0; max = 255; default=0; attribute = "COLORYELLOW"};
				{attType="Color"; pBreak=1; coarse=9; fine=nil; min = 0; max = 255; default=0; attribute = "ColourWheel1"; capabilities = {
					{
						dmxRange = {0};
						channelType = "COLOUR";
						colour = "Open";
					};
					{
						dmxRange = {10};
						channelType = "COLOUR";
						colour = "Deep Red";
					};
					{
						dmxRange = {20};
						channelType = "COLOUR";
						colour = "Deep Blue";
					};
					{
						dmxRange = {30};
						channelType = "COLOUR";
						colour = "Yellow";
					};
					{
						dmxRange = {40};
						channelType = "COLOUR";
						colour = "Light Green";
					};
					{
						dmxRange = {50};
						channelType = "COLOUR";
						colour = "Magenta";
					};
					{
						dmxRange = {60};
						channelType = "COLOUR";
						colour = "Lavender";
					};
					{
						dmxRange = {70};
						channelType = "COLOUR";
						colour = "Pink";
					};
					{
						dmxRange = {80};
						channelType = "COLOUR";
						colour = "Dark Green";
					};
					{
						dmxRange = {90};
						channelType = "COLOUR";
						colour = "CTO 2700K";
					};
					{
						dmxRange = {100};
						channelType = "COLOUR";
						colour = "Blue";
					};
					{
						dmxRange = {110};
						channelType = "COLOUR";
						colour = "Orange";
					};
					{
						dmxRange = {120};
						channelType = "COLOUR";
						colour = "CTO 3200K";
					};
					{
						dmxRange = {130};
						channelType = "COLOUR";
						colour = "UV (Kongo Blue)";
					};
				}};
				{attType="Beam"; pBreak=1; coarse=10; fine=11; min = 0; max = 255; default=0; attribute = "ZOOM"};
				{attType="Color"; pBreak=1; coarse=12; fine=nil; min = 0; max = 255; default=0; attribute = "COLORTEMP"};
				{attType="DIM"; pBreak=1; coarse=13; fine=nil; min = 0; max = 255; default=0; attribute = "intensity"};
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

