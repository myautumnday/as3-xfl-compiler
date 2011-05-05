package nid.xfl.interfaces 
{
	import nid.xfl.compiler.swf.data.SWFFillStyle;
	
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public interface IFillStyle 
	{
		function export(_type:int):SWFFillStyle;
		function get color():uint;
		function get alpha():Number;
		function get index():uint;
	}
	
}