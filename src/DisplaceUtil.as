package {
	import mx.utils.NameUtil;
	import flash.events.DataEvent;
	import flash.utils.getTimer;
	import flash.geom.ColorTransform;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.display.Sprite;
	/**
	 * @author wbguan
	 */
	public class DisplaceUtil extends Object {
		public function DisplaceUtil() {
		}
		public static function transform(target:Sprite,form:Point,to:Point,timer:int,callBack:Function):void{
			
		}
		public static function sinxFun(x:int,a:int,b:int,c:int,d:int):Number {
		  var result:Number;
		  result = Math.sin(Math.PI * (x-c) / a) * b + d;
		  return result;
		}
		public static function getBitmap2(w:int,h:int):Bitmap{
			var result:Bitmap = new Bitmap();
			var data:BitmapData = new BitmapData(w, h,true,0xffffffff);
			var yarr:Array = [];
			var a:int = Math.floor(w/2);
			var b:int = Math.floor(h/4);
			var c:int = 100;
			var d:int = b - 100;;
			for(var i:int = 0;i<w;i++){
				var tmp:int = Math.floor(sinxFun(i,a, b, c, d));
				yarr.push(tmp);
			}
			var _x:int = 0;
			var _base:uint = 0x80;
			var color:uint = 0;
			var ct:ColorTransform ;
			var xper:Number = _base /w;
			for each(var _y:int in yarr){
				var per:Number = (_base - xper*_x)/_y;
				for(var j:int=_y;j>=0;j--){
					if(_base- (_y - j)*0x01 >=0){
						color = _base - (_y - j)*per;
					}else{
						color=0;
					}
					if(j == _y){
				    	ct = new ColorTransform(1,1,1,1,color,0x80,0x80);
					}else{
						ct = new ColorTransform(1,1,1,1,color);
					}
					ct = new ColorTransform(1,1,1,1,color);
					data.setPixel(_x, j, ct.color);
				}
				per = (xper*(w-_x) +_base)/(h-_y);
				for(var j2:int = _y;j2 < h ;j2++){
					color = _base + (j2 - _y) * per;
					if(color >0xff){
						color=0xff; 
					}
					if(j2 == _y){
				    	ct = new ColorTransform(1,1,1,1,color,0x80,0x80);
					}else{
						ct = new ColorTransform(1,1,1,1,color);
					}
					data.setPixel(_x, j2, ct.color);
				}
				_x++;
			}
			result.bitmapData = data;
			return result;
		}
		public static function getBitmap(w:int,h:int):Bitmap{
			var result:Bitmap = new Bitmap();
			var data:BitmapData = new BitmapData(w, h,true,0xffffffff);
			var last:Number =  getTimer();
			var arr:Array = pixelSin(w);
			trace("[DisplaceUtil/getBitmap] timer : " + (getTimer() - last));
			var halfH:int = Math.floor(h/4);
			var colorT:ColorTransform ;
			last =  getTimer();
			for (var i:int = 0; i < w ;i++){
				var p:int = arr[i];
				colorT = new ColorTransform(1,1,1,1,p,0,0,0);
//				trace("[DisplaceUtil/getBitmap] P " + p + "r|g|b : " + colorT.color );
				for(var j1:int = 0 ; j1<halfH;j1++){
					var c:uint = p;
					var ec:uint = 255-p;
					var per:int = Math.floor((ec - c)/halfH);
					c = c + j1*per;
					if(c>=ec){
						c=ec;
					}
					var ct:ColorTransform = new ColorTransform(1,1,1,1,c,0,0,0);
					data.setPixel(i, j1,  ct.color);
//					trace("[DisplaceUtil/getBitmap] j1 : " + j1);
				}
				for(var j2:int = halfH; j2<h ;j2++){
					data.setPixel(i, j2, 0xff0000-colorT.color);
//					trace("[DisplaceUtil/getBitmap] j2 : " + j2);
				}
			}
			trace("[DisplaceUtil/getBitmap] timer2 : " + (getTimer() - last));
			result.bitmapData = data;
			return result;
		}
		
		public static function setPixel(data:BitmapData,arr:Array):void {
		  var w:int = data.width;
		  var h:int = data.height;
		  var halfH:int = Math.floor(h/4);
		  var colorT:ColorTransform ;
		  for (var i:int = 0; i < w ;i++){
			var p:int = arr[i];
			colorT = new ColorTransform(1,1,1,1,p,0,0,0);
			var jp:uint = 0;
			for(var j:int = 0; j < h;j++){
				if(j > halfH){
					data.setPixel(i, j, 0xff0000-colorT.color);
				}else{
			       data.setPixel(i, j, colorT.color);
				}
			}
		  }
		}
		
		public static function pixelSin(w:int):Array{
			var result:Array = [];
			for(var i:int = 1; i <= w; i++){
				var p:int = sinx(i,128,w);
				trace ("[DisplaceUtil/pixelSin] : " + p);
				result.push(p);
			}
			return result;
		}
		public static function pixel(w:int):Array{
			var result:Array = [];
			for(var i:int = 1; i <= w; i++){
				var p:int = ellipseX(i,w,256);
				result.push(p);
			}
			return result;
		}
		
		public static function sinx(x:int,a:int,b:int):int {
		  return a*Math.sin(x / b * Math.PI);
		}
		
		public static function ellipseX(x:int,a:int,b:int):int{
			var result:int = 0;
			var y2:int = b*b * (1-x*x/(a*a));
			result = Math.floor(Math.sqrt(y2));
			return result;
		}
	}
}
