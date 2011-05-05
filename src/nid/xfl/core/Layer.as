package nid.xfl.core 
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.utils.Dictionary;
	import nid.xfl.compiler.swf.tags.ITag;
	import nid.xfl.dom.DOMFrame;
	import nid.xfl.dom.DOMLayer;
	import nid.xfl.motion.EasingEquations;
	import nid.xfl.motion.TweenType;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class Layer extends Sprite
	{
		public var totalFrames:int = 0;
		public var frames:Vector.<Frame>;
		public var timeline:Dictionary = new Dictionary();
		public var currentIndex:int = 0;
		public var stop:Boolean;
		public var depthOffset:int = 0;
		
		private var display:Sprite;
		
		public function Layer(data:DOMLayer=null) 
		{
			frames = new Vector.<Frame>();
			
			if (data != null)
			{
				construct(data);
			}
		}
		public function construct(data:DOMLayer):void
		{
			name = data.name;
			
			var frame:Frame;
			
			for (var f:int = 0; f < data.domframes.length; f++)
			{
				if (data.domframes[f].duration > 0)
				{
					for (var i:int = data.domframes[f].index; i < data.domframes[f].index + data.domframes[f].duration; i++)
					{
						if (i > data.domframes[f].index && data.domframes.length > f)
						{
							frame = frames[i - 1].clone(f == (data.domframes.length - 1));
							applyMotion(frame, data, i, f);
						}
						else
						{
							frame = new Frame(data.domframes[f]);
							//trace('alpha:'+frame.elements[0].alpha);
						}
						
						addFrameAt(frame, i, i > data.domframes[f].index);
						frames.push(frame);
						frame.sid = frames.length;
						totalFrames++;
					}
				}
				else
				{
					frame = new Frame(data.domframes[f]);
					addFrameAt(frame, data.domframes[f].index);
					frames.push(frame);
					frame.sid = frames.length;
					totalFrames++;
				}
			}
		}
		internal function applyMotion(frame:Frame, data:DOMLayer, i:int, f:int):void
		{
			switch(data.domframes[f].tweenType)
			{
				case TweenType.SHAPE:
				{
					
				}
				break;
				
				case TweenType.MOTION:
				{
					var mat:Matrix = frame.elements[0].display.transform.matrix;
					//trace(mat.toString());
					//Linear
					//trace((i + 1 - data.domframes[f].index));
					mat.tx += ((data.domframes[f + 1].tweenMatrix.tx - data.domframes[f].tweenMatrix.tx) / (data.domframes[f].duration + 1) ) * (i + 1 - data.domframes[f].index);
					mat.ty += ((data.domframes[f + 1].tweenMatrix.ty - data.domframes[f].tweenMatrix.ty) / (data.domframes[f].duration + 1)) * (i + 1 - data.domframes[f].index);
					mat.a += ((data.domframes[f + 1].tweenMatrix.a - data.domframes[f].tweenMatrix.a) / (data.domframes[f].duration + 1)) * (i + 1 - data.domframes[f].index);
					mat.b += ((data.domframes[f + 1].tweenMatrix.b - data.domframes[f].tweenMatrix.b) / (data.domframes[f].duration + 1)) * (i + 1 - data.domframes[f].index);
					mat.c += ((data.domframes[f + 1].tweenMatrix.c - data.domframes[f].tweenMatrix.c) / (data.domframes[f].duration + 1)) * (i + 1 - data.domframes[f].index);
					mat.d += ((data.domframes[f + 1].tweenMatrix.d - data.domframes[f].tweenMatrix.d) / (data.domframes[f].duration + 1)) * (i + 1 - data.domframes[f].index);
					
					//Ease Out
					//trace(i, data.domframes[f].tweenMatrix.tx, mat.tx, EasingEquations.easeOutQuad(i, data.domframes[f].tweenMatrix.tx, mat.tx, data.domframes[f].duration));
					//mat.tx = EasingEquations.easeOutQuad(i, data.domframes[f].tweenMatrix.tx, mat.tx, data.domframes[f].duration);
					//mat.ty += EasingEquations.ease(data.domframes[f + 1].tweenMatrix.ty, frames[i - 1].matrix.ty);
					//mat.a += ((data.domframes[f + 1].tweenMatrix.a - data.domframes[f].tweenMatrix.a) / data.domframes[f].duration ) * (i + 1 - data.domframes[f].index);
					//mat.b += ((data.domframes[f + 1].tweenMatrix.b - data.domframes[f].tweenMatrix.b) / data.domframes[f].duration ) * (i + 1 - data.domframes[f].index);
					//mat.c += ((data.domframes[f + 1].tweenMatrix.c - data.domframes[f].tweenMatrix.c) / data.domframes[f].duration ) * (i + 1 - data.domframes[f].index);
					//mat.d += ((data.domframes[f + 1].tweenMatrix.d - data.domframes[f].tweenMatrix.d) / data.domframes[f].duration ) * (i + 1 - data.domframes[f].index);
					
					frame.matrix = mat;
					
					if (frame.hasColorTransform)
					{
						if (data.domframes[f + 1].color.alphaMultiplier == data.domframes[f].color.alphaMultiplier)
						{
							frame.colorTransform.alphaMultiplier = data.domframes[f].color.alphaMultiplier;
						}
						else 
						{
							frame.colorTransform.alphaMultiplier = ((data.domframes[f + 1].color.alphaMultiplier - data.domframes[f].color.alphaMultiplier) / data.domframes[f].duration ) * (i + 1 - data.domframes[f].index);
						}
						//trace('frame.colorTransform.alphaMultiplier:' + frame.colorTransform.alphaMultiplier);
					}
					
				}
				break;
				
				case TweenType.MOTION_OBJECT:
				{
					
				}
				break;
			}
		}
		public function addFrame(frame:Frame, extension:Boolean = false):void
		{
			timeline[++currentIndex] = frame;
			timeline[currentIndex].extension = extension;
		}
		public function addFrameAt(frame:Frame, index:int = 0, extension:Boolean = false):void
		{
			timeline[index] = frame;
			timeline[index].extension = extension;
		}
		public function removeFrame(frame:Frame):void
		{
			timeline[currentIndex] = null;
			delete timeline[currentIndex--];
		}
		public function removeFrameAt(index:int = 0):void
		{
			timeline[index] = null;
			delete timeline[index];
		}
		
		public function gotoAndStop(frame:Object,depth:int):void
		{
			flush();
			if (frame is String)
			{
				//TODO: jump to label
			}
			else if (frame is Number)
			{
				
				var _fi:int = int(frame) - 1;
				var _fo:Frame = timeline[_fi];
				
				if (_fo != null)
				{
					display.addChild(_fo);
					_fo.updateDisplay();
					stop = _fo.stop == true?true:stop;
				}
				else if (totalFrames <= _fi  && timeline[totalFrames - 1] != null)
				{
					_fo = timeline[totalFrames - 1];
					
					display.addChild(_fo);
					_fo.updateDisplay();
					stop = _fo.stop == true?true:stop;
				}
				else
				{
					//trace('null frame:', int(frame), 'depth:' + depth);
				}
				
			}
		}
		internal function flush():void
		{
			if (display != null && this.contains(display))
			{
				removeChild(display);
			}
			display = null;
			display = new Sprite();
			addChild(display);
		}
		
		/**
		 *  Scan layer for depth offset calculation
		 */
		public function scan(property:Object):void
		{
			var _property:Object = { depth:0 }
			
			for (var i:int = 0; i < frames.length; i++)
			{
				frames[i].scan(_property);
			}
			//trace('parent:' + property.parent);
			//trace('_property.depth:' + _property.depth);
			
			depthOffset 	= property.depth + _property.depth;
			property.depth 	= depthOffset;
			
			//trace('depthOffset:' + depthOffset);
		}
		public function publish(f:int, tags:Vector.<ITag>, property:Object,sub_tags:Vector.<ITag>=null):void
		{
			property.depthOffset = depthOffset;
			frames[f].publish(tags, property, sub_tags);
		}
	}

}