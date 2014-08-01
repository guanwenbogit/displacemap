package  {

	/**
	 * @author wbguan
	 */
	public class LRRoundRectangle extends LRRectangle {
		private var _round:int = 0;
		public function LRRoundRectangle(width : Number, height : Number, round:int,color : uint = 0xf0c0f0, alpha : Number = 1) {
			this._round = round;
			super(width, height, color, alpha);
		}
		
		override protected function draw():void{
			this.graphics.beginFill(this._color,this._alpha);
			this.graphics.drawRoundRect(0, 0, this._width, this._height,this._round);
			this.graphics.endFill();
		}
		
	}
}
