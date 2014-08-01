package  {
	import flash.display.Shape;

	/**
	 * @author wbguan
	 */
	public class LRCircle extends Shape {
		protected var _radius:Number;
		protected var _color:uint;
		protected var _alpha:Number;
		public function LRCircle(radius : Number,color : uint = 0xffffff,alpha:Number = 1.0) {
			this._radius = radius;
			this._color = color;
			this._alpha = alpha;
			this.draw();
		}
		
		protected function draw():void{
			this.graphics.beginFill(this._color,this._alpha);
			this.graphics.drawCircle(_radius, _radius, _radius);
			this.graphics.endFill();
		}
	}
}
