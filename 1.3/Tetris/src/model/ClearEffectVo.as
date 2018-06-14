package model
{
	import core.GameConfig;
	
	import laya.display.Sprite;

	/**
	 * 清除特效单个砖块数据
	 */
	public class ClearEffectVo {
		
		public function ClearEffectVo() {
			this.sp = new Sprite();
			var size:Number = GameConfig.BLOCK_SIZE;
			var clipLen:Number = size / 20 >> 0;
			var clipSize:Number = size - 2 * clipLen;
			this.sp.graphics.drawRect(0, 0, clipSize, clipSize, '#000000');
			ClearEffectVo.resetVo(this);
		}
		
		public var vX: Number;

		public var vY: Number;

		public var gY: Number;

		public var vRot: Number;

		public var sp: Sprite;

		/**
		 * 重置vo
		 * @param vo 消除特效对象
		 * @param x	 x位置
		 * @param y  y位置
		 */
		public static function resetVo(vo: ClearEffectVo, ... args):void {
			var size:Number = GameConfig.BLOCK_SIZE;
			var clipLen:Number = size / 20 >> 0;
			var clipSize:Number = size - 2 * clipLen;
			if(args[0] != undefined) vo.sp.x = args[0];
			if(args[1] != undefined) vo.sp.y = args[1];
			vo.sp.rotation = 0;
			vo.sp.alpha = 1;
			vo.vY = -(Math.random() * 20 + 10) >> 0; // -20 ~ -30
			vo.vX = (Math.random() * 2 - 1) * 2 >> 0; // -2 ~ 2
			vo.gY = 2;
			vo.vRot = (Math.random() * 2 - 1) * 5 >> 0; // -5 ~ 5
		}
	}

}