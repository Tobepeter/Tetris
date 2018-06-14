package utils {
	import core.GameMgr;

	import laya.debug.DebugPanel;

	import model.ClearEffectModel;
	import laya.display.Sprite;

	/**
	 * 功能测试类
	 * @desc 建议清空舞台或者在入口处调用
	 */
	public class TestCenter {

		private static var s_instance:TestCenter;

		public static function get instance():TestCenter {
			if (!TestCenter.s_instance) {
				TestCenter.s_instance = new TestCenter();
			}
			return TestCenter.s_instance;
		}

		public function TestCenter() {
			if (TestCenter.s_instance) {
				throw("use function get instance()!");
			}
		}

		/**
		 * 测试清除特效
		 */
		public function clearEffect():void {
			Laya.stage.addChild(ClearEffectModel.instance.effectCtn);
			var vec:Vector.<Number> = new Vector.<Number>();
			vec.push(29, 27, 25);
			ClearEffectModel.instance.showOnRows(vec);
		}

		/**
		 * 使用调试面板
		 */
		public function useDebug():void {
			DebugPanel.init();
		}

		/**
		 * 随意代码测试（注意删除）
		 */
		 public function test(): void{
			 import laya.events.Event;
			 Laya.stage.on(Event.CLICK, this, this.foo);
		 }

		 private function foo():void{
			 
		 }
		 
	}
}
