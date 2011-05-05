package nid.xfl.dom 
{
	import flash.geom.*;
	import nid.utils.*;
	import nid.xfl.data.display.*;
	import nid.xfl.data.script.*;
	import nid.xfl.dom.elements.*;
	import nid.xfl.interfaces.*;
	import nid.xfl.motion.*;
	import nid.xfl.XFLDocument;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class DOMFrame 
	{
		/**
		 * XFL Reference
		 */
		public var doc:DOMDocument;
		
		/**
		 * 
		 */
		public var type:int;
		public var motionObjectXML:MotionObjectXML;
		public var index:int;
		public var duration:int=0;
		public var tweenType:String;
		public var keyMode:int;
		public var elements:Vector.<IElement>;
		public var isEmptyFrame:Boolean;
		public var isMotionFrame:Boolean;
		public var motionTweenRotate:String;
		public var motionTweenScale:Boolean;
		public var motionTweenSnap:Boolean;
		public var motionTweenOrientToPath:Boolean;
		public var motionTweenSync:Boolean;
		public var hasCustomEase:Boolean;
		public var acceleration:Number;
		public var isMotionObject:Boolean;
		public var visibleAnimationKeyframes:int;
		public var tweenMatrix:Matrix;
		public var color:Color;
		public var tweens:Tweens;
		public var actionscript:Actionscript;
		
		public function DOMFrame(data:XML = null, refdoc:DOMDocument = null)
		{	
			doc = refdoc;
			
			if (data != null)
			{
				parse(data);
			}
			
		}
		public function parse(data:XML):void
		{
			index 	 	= int(data.@index);
			duration 	= int(data.@duration);
			keyMode  	= int(data.@keyMode);
			tweenType 	= String(data.@tweenType);
			
			motionTweenOrientToPath = Boolean2.toBoolean(data.@motionTweenOrientToPath);
			motionTweenSync = Boolean2.toBoolean(data.@motionTweenSync);
			motionTweenSnap = Boolean2.toBoolean(data.@motionTweenSnap);
			
			acceleration = Number(data.@acceleration);
			
			isMotionFrame = String(data.motionObjectXML) == ""?false:true;
			motionObjectXML = new MotionObjectXML(data.motionObjectXML);
			
			tweens = new Tweens(data.tweens);
			
			elements = null;
			elements = new Vector.<IElement>();
			
			if (data.Actionscript.toXMLString() != "")
			{
				doc.DoABC = true;
				actionscript = new Actionscript(data.Actionscript);
				//trace('frame:' + (index + 1) , actionscript);
			}
			
			//trace('element length:'+data.elements.*.length());
			
			isEmptyFrame = String(data.elements) == ""?true:false;
			
			if (!isEmptyFrame)
			{
				for (var i:int = 0; i < data.elements.*.length(); i++)
				{
					if (data.elements.*[i].toXMLString().indexOf("DOMStaticText") != -1)
					{
						elements.push(new DOMStaticText(data.elements.*[i]));
					}
					else if  (data.elements.*[i].toXMLString().indexOf("DOMDynamicText") != -1)
					{
						elements.push(new DOMDynamicText(data.elements.*[i]));
					}
					else if  (data.elements.*[i].toXMLString().indexOf("DOMInputText") != -1)
					{
						elements.push(new DOMInputText(data.elements.*[i]));
					}
					else if (data.elements.*[i].toXMLString().indexOf("DOMShape") != -1)
					{
						elements.push(new DOMShape(data.elements.*[i], doc));
					}
					else if (data.elements.*[i].toXMLString().indexOf("DOMSymbolInstance") != -1)
					{
						var domSymbol:DOMSymbolInstance = new DOMSymbolInstance(data.elements.*[i], doc);
						elements.push(domSymbol);
						tweenMatrix = domSymbol.matrix;
						color = domSymbol.color;
					}
					else if (data.elements.*[i].toXMLString().indexOf("DOMBitmapInstance") != -1)
					{
						elements.push(new DOMBitmapInstance(data.elements.*[i], doc));
					}
				}
			}
		}
	}

}