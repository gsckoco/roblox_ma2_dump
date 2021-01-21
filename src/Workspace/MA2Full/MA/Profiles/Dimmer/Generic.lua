local info = {
	modules = {
		mainModule = {
			name = "Main Module";
			usedChannels = {1};
			attributes = {
				{attType="DIM"; coarse=1; fine=nil; min = 0; max = 255; default=0; capability = "intensity"};
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

