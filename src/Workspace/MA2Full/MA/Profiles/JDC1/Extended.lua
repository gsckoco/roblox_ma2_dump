local info = {
	modules = {
		mainModule = {
			name = "Main Module";
			usedChannels = {1,2};
			attributes = {
				{attType="Position"; pBreak=1; coarse=1; fine=2; min = -90; max = 90; default=0; attribute = "TILT"};
			}
		};
		RGBPixel = {
			name = "RGB Pixel";
			usedChannels = {1,2,3,4};
			attributes = {
				{attType="DIM"; pBreak=1; coarse=1; fine=nil; min = 0; max = 255; default=0; attribute = "intensity"};
				{attType="Color"; pBreak=1; coarse=2; fine=nil; min = 0; max = 255; default=255; attribute = "COLORRED"};
				{attType="Color"; pBreak=1; coarse=3; fine=nil; min = 0; max = 255; default=255; attribute = "COLORGREEN"};
				{attType="Color"; pBreak=1; coarse=4; fine=nil; min = 0; max = 255; default=255; attribute = "COLORBLUE"};
			}
		};
		WhitePixel = {
			name = "White Pixel";
			usedChannels = {1};
			attributes = {
				{attType="DIM"; pBreak=1; coarse=1; fine=nil; default=0; min = 0; max = 255; attribute = "intensity"};
			}
		};
	};
	instances = {
		{
			moduleType="mainModule";
			patch=1;
		};
		{
			moduleType="RGBPixel";
			patch=3;
		};
		{
			moduleType="RGBPixel";
			patch=7;
		};
		{
			moduleType="RGBPixel";
			patch=11;
		};
		{
			moduleType="RGBPixel";
			patch=15;
		};
		{
			moduleType="RGBPixel";
			patch=19;
		};
		{
			moduleType="RGBPixel";
			patch=23;
		};
		{
			moduleType="RGBPixel";
			patch=27;
		};
		{
			moduleType="RGBPixel";
			patch=31;
		};
		{
			moduleType="RGBPixel";
			patch=35;
		};
		{
			moduleType="RGBPixel";
			patch=39;
		};
		{
			moduleType="RGBPixel";
			patch=43;
		};
		{
			moduleType="RGBPixel";
			patch=47;
		};
		{
			moduleType="WhitePixel";
			patch=51;
		};
		{
			moduleType="WhitePixel";
			patch=52;
		};
		{
			moduleType="WhitePixel";
			patch=53;
		};
		{
			moduleType="WhitePixel";
			patch=54;
		};
		{
			moduleType="WhitePixel";
			patch=55;
		};
		{
			moduleType="WhitePixel";
			patch=56;
		};
		{
			moduleType="WhitePixel";
			patch=57;
		};
		{
			moduleType="WhitePixel";
			patch=58;
		};
		{
			moduleType="WhitePixel";
			patch=59;
		};
		{
			moduleType="WhitePixel";
			patch=60;
		};
		{
			moduleType="WhitePixel";
			patch=61;
		};
		{
			moduleType="WhitePixel";
			patch=62;
		};
	}
}

return info

