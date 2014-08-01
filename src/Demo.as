package {
	import flash.display.StageAlign;
	import flash.events.MouseEvent;
	import flash.display.StageScaleMode;
	import flash.system.System;
	import flash.geom.Point;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.DisplacementMapFilter;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author wbguan
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="20", width="1024", height="768")]
	public class Demo extends Sprite {
		[Embed(source="rankbg.png")]
		private var Rank : Class;
		[Embed(source="resource.png")]
		private var Resource : Class;
		private var _bitmap : Bitmap;
		private var _bitmapData : BitmapData;
		private var _loader : Loader = new Loader();
		private var _dest : Bitmap;
		private var _destData : BitmapData;
		private var _filer : DisplacementMapFilter;
		private var _s : Sprite = new Sprite();

		public function Demo() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
//			this.sinx(278, 252);
			// //			var req : URLRequest = new URLRequest();
			// //			req.url = "rankbg.png";
			// //			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			// //			_loader.load(req, new LoaderContext(false, ApplicationDomain.currentDomain));
			// //			this.addChild(new Resource());
			// //            this._bitmap
//			var b : Bitmap = DisplaceUtil.getBitmap2(278, 252);
			this._bitmap = new Rank();
			var bg:LRRectangle = new LRRectangle(_bitmap.width + 4, _bitmap.height + 4,0x00ffffff,0);
			this._bitmapData = this._bitmap.bitmapData;
			_s.addChild(bg);
			_s.addChild(_bitmap);
			_bitmap.x= _bitmap.y = 2;
			_s.scaleX = _s.scaleY = 0.7;
			initInstace();
			
//			_s.addChild(b);
			this.addChild(this._s);
			//			
			this.stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function sinx(w : int, h : int) : void {
			var a : int = Math.floor(w / 2);
			var b : int = Math.floor(h / 2);
			var c : int = a + 30;
			var d : int = b + 30;
			for (var i : int = 0; i < w; i++) {
				var _y : Number = DisplaceUtil.sinxFun(i, a, b, c, d);
				var rect : LRRectangle = new LRRectangle(1, 1);
				rect.x = i;
				rect.y = _y;
				this.addChild(rect);
			}
		}

		private function onClick(event : MouseEvent) : void {
			this.stage.removeEventListener(MouseEvent.CLICK, onClick);
//			onFrame(null);
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onComplete(event : Event) : void {
			this._bitmap = (event.target as LoaderInfo).content as Bitmap;
			this._bitmapData = this._bitmap.bitmapData;
			initInstace();
			_s.addChild(this._bitmap);
			this.addChild(this._s);
		}

		private function initInstace() : void {
			trace("[Demo/initInstace] m : " + System.totalMemory);
			_dest = DisplaceUtil.getBitmap2(_s.width, _s.height);
			this.addChild(this._dest);
			this._dest.x = 1024;
			this.createFilter();
			trace("[Demo/initInstace] m : " + System.totalMemory);
			// _destData = new BitmapData(this._bitmap.width, this._bitmap.height, true, 0x123456);
			// _dest.bitmapData = _destData;
			trace("[Demo/createFilter] " + this._dest.width + " | " + this._dest.height);
			_s.cacheAsBitmap = true;
			trace("[Demo/createFilter] " + this._dest.width + " | " + this._dest.height);
		}

		private function createFilter() : void {
			var cX : uint = 8;
			var cY : uint = 1;
			_filer = new DisplacementMapFilter(this._dest.bitmapData, new Point(0, 0), cX, cY, 0, 0, DisplacementMapFilterMode.CLAMP, 0x00ffffff, 0);
		}

		private var _count : int = 0;
		protected var _x : int = Math.floor(1900/5 * 2);
		protected var _y : int = Math.floor(800/6 *16 );

		private function onFrame(event : Event) : void {
			if (_count >=12) {
				_x = 1100-(_count)%12 * 100;
				_filer.scaleY -= _y;
				_filer.scaleX -= _x;
			} else {
				_x = _count%12 * 100;
				_filer.scaleY += _y;
				_filer.scaleX += _x;
			}
			trace("[Demo/onFrame] x : " + _x);
			_s.filters = [this._filer];
			_count++;
			if (this._count == 24) {
				_count = 0;
				_s.filters = [];
				this.removeEventListener(Event.ENTER_FRAME, onFrame);
				this.stage.addEventListener(MouseEvent.CLICK, onClick);
			}
			// this._bitmapData.applyFilter(this._bitmapData, new Rectangle(0, 0, this._bitmap.width, this._bitmap.height), new Point(), this._filer);
		}

		private function getBitmap() : Bitmap {
			var picWidth : Number = this._bitmap.width;
			var picHeight : Number = this._bitmap.height;
			var endColor : uint = 0xff8080;
			// 红色
			var startColor : uint = 0x008080;
			// 蓝色
			var middleColor : uint = 0x808080;
			// 中间色（灰色）
			var myBitmapData : BitmapData = new BitmapData(picWidth, picHeight);

			function drawMapBitmap(targetData : BitmapData, width : Number, height : Number) : BitmapData {
				var colorDistH : Number = (middleColor - startColor) / picHeight;
				for (var h = 0; h < height; h++) {
					var thisStartColor : uint = startColor + h * colorDistH;
					var thisEndColor : uint = endColor - h * colorDistH;
					var thisColorDistW : Number = (thisEndColor - thisStartColor) / picWidth;
					for (var w = 0; w < width; w++) {
						var pixelColor : uint = thisStartColor + w * thisColorDistW;
						targetData.setPixel(w, h, pixelColor);
					}
				}
				return targetData;
			}
			var myBitmap : Bitmap = new Bitmap(drawMapBitmap(myBitmapData, picWidth, picHeight));
			return myBitmap;
		}
	}
}
