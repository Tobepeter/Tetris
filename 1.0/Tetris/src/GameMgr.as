package {
	import controller.KeyBoardController;
	
	import model.Block;
	import model.BlockFactory;
	import model.GameConfig;
	import model.MapModel;
	
	import view.MapView;
	
	public class GameMgr {
		public function GameMgr() {
			if(GameMgr.s_instance){
				throw("use get instance()");
			}
			this.init();
		}
		
		private static var s_instance: GameMgr;
		public static function get instance(): GameMgr {
			if(!GameMgr.s_instance) {
				GameMgr.s_instance = new GameMgr();
			}
			return GameMgr.s_instance;
		}
		
		
		private var mapView: MapView;
		private function init(): void {
			if(!this.mapView) this.mapView = new MapView();
			Laya.stage.addChild(this.mapView);
			
			KeyBoardController.instance.start();
			this.isLose = false;
		}
		
		public var isLose:Boolean;
		public var isPause: Boolean;
		/**
		 * 开始
		 */
		public function start(): void {
			this.isPause = false;
			Laya.timer.frameLoop(GameConfig.LOOPFRAME, this, this.loopFrameFunc);
			//显示第一帧
			this.loopFrameFunc();
		}
		
		/**
		 * 暂停
		 */
		
		public function pause(): void {
			this.isPause = true;
			Laya.timer.clear(this, this.loopFrameFunc);
		}
		
		public function restart():void {
			this.isLose = false;
			MapModel.instance.clearMap();
			this.start();
		}
		
		public function lose(): void {
			this.isLose = true;
			Laya.timer.clear(this, this.loopFrameFunc);
		}
		
		private function loopFrameFunc(): void {
			if(!MapModel.instance.curBlock){
				MapModel.instance.addBlock(BlockFactory.instance.generateBlock());
			} else {
				MapModel.instance.dropBlock();
			}
			this.mapView.updateView();
		}
		
	}
}
