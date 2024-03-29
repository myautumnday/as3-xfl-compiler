package nid.xfl.data.graphics 
{
	import nid.xfl.compiler.swf.data.SWFLineStyle;
	import nid.xfl.interfaces.IStrokeStyle;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class StippleStroke extends StrokeStyle implements IStrokeStyle
	{
		
		public function StippleStroke(data:XML=null) 
		{
			if (data != null)
			{
				parse(data);
			}
		}
		public function parse(data:XML):void
		{
			
		}
		public function export():SWFLineStyle
		{
			var lineStyle:SWFLineStyle = new SWFLineStyle ();
				lineStyle.color = fill.color;
				lineStyle.fillType = fill.export(2);
			
			return lineStyle;
		}
	}

}