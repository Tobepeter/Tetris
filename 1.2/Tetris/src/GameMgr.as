package {
	import controller.KeyBoardController;
	import laya.utils.Browser;
	import model.BlockFactory;
	import model.GameConfig;
	import model.MapModel;
	import view.MapView;
	public class GameMgr {

		private static var s_instance:GameMgr;

		public static function get instance():GameMgr {
			if (!GameMgr.s_instance) {
				GameMgr.s_instance = new GameMgr();
			}
			return GameMgr.s_instance;
		}

		public function GameMgr() {
			if (GameMgr.s_instance) {
				throw("use get instance()");
			}
			this.init();
		}

		public var blockSpeed:Number;
		public var curFrame:Number;

		public var isLose:Boolean;
		public var isPause:Boolean;


		private var mapView:MapView;
		private var now:Number;
	
		private var secondStamp:Number=0;

		/**
		 * 结束
		 */
		public function lose():void {
			this.isLose = true;
			Laya.timer.clear(this, this.loopFrameFunc);
		}

		/**
		 * 暂停
		 */
		public function pause():void {
			this.isPause = true;
			Laya.timer.clear(this, this.loopFrameFunc);
		}

		/**
		 * 重开
		 */
		public function restart():void {
			this.isLose = false;
			MapModel.instance.clearMap();
			this.start();
		}

		/**
		 * 开始
		 */
		public function start():void {
			this.isPause = false;
			Laya.timer.frameLoop(1, this, this.loopFrameFunc);
			this.loopFrameFunc();

		}

		private function init():void {
			if (!this.mapView)
				this.mapView = new MapView();
			Laya.stage.addChild(this.mapView);

			KeyBoardController.instance.start();
			this.isLose = false;
			this.curFrame = 0;
			this.blockSpeed = GameConfig.BLOCK_SPEED;
		}
		/**
		 * 主帧循环
		 */
		private function loopFrameFunc():void {
			this.curFrame++;
			if(this.curFrame>1000000) this.curFrame = 0;
			now=Browser.now();
			if(now-this.secondStamp>1000){
				now=this.secondStamp;
				updateSecond();
			}
			this.updateBlock();
			
		}
		
		private function updateBlock(): void{
			if (this.curFrame % this.blockSpeed == 0) {
				if (!MapModel.instance.curBlock) {
					MapModel.instance.addBlock(BlockFactory.instance.generateBlock());
					//test
//					MapModel.instance.addBlock(BlockFactory.instance.generateBlock(3,1));
				} else {
					MapModel.instance.dropBlock();
				}		
			}
		}
		
		private function updateSecond():void {
			MapModel.instance.cheakShadow();
			this.mapView.updateView();		
		}
	}
}
