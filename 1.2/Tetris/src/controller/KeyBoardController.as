package controller {
	import laya.events.Event;
	import laya.events.Keyboard;
	import model.MapModel;
	public class KeyBoardController {

		private static var s_instance:KeyBoardController;

		public static function get instance():KeyBoardController {
			if (!KeyBoardController.s_instance) {
				KeyBoardController.s_instance = new KeyBoardController();
			}
			return KeyBoardController.s_instance;
		}

		public function KeyBoardController() {
			if (KeyBoardController.s_instance) {
				throw("use function get instance()!");
			}
		}

		public function end():void {
			Laya.stage.off(Event.KEY_DOWN, this, this.onKeyDown);
		}

		/**
		 * 开启键盘控制
		 * @desc 按下时候出发一次回调，开一个定时器持续执行回调，在弹起时候初始化时间监听
		 */
		public function start():void {
			// 只实现一次 KEY_DOWN 在回调中结束再次监听
			Laya.stage.once(Event.KEY_DOWN, this, this.onKeyDown);
		}

		private function initEvent():void {
			Laya.stage.off(Event.KEY_DOWN, this, this.onKeyBoard);
			Laya.stage.off(Event.KEY_DOWN, this, this.onLoopFunc);
			Laya.timer.clear(this, this.loopEvent);
			Laya.timer.clear(this, this.loopFunc);

			Laya.stage.once(Event.KEY_DOWN, this, this.onKeyDown);
		}

		private function loopEvent(arr:Array):void {
			var delay:Number = 40;
			Laya.timer.loop(delay, this, this.loopFunc);
		}

		private function loopFunc():void {
			Laya.stage.once(Event.KEY_DOWN, this, this.onLoopFunc);
		}

		private function onKeyBoard(evt:Event):void {
			switch (evt.keyCode) {
				case Keyboard.A:
				case Keyboard.LEFT:
					MapModel.instance.leftBlock();
					break;
				case Keyboard.D:
				case Keyboard.RIGHT:
					MapModel.instance.rightBlock();
					break;
				case Keyboard.S:
				case Keyboard.DOWN:
					MapModel.instance.dropBlockToBottom();
					break;
				case Keyboard.SPACE:
					MapModel.instance.dropBlock();
					break;
				case Keyboard.W:
				case Keyboard.UP:
					MapModel.instance.switchBlock();
					break;
				case Keyboard.P:
				case Keyboard.ESCAPE:
					if (GameMgr.instance.isPause) {
						GameMgr.instance.start();
					} else {
						GameMgr.instance.pause();
					}
					break;
				case Keyboard.R:
					GameMgr.instance.restart();
					break;
				default:
					break;
			}
		}

		/**
		 * 二级定时器
		 * @desc delay之后开启，持续添加监听
		 */
		private function onKeyDown(evt:Event):void {
			this.onKeyBoard(evt);
			var delay:Number = 200;
			Laya.timer.once(delay, this, this.loopEvent, [evt]);
			Laya.stage.once(Event.KEY_UP, this, this.initEvent);
		}

		private function onLoopFunc(evt:Event):void {
			this.onKeyBoard(evt);
		}
	}
}
