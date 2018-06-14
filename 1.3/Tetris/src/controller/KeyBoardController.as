package controller {
	import laya.events.Event;
	import laya.events.Keyboard;
	import model.MapModel;
	import core.GameMgr;

	/**
	 * 键盘控制类
	 */
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
		
		/***** 一下有种代码选择，暂时不选择这一种 *****/
		// // 键盘按下生命周期			未按下 -- 按下 第一次 未进入循环 -- 按下 非第一次 未进入循环 -- 按下 非第一次 进入循环 -- 未按下
		// // 注意定时器设置 -- 弹起后不能进入循环	
		// // TODO 建议把上述声明周期弄成状态机
		// // TODO 这里逻辑依赖太大，需要依赖到游戏主循环，考虑优化，或者考虑这个是否能归为游戏循环
		// // TODO 旧代码不需要依赖到主循环逻辑，依靠自身定时器完成
		// public var isKeyDown: Boolean = false;	// 是否按下
		// public var isFirstKey: Boolean = true;	// 是否第一次按下
		// public var isKeyLoop: Boolean = false;	// 是否已经进入循环
		// public var KeyEvent: Event = null;

		// public function start(): void{
		// 	Laya.stage.on(Event.KEY_DOWN, this, this.onKeyDown);
		// 	Laya.stage.on(Event.KEY_UP, this, this.onKeyUp);
		// }

		// public function end(): void{
		// 	Laya.stage.off(Event.KEY_DOWN, this, this.onKeyDown);
		// 	Laya.stage.off(Event.KEY_UP, this, this.onKeyUp);
		// }

		
		// private function onKeyDown(e:Event): void{
		// 	this.KeyEvent = e;
		// 	this.isKeyDown = true;
		// }
		
		// private function onKeyUp(e:Event):void{
		// 	this.KeyEvent = null;
		// 	this.isKeyDown = false;
		// 	this.isFirstKey = true;
		// 	this.isKeyLoop = false;
		// }

		// public function onKeyBoard(evt:Event):void {
		// 	switch (evt.keyCode) {
		// 		case Keyboard.A:
		// 		case Keyboard.LEFT:
		// 			MapModel.instance.leftBlock();
		// 			break;
		// 		case Keyboard.D:
		// 		case Keyboard.RIGHT:
		// 			MapModel.instance.rightBlock();
		// 			break;
		// 		case Keyboard.S:
		// 		case Keyboard.DOWN:
		// 			MapModel.instance.dropBlockToBottom();
		// 			break;
		// 		case Keyboard.SPACE:
		// 			MapModel.instance.dropBlock();
		// 			break;
		// 		case Keyboard.W:
		// 		case Keyboard.UP:
		// 			MapModel.instance.switchBlock();
		// 			break;
		// 		case Keyboard.P:
		// 		case Keyboard.ESCAPE:
		// 			if (GameMgr.instance.isPause) {
		// 				GameMgr.instance.start();
		// 			} else {
		// 				GameMgr.instance.pause();
		// 			}
		// 			break;
		// 		case Keyboard.R:
		// 			GameMgr.instance.restart();
		// 			break;
		// 		default:
		// 			break;
		// 	}
		// }



		/***** 另一种代码 *****/
		/**
		 * 关闭键盘控制
		 */
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
		 			if (GameMgr.ins.isPause) {
		 				GameMgr.ins.start();
		 			} else {
		 				GameMgr.ins.pause();
		 			}
		 			break;
		 		case Keyboard.R:
		 			GameMgr.ins.restart();
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
