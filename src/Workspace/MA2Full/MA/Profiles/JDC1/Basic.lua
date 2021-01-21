local info = {
	modules = {
		mainModule = {
			name = "Main Module";
			usedChannels = {1,2,3,4,5,6,7};
			attributes = {
				{attType="Position"; coarse=1; fine=2; min = 0; max = 180; default=90; attribute = "TILT"};
				{attType="DIM"; coarse=3; fine=nil; min = 0; max = 255; default=0; attribute = "tubeIntensity"};
				{attType="DIM"; coarse=4; fine=nil; min = 0; max = 255; default=0; attribute = "panelIntensity"};
				{attType="Color"; coarse=5; fine=nil; min = 0; max = 255; default=255; attribute = "COLORRED"};
				{attType="Color"; coarse=6; fine=nil; min = 0; max = 255; default=255; attribute = "COLORGREEN"};
				{attType="Color"; coarse=7; fine=nil; min = 0; max = 255; default=255; attribute = "COLORBLUE"};
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

