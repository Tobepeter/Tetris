package {
	import laya.display.Stage;
	import model.GameConfig;
	public class Main {

		public function Main() {
			this.init();
		}

		private function init():void {
			this.initStage();
			GameMgr.instance.start();
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
