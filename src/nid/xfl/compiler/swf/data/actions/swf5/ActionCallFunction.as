﻿package nid.xfl.compiler.swf.data.actions.swf5
{
	import nid.xfl.compiler.swf.data.actions.*;
	
	public class ActionCallFunction extends Action implements IAction
	{
		public static const CODE:uint = 0x3d;
		
		public function ActionCallFunction(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionCallFunction]";
		}
	}
}
