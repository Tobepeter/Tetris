package core {
	import laya.display.Sprite;

	/**
	 * 游戏层级类
	 */
	public class LayerMgr {
		public var effectLayer:Sprite;
		public var mainLayer:Sprite;
		private static var s_instance:LayerMgr;

		public static function get instance():LayerMgr {
			if (!LayerMgr.s_instance) {
				LayerMgr.s_instance = new LayerMgr();
			}
			return LayerMgr.s_instance;
		}

		public function LayerMgr() {
			if (LayerMgr.s_instance) {
				throw new Error("use function get instance()!");
			}
			this.init();
		}

		private function init():void {
			this.mainLayer = new Sprite();
			this.effectLayer = new Sprite();

			Laya.stage.addChild(this.mainLayer);
			Laya.stage.addChild(this.effectLayer);
		}
	}
}
