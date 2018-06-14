package {
	import core.GameConfig;
	import core.GameMgr;
	import laya.display.Stage;
	import utils.TestCenter;
	/**
	 * 游戏入口类
	 */
	public class Main {

		public function Main() {
			this.init();
		}

		private function init():void {
			this.initStage();
			GameMgr.ins.start();
			// TestCenter.instance.test();
		}

		private function initStage():void {
			var width:Number = GameConfig.HBLOCK_NUM * GameConfig.BLOCK_SIZE;
			var height:Number = GameConfig.VBLOCK_NUM * GameConfig.BLOCK_SIZE
			Laya.init(width, height);
			Laya.stage.alignH = laya.display.Stage.ALIGN_CENTER;
			Laya.stage.alignV = laya.display.Stage.ALIGN_MIDDLE;
			Laya.stage.bgColor = '#cccccc';
		}
	}
}
