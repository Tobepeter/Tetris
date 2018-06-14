package model {
	public class BlockFactory {

		private static var s_instance: BlockFactory;

		public static function get instance():BlockFactory {
			if (!BlockFactory.s_instance) {
				BlockFactory.s_instance = new BlockFactory();
			}
			return BlockFactory.s_instance;
		}

		public function BlockFactory() {
			if (BlockFactory.s_instance) {
				throw("use get instance()");
			}
		}

		/**
		 * 生成砖块
		 * @param type Block类中的类型
		 * @param dir Block类中的方向
		 * @desc 若不传递参数，则默认随机器
		 */
		public function generateBlock(... args): Block {
			var type: Number;
			if (args[0] != undefined) {
				type = args[0];
			} else {
				type = Math.random() * Block.ALLBLOCK.length >> 0;
			}

			var dir:Number;
			if (args[1] != undefined) {
				dir = args[1];
			} else {
				dir = Math.random() * Block.ALLBLOCK[0].length >> 0;
			}

			return new Block(type, dir);
		}
	}
}
