package core {
	import controller.KeyBoardController;
	import laya.utils.Browser;
	import model.BlockFactory;
	import model.ClearEffectModel;
	import model.MapModel;
	import view.MapView;
	/**
	 * 游戏管理类（启动，停止）
	 */
	public class GameMgr {
		public var blockSpeed:Number;
		public var curFrame:Number;
		public var isLose:Boolean;
		public var isPause:Boolean;
		private var keyBoardStamp:Number=0;
		private var mapView:MapView;
		private var now:Number;
		private var secondStamp:Number=Browser.now();

		private static var _ins:GameMgr;
		public static function get ins():GameMgr {
			if (!GameMgr._ins) {
				GameMgr._ins = new GameMgr();
			}
			return GameMgr._ins;
		}

		public function GameMgr() {
			if (GameMgr._ins) {
				throw("use get instance()!");
			}
			this.init();
		}

		private function init():void {
			this.mapView = new MapView();
			LayerMgr.instance.mainLayer.addChild(this.mapView);
			LayerMgr.instance.effectLayer.addChild(ClearEffectModel.instance.effectCtn);
			
			KeyBoardController.instance.start();
			this.isLose = false;
			this.curFrame = 0;
			this.blockSpeed = GameConfig.BLOCK_SPEED;
		}

	
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

		
		/**
		 * 主帧循环
		 */
		private function loopFrameFunc():void {
			this.curFrame++;
			if(this.curFrame>1000000) this.curFrame = 0;

			// 下落和生成砖块
			if (this.curFrame % 25 == 0) {
				this.updateBlock();
			}

			// 200ms循环
			now=Browser.now();
			if(now-secondStamp>200){
				secondStamp = now;
				update200();
			}
		}
		
		private function updateBlock(): void {
			if (!MapModel.instance.curBlock) {
				MapModel.instance.addBlock(BlockFactory.instance.generateBlock());
			} else {
				MapModel.instance.dropBlock();
			}		
		}
		
		private function update200():void {
			MapModel.instance.cheakShadow();
			this.mapView.updateView();		
		}
	}
}
