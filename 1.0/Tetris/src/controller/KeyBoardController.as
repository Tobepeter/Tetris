package controller {
	import laya.events.Event;
	import laya.events.Keyboard;

	import model.MapModel;

	public class KeyBoardController {
		public function KeyBoardController() {
			if (KeyBoardController.s_instance) {
				throw("use function get instance()!");
			}
		}

		private static var s_instance:KeyBoardController;

		public static function get instance():KeyBoardController {
			if (!KeyBoardController.s_instance) {
				KeyBoardController.s_instance = new KeyBoardController();
			}
			return KeyBoardController.s_instance;
		}

		public function start():void {
			Laya.stage.on(Event.KEY_UP, this, this.onKeyUp);
		}

		public function end():void {
			Laya.stage.off(Event.KEY_PRESS, this, this.onKeyUp);
		}

		private function onKeyUp(evt:Event):void {
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
//					MapModel.instance.dropBlock();
					MapModel.instance.dropBlockToBottom();
					break;
				case Keyboard.SPACE:
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


	}
}
