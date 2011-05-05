package nid.xfl.core 
{
	import flash.display.*;
	import flash.geom.*;
	import nid.xfl.compiler.factory.ElementFactory;
	import nid.xfl.compiler.swf.data.SWFSymbol;
	import nid.xfl.compiler.swf.tags.*;
	import nid.xfl.data.script.Actionscript;
	import nid.xfl.dom.*;
	import nid.xfl.dom.elements.*;
	import nid.xfl.interfaces.*;
	import nid.xfl.utils.Clone;
	import nid.xfl.utils.Convertor;
	import nid.xfl.XFLCompiler;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class Frame extends Sprite
	{
		public var tweenType:String;
		public var extension:Boolean = false;
		public var elements:Vector.<FrameElement>;
		public var rawElements:Vector.<IElement>;
		public var matrix:Matrix;
		public var hasColorTransform:Boolean;
		public var colorTransform:ColorTransform;
		public var stop:Boolean;
		public var play:Boolean;
		public var isClone:Boolean;
		public var isEmptyFrame:Boolean;
		public var isEndFrame:Boolean;
		public var depthOffset:int=0;
		public var actionscript:Actionscript;
		public var index:int;
		public var sid:int;
		
		public function Frame(data:DOMFrame=null) 
		{
			colorTransform = new ColorTransform();
			matrix = new Matrix();
			
			if (data != null)
			{
				construct(data);
			}
		}
		public function construct(data:DOMFrame):void
		{
			actionscript	= data.actionscript;
			isEmptyFrame 	= data.isEmptyFrame;
			tweenType 		= data.tweenType;
			index			= data.index;
			
			rawElements = data.elements;
			elements = new Vector.<FrameElement>();
			
			for (var e:int = 0; e < data.elements.length; e++)
			{
				var element:FrameElement = new FrameElement(data.elements[e].createDisplay());
				addChild(element);
				elements.push(element);
				matrix = element.matrix;
				
				if (data.elements[e].color != null)
				{
					hasColorTransform = true;
					colorTransform.alphaMultiplier = data.elements[e].color.alphaMultiplier;
				}
				
				//trace(element.type);
			}
		}
		/**
		 * PREVIEW SECTION
		 */
		public function gotoAndStop(frame:Object):void
		{
			for (var e:int = 0; e < elements.length; e++)
			{
				//elements[e].update(frame);
			}
		}
		public function updateDisplay():void
		{
			
			for (var e:int = 0; e < elements.length; e++)
			{
				if (elements[e].type == "timeline")
				{
					if (tweenType == "")
					{
						matrix = elements[e].matrix;
					}
					
					elements[e].display.transform.matrix = matrix;
					
					if (hasColorTransform)
					{
						elements[e].display.transform.colorTransform = colorTransform;
						//trace('colorTransform.alphaMultiplier:' + colorTransform.alphaMultiplier);
					}
					
					elements[e].update();
					addChild(elements[e]);
				}
				else if (elements[e].type == "button")
				{
					//if (tweenType == "")
					//{
						//matrix = elements[e].matrix;
					//}
					//
					//elements[e].display.transform.matrix = matrix;
					//
					//if (hasColorTransform)
					//{
						//elements[e].display.transform.colorTransform = colorTransform;
						//trace('colorTransform.alphaMultiplier:' + colorTransform.alphaMultiplier);
					//}
					
					elements[e].update();
					addChild(elements[e]);
				}
				else
				{
					if (elements[e] != null) addChild(elements[e]);
				}
			}
		}
		
		public function clone(end:Boolean=false):Frame
		{
			var frame:Frame 			= new Frame();
				frame.isEndFrame 		= end;
				frame.matrix 			= matrix.clone();
				frame.hasColorTransform = hasColorTransform;
				frame.colorTransform 	= Clone.colorTransform(colorTransform);
				frame.elements 			= elements;
				frame.rawElements 		= rawElements;
				frame.tweenType 		= tweenType;
				frame.extension 		= extension;
				//frame.actionscript 		= actionscript;
				frame.isClone 			= true;
			return frame;
		}
		/**
		 * XFL SCAN SECTION
		 * scan xfl object to create display depth model
		 */
		public function scan(property:Object):void
		{
			if (!isClone && actionscript != null)
			{
				//trace('as:: frame:' +(index + 1) , 'depth:' + property.depth, 'script:' + actionscript);
				property.actionscript = true;
			}
			
			if (!isEmptyFrame)
			{
				
				for (var i:int = 0; i < rawElements.length; i++)
				{
					if (rawElements[i] is DOMSymbolInstance)
					{
						DOMSymbolInstance(rawElements[i]).scan();
					}
				}
				if (property.depth < rawElements.length) property.depth = rawElements.length;
			}
		}
		/**
		 * SWF PUBLISH SECTION
		 */
		public function publish(tags:Vector.<ITag>, property:Object,sub_tags:Vector.<ITag>=null):void
		{
			/**
			 * Publish frame data to swf tags
			 */
			property.characterId 	= XFLCompiler.characterId;
			var p_depth:String 		= property.p_depth;
			var depth:uint 			= property.depthOffset;
			
			var characterId:uint;
			
			/**
			 * Create action script data
			 */
			if (XFLCompiler.DoABC && actionscript != null)
			{
				//trace('as:: frame:' +sid , 'depth:' + property.depth, 'script:' + actionscript);
				property.scriptPool.push(actionscript);
			}
			
			/**
			 * If frame is not empty build frame data
			 */
			if (!isEmptyFrame)
			{
				
				for (var i:int = 0; i < rawElements.length; i++)
				{
					/**
					 * If frame is not last frame build frame data
					 */
					if (!isEndFrame)
					{
						var placeObject:TagPlaceObject2 = new TagPlaceObject2();
						var removeObject:TagRemoveObject2 = new TagRemoveObject2();
						
						if (tweenType == "")
						{
							matrix = rawElements[i].matrix
						}
						
						if (isClone)
						{
							//trace('cloned place object');
							placeObject.hasMatrix 			= true;
							placeObject.hasMove 			= true;
							placeObject.depth 				= depth;
							placeObject.matrix 				= Convertor.toSWFMatrix(matrix);
							placeObject.hasColorTransform 	= hasColorTransform;
							if (hasColorTransform)placeObject.colorTransform  = Convertor.toSWFColorTransform(colorTransform);
							sub_tags == null?tags.push(placeObject):sub_tags.push(placeObject);
						}
						else
						{
							
							if (
								rawElements[i].libraryItemName != ElementFactory.NOT_SUPPORTED &&
								XFLCompiler.displayList[p_depth +'_' + depth] != undefined &&
								XFLCompiler.displayList[p_depth +'_' + depth].libraryItemName == rawElements[i].libraryItemName
								)
							{
								//trace('exist in depth');
								
								placeObject.hasMatrix 			= true;
								placeObject.hasMove 			= true;
								placeObject.depth 				= depth;
								placeObject.matrix 				= Convertor.toSWFMatrix(matrix);
								placeObject.hasColorTransform 	= hasColorTransform;
								if (hasColorTransform)placeObject.colorTransform  = Convertor.toSWFColorTransform(colorTransform);
								sub_tags == null?tags.push(placeObject):sub_tags.push(placeObject);
							}
							else 
							{
								var result:Object = ElementFactory.isExistInLibrary(rawElements[i]);
								
								if (result.exist)
								{
									//trace('exist in library');
									property.characterId = result.element.characterId;
								}
								else
								{
									//trace('not exist in library');
									/**
									* Tag Definition 
									*/
									rawElements[i].publish(tags, property);
									XFLCompiler.elementLibrary[property.characterId] = rawElements[i];
									XFLCompiler.characterId++;
								}
								//trace('object_key:' + p_depth +'_' + depth);
								
								if (XFLCompiler.displayList[p_depth +'_' + depth] != undefined)
								{
									//trace('remove tag');
									/**
									 * Remove Tag
									 */
									removeObject.depth = depth;
									//trace('remove_object_key:' + p_depth +'_' + depth);
									if (sub_tags != null && sub_tags.length > 0)
									{
										sub_tags.push(removeObject);
									}
									else if (sub_tags == null)
									{
										tags.push(removeObject)
									}
								}
								
								characterId = property.characterId;
								
								//trace('place object depth:' + depth, "Char ID:" + characterId);
								
								/**
								 * Place tag
								 */
								placeObject.depth 				= depth;
								placeObject.hasCharacter 		= true;
								placeObject.characterId 		= characterId;
								placeObject.hasMatrix 			= true;
								placeObject.matrix 				= Convertor.toSWFMatrix(matrix);
								placeObject.hasColorTransform 	= hasColorTransform;
								if (hasColorTransform)placeObject.colorTransform  = Convertor.toSWFColorTransform(colorTransform);
								sub_tags == null?tags.push(placeObject):sub_tags.push(placeObject);
								
								XFLCompiler.displayList[p_depth +'_' + property.depth] = rawElements[i];
								
							}
						}
						
					}
					depth++;
				}
				
				property.depth = depth;
			}
		}
	}

}