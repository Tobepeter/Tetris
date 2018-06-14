package model {

	public class MapModel {
		public function MapModel() {
			if (MapModel.s_instance) {
				throw("use get instance()");
			}
			this.init();
		}

		private static var s_instance:MapModel;

		public static function get instance():MapModel {
			if (!MapModel.s_instance) {
				MapModel.s_instance = new MapModel();
			}
			return MapModel.s_instance;
		}

		/**
		 * 初始化地图
		 * @desc 默认为0
		 */
		public var mapArr:Array;

		private function init():void {
			if (!this.mapArr)
				this.mapArr = [];
			for (var i:Number = 0, iLen:Number = GameConfig.VBLOCKNUM; i < iLen; i++) {
				var arr:Array = [];
				this.mapArr.push(arr);
				for (var j:Number = 0, jLen:Number = GameConfig.HBLOCKNUM; j < jLen; j++) {
					arr.push(0);
				}
			}
		}
		
		/**
		 * 清空地图
		 */
		public function clearMap():void{
			if (!this.mapArr) this.init();
			for (var i:Number = 0, iLen:Number = GameConfig.VBLOCKNUM; i < iLen; i++) {
				for (var j:Number = 0, jLen:Number = GameConfig.HBLOCKNUM; j < jLen; j++) {
					this.mapArr[i][j] = 0;
				}
			}
			this.curBlock = null;
		}

		public var curBlock:Block;
		public var curPos:Array; //当前坐标如 【2，3】

		/**
		 * 添加砖块
		 * @param block 砖块对象
		 * @param pos	砖块位置
		 * @desc 若不传递参数，默认从顶部中间开始
		 */
		public function addBlock(block:Block, ... args):void {
			this.curBlock = block;
			var arr:Array = Block.getBlockArr(block.type, block.dir);
			var iLen:Number = 4;
			var jLen:Number = 4;

			var posX:Number = 0;
			var posY:Number = GameConfig.HBLOCKNUM / 2 - 2;
			this.curPos = [posX, posY];
			for (var i:Number = 0; i < iLen; i++) {
				for (var j:Number = 0; j < jLen; j++) {
					// TODO isDead
					if (this.mapArr[posX + i][posY + j] == 2 && arr[i][j] == 1) {
						GameMgr.instance.lose();
						return;
					}
					this.mapArr[posX + i][posY + j] = arr[i][j];
				}
			}
		}

		/**
		 * 下落砖块
		 * @desc 由于地图移动砖块只有1，所以直接让地图的1降落即可
		 */
		public function dropBlock():void {
			// 由于是下落，为避免重叠，从下往上判断
			// 注意最低点未必代表可以降落
			if(!this.curBlock) return;
			var canDrop:Boolean = this.canDropBlock();
			for (var i:Number = this.mapArr.length - 1; i >= 0; i--) {
				for (var j:Number = 0, jLen:Number = this.mapArr[0].length; j < jLen; j++) {
					if (this.mapArr[i][j] == 1) {
						if (!canDrop) {
							this.mapArr[i][j] = 2;	
						} else {
							this.mapArr[i][j] = 0;
							this.mapArr[i + 1][j] = 1;
						}
					}
				}
			}
			
			if(!canDrop) {
				// TODO 处理消行
				this.curBlock = null;
				this.clearBlockLine();
				this.clearFallBlock();
			} else{
				this.curPos[0]++;
			}
		}
		
		/**
		 * 直接降落到地步
		 */
		public function dropBlockToBottom(): void{
			while(this.canDropBlock()) {
				this.dropBlock();
			}
		}

		/**
		 * 是否可降落砖块
		 */
		private function canDropBlock():Boolean {
			if(!this.curBlock) return false;
			for (var i:Number = this.mapArr.length - 1; i >= 0; i--) {
				for (var j:Number = 0, jLen:Number = this.mapArr[0].length; j < jLen; j++) {
					if (this.mapArr[i][j] == 1) {
						if (this.mapArr[i + 1] == undefined)
							return false;
						if (this.mapArr[i + 1][j] == 2)
							return false;
					}
				}
			}
			return true;
		}

		/**
		 * 左移砖块
		 */
		public function leftBlock():void {
			if (!this.canLeftBlock() || !this.curBlock)
				return;
			for (var i:Number = this.mapArr.length - 1; i >= 0; i--) {
				for (var j:Number = 0, jLen:Number = this.mapArr[0].length; j < jLen; j++) {
					if (this.mapArr[i][j] == 1) {
						this.mapArr[i][j] = 0;
						this.mapArr[i][j - 1] = 1;
					}
				}
			}
			this.curPos[1]--;
		}

		/**
		 * 是否可左移砖块
		 * @desc 从下方判断，如果左移越界，如果左移遇到固定砖块，则false
		 */
		private function canLeftBlock():Boolean {
			for (var i:Number = this.mapArr.length - 1; i >= 0; i--) {
				for (var j:Number = 0, jLen:Number = this.mapArr[0].length; j < jLen; j++) {
					if (this.mapArr[i][j] == 1) {
						if (this.mapArr[i][j - 1] == undefined)
							return false;
						if (this.mapArr[i][j - 1] == 2)
							return false;
					}
				}
			}
			return true;
		}

		/**
		 * 右移砖块
		 */
		public function rightBlock():void {
			if (!this.canRightBlock() || !this.curBlock)
				return;
			for (var i:Number = this.mapArr.length - 1; i >= 0; i--) {
				for (var j:Number = this.mapArr[0].length - 1; j >= 0; j--) {
					if (this.mapArr[i][j] == 1) {
						this.mapArr[i][j] = 0;
						this.mapArr[i][j + 1] = 1;
					}
				}
			}
			this.curPos[1]++;
		}

		/**
		 * 是否可右移砖块
		 */
		public function canRightBlock():Boolean {
			for (var i:Number = this.mapArr.length - 1; i >= 0; i--) {
				for (var j:Number = this.mapArr[0].length - 1; j >= 0; j--) {
					if (this.mapArr[i][j] == 1) {
						if (this.mapArr[i][j + 1] == undefined)
							return false;
						if (this.mapArr[i][j + 1] == 2)
							return false;
					}
				}
			}
			return true;
		}


		/**
		 * 旋转砖块
		 */
		public function switchBlock():void {
			if (!this.canSwitchBlock()  || !this.curBlock)
				return;
			var nextDir:Number = (this.curBlock.dir + 1) % 4;
			var nextArr:Array = Block.getBlockArr(this.curBlock.type, nextDir);

			var i:Number;
			var j:Number;
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					if (this.mapArr[this.curPos[0] + i][this.curPos[1] + j] == 1) {
						this.mapArr[this.curPos[0] + i][this.curPos[1] + j] = 0;
					}
				}
			}
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					if (nextArr[i][j] == 1) {
						this.mapArr[this.curPos[0] + i][this.curPos[1] + j] = 1;
					}
				}
			}
			this.curBlock.dir = (this.curBlock.dir + 1) % 4;
		}

		/**
		 * 是否可旋转砖块
		 * @desc 考虑下一个状态，是否越界，是否和固定装快碰撞
		 * @desc 考虑下一状态是否能在地图上取出来
		 */
		private function canSwitchBlock():Boolean {
			if (!this.curBlock)
				return false;
			var nextDir:Number = (this.curBlock.dir + 1) % 4;
			var nextArr:Array = Block.getBlockArr(this.curBlock.type, nextDir);
			for (var i:Number = 0; i < 4; i++) {
				for (var j:Number = 0; j < 4; j++) {
					if (nextArr[i][j] == 1) {
						if (this.mapArr[this.curPos[0] + i] == undefined)
							return false;
						if (this.mapArr[this.curPos[0] + i][this.curPos[1] + j] == undefined)
							return false;
						if (this.mapArr[this.curPos[0] + i][this.curPos[1] + j] == 2)
							return false;
					}
				}
			}
			return true;
		}

		/**
		 * 砖块消行
		 * @desc 默认砖块不可下落时候调用
		 * @desc 消除地图中的一行2
		 */
		private function clearBlockLine():void {
			if(this.curBlock) return;
			var curLine:Number = this.curPos[0];

			var canClear:Boolean;
			var i:Number;
			var j:Number;
			for (i = 0; i < 4; i++) {
				canClear = true;
				for (j = this.mapArr[0].length - 1; j >= 0; j--) {
					if(this.mapArr[curLine + i] == undefined) {
						canClear = false;
						break;
					}
					if (this.mapArr[curLine + i][j] != 2) {
						canClear = false;
						break;
					}
				}

				if (canClear) {
					for (j = this.mapArr[0].length - 1; j >= 0; j--) {
						this.mapArr[curLine + i][j] = 0;
					}
				}
			}
		}

		/**
		 * 降落消除行
		 * @desc 理论上需要在消除内一起发生，但是可能为了动画需要，可不为一帧内发生
		 */
		public function clearFallBlock():void {
			if(this.curBlock) return;
			var i:Number;
			var j: Number;
			var canFall:Boolean

			var hasFall:Boolean = true;

			while(hasFall) {
				hasFall = false;
				for (i = this.mapArr.length-1; i >= 0; i--) {
					canFall = true;
					for (j = this.mapArr[0].length; j >= 0; j--) {
					if (this.mapArr[i][j] == 2) {
							canFall = false;
							break;
						}
					}
					if(i == 0) canFall = false;
					if(canFall){
						hasFall = true;
						for (j = this.mapArr[0].length-1; j >= 0; j--) {
							this.mapArr[i][j] = this.mapArr[i-1][j];
							this.mapArr[i-1][j] = 0;
						}
					}
				}
			}
			
		}

		
		
	}
}
