package nid.xfl.compiler.factory 
{
	import nid.xfl.interfaces.IElement;
	import nid.xfl.XFLCompiler;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class ElementFactory 
	{
		static public const NOT_SUPPORTED:String = "not_supported";
		
		public function ElementFactory() 
		{
			
		}
		static public function isExistInLibrary(element:IElement):Object
		{
			if (element.libraryItemName == NOT_SUPPORTED) return { exist:false };
			
			for each(var _element:IElement in XFLCompiler.elementLibrary)
			{
				if(_element.libraryItemName == element.libraryItemName)
				{
					return { exist:true, element:_element };
				}
			}
			return { exist:false };
		}
		static public function getElementByLibraryItemName(libraryItemName:String):IElement
		{
			for each(var _element:IElement in XFLCompiler.elementLibrary)
			{
				if (_element.libraryItemName == libraryItemName)
				{
					return _element;
				}
			}
			return null;
		}
		static public function getElementIdByLibraryItemName(libraryItemName:String):int
		{
			for each(var _element:IElement in XFLCompiler.elementLibrary)
			{
				if (_element.libraryItemName == libraryItemName)
				{
					return _element.characterId;
				}
			}
			return 0;
		}
	}

}