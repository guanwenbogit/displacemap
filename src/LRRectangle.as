package  {
	import flash.display.Shape;

	/**
	 * @author wbguan
	 */
	public class LRRectangle extends Shape {
		protected var _width:Number;
		protected var _height:Number;
		protected var _alpha:Number;
		protected var _color:uint;
		
		public function LRRectangle(width:Number,height:Number,color:uint = 0xffffff,alpha:Number = 1) {
			this._width = width;
			this._height = height;
			this._color = color;
			this._alpha = alpha;
			this.draw();
		}
		
		protected function draw():void{
			this.graphics.beginFill(this._color,this._alpha);
			this.graphics.drawRect(0, 0, this._width, this._height);
			this.graphics.endFill();	
		}
	}
}
