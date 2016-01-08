package;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.filters.ColorMatrixFilter;

class Reg
{

	public static function adjustColour(
			data:BitmapData,
			b:Float = 0,
			c:Float = 1,
			s:Float = 1,
			h:Float = 0):Void
	{
		var m:Array<Float> = [
			c*(1-s)*0.3086+s,(1-s)*0.3086,(1-s)*0.3086, 0, b*255-((255 - c*255) / 2), 
			(1-s)*0.6094,c*(1-s)*0.6094+s,(1-s)*0.6094, 0, b*255-((255 - c*255) / 2), 
			(1-s)*0.0820,(1-s)*0.0820,c*(1-s)*0.0820+s, 0, b*255-((255 - c*255) / 2), 
			0, 0, 0, 1, 0,
			0, 0, 0, 0, 1];

		h = Math.min(180, Math.max(-180, h)) / 180 * Math.PI;

		var cosVal:Float = Math.cos(h);
		var sinVal:Float = Math.sin(h);
		var lumR:Float = 0.3086;
		var lumG:Float = 0.6094;
		var lumB:Float = 0.0820;
		var lumArray:Array<Float> = [
			lumR+cosVal*(1-lumR)+sinVal*(-lumR),lumG+cosVal*(-lumG)+sinVal*(-lumG),
			lumB+cosVal*(-lumB)+sinVal*(1-lumB),0,0,
			lumR+cosVal*(-lumR)+sinVal*(0.143),lumG+cosVal*(1-lumG)+sinVal*(0.140),
			lumB+cosVal*(-lumB)+sinVal*(-0.283),0,0,
			lumR+cosVal*(-lumR)+sinVal*(-(1-lumR)),lumG+cosVal*(-lumG)+sinVal*(lumG),
			lumB+cosVal*(1-lumB)+sinVal*(lumB),0,0,0,0,0,1,0,0,0,0,0,1];

		var r:Array<Float> = mult(m, lumArray, 5);
		for (i in 0...5) r.pop();

		data.applyFilter(
				data,
				data.rect,
				new Point(0, 0),
				new ColorMatrixFilter(r));
	}

	private static function mult(m1:Array<Float>,
			m2:Array<Float>,
			width:Int):Array<Float>
	{
		var r:Array<Float> = [];

		for (i in 0...width) {
			for (j in 0...width) {
				r[i*width + j]=0;
				for(k in 0...width)
					r[i*width + j] += m1[i*width + k] * m2[k*width + j];
			}
		}

		return r;
	}
}
