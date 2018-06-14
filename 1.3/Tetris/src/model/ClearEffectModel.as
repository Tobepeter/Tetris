package model {
	import core.GameConfig;
	import laya.display.Sprite;
	import laya.utils.Pool;

	/**
	 * 清除特效数据类
	 */
	public class ClearEffectModel {

		private static var _instance:ClearEffectModel;

		public static function get instance():ClearEffectModel {
			if (!ClearEffectModel._instance) {
				ClearEffectModel._instance = new ClearEffectModel();
			}
			return ClearEffectModel._instance;
		}

		public function ClearEffectModel() {
			if (ClearEffectModel._instance) {
				throw new Error("use function get instance()!");
			}
			this.init();
		}
		
		// 此为暴露的容器面板，使用此面板再调用方法即可
		public var effectCtn:Sprite;
		private var effectArr:Vector.<ClearEffectVo>;

		// public function addPoint(x, y):void {
		// 	var vo:ClearEffectVo = new ClearEffectVo();
		// 	this.effectArr.push(vo);
		// }

		public function showOnRows(rows:Vector.<Number>):void {
			// 初始化数组
			this.effectArr.length = 0;
			var iLen:Number = rows.length;
			var jLen:Number = rows.length * GameConfig.HBLOCK_NUM;
			var size:Number = GameConfig.BLOCK_SIZE;
			var clipLen:Number = size / 20 >> 0;
			var clipSize:Number = size - 2 * clipLen;
			for (var i:Number = 0; i < iLen; i++) {
				var y:Number = clipLen + rows[i] * size;
				for (var j:Number = 0; j < jLen; j++) {
					var x:Number = clipLen + j * size;
					var vo:ClearEffectVo = Pool.getItemByClass('ClearEffectVo', ClearEffectVo);
					ClearEffectVo.resetVo(vo, x, y);
					this.effectArr.push(vo);
					this.effectCtn.addChild(vo.sp);
				}
			}
			// 根据数组进行显示
			Laya.timer.loop(20, this, this.onLoop);
			Laya.timer.once(2000, this, this.stopLoop);
		}

		private function init():void {
			this.effectCtn = new Sprite();
			this.effectArr = new Vector.<ClearEffectVo>();
		}

		private function onLoop():void {
			for (var i:Number = 0, iLen:Number = this.effectArr.length; i < iLen; i++) {
				var vo:ClearEffectVo = this.effectArr[i]
				vo.sp.y += vo.vY;
				vo.vY += vo.gY;
				vo.sp.x += vo.vX;
				vo.sp.rotation += vo.vRot;
				vo.sp.alpha -= 0.03;
			}
		}


		private function resetVo():void {
			for (var i:Number = 0, iLen:Number = this.effectArr.length; i < iLen; i++) {
				var vo:ClearEffectVo = this.effectArr[i];
				Pool.recover('ClearEffectVo', vo);
			}
		}

		private function stopLoop():void {
			this.effectCtn.removeChildren();
			Laya.timer.clear(this, this.onLoop);
		}
	}
}
