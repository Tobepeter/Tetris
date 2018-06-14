package {
	import laya.display.Stage;
	import laya.events.Event;
	
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
			var width:Number = GameConfig.HBLOCKNUM * GameConfig.BLOCKSIZE;
			var height:Number = GameConfig.VBLOCKNUM * GameConfig.BLOCKSIZE
			Laya.init(width, height);
			Laya.stage.alignH = laya.display.Stage.ALIGN_CENTER;
			Laya.stage.alignV = laya.display.Stage.ALIGN_MIDDLE;
			Laya.stage.bgColor = '#cccccc';
		}
	}
}
