package nid.xfl 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import nid.xfl.dom.DOMBitmapItem;
	import nid.xfl.dom.DOMDocument;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class Media 
	{
		public var bitmaps:Dictionary
		public var doc:DOMDocument;
		
		public function Media(data:XML=null,refdoc:DOMDocument=null) 
		{
			doc = refdoc;
			
			if (data != null)
			{
				parse(data);
			}
		}
		public function parse(data:XML):void
		{
			bitmaps = null;
			bitmaps = new Dictionary();
			
			for ( var i:int = 0; i < data.DOMBitmapItem.length(); i++)
			{
				var bmp_item:DOMBitmapItem = new DOMBitmapItem(XML(data.DOMBitmapItem[i]), doc);
				bmp_item.id = i;
				bitmaps[String(data.DOMBitmapItem[i].@name)] = bmp_item;
			}
		}
		
		public function getBitmapId(value:String):int
		{
			return bitmaps[value].id;
		}
		public function getBitmapByName(value:String):Bitmap
		{
			return bitmaps[value] == undefined?null:bitmaps[value].bitmap;
		}
		public function getBitmapById(id:int):Bitmap
		{
			for each (var bmp:DOMBitmapItem in bitmaps)
			{
				if (bmp.id == id)
				{
					return bmp.bitmap;
				}
			}
			
			return null;
		}
		
	}

}