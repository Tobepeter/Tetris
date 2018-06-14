package model {
	import core.GameConfig;
	import core.GameMgr;
	import model.MapModel;
	import laya.utils.Log;

	/**
	 * 游戏地图数据类
	 */
	public class MapModel {

		private static var s_instance:MapModel;

		public static function get instance():MapModel {
			return MapModel.s_instance ||= new MapModel();
		}

		public function MapModel() {
			if (MapModel.s_instance) {
				throw("use function get instance()!");
			}
			this.init();
		}

		public var curBlock:Block;
		public var curPos:Array; //当前坐标如 【2，3】

		/**
		 * 初始化地图
		 * @desc 默认为0
		 */
		public var mapArr:Array;

		/**
		 * 添加砖块
		 * @param block 砖块对象
		 * @param pos	砖块位置
		 * @desc 若不传递pos参数，默认从顶部中间开始
		 */
		public function addBlock(block:Block, ... args):void {
			this.curBlock = block;
			var arr:Array = Block.getBlockArr(block.type, block.dir);
			var iLen:Number = 4;
			var jLen:Number = 4;

			var posX:Number = 0;
			var posY:Number = GameConfig.HBLOCK_NUM / 2 - 2;
			this.curPos = [posX, posY];
			for (var i:Number = 0; i < iLen; i++) {
				for (var j:Number = 0; j < jLen; j++) {
					if (this.mapArr[posX + i][posY + j] != 0) {
						GameMgr.ins.lose();
						return;
					}
					this.mapArr[posX + i][posY + j] = arr[i][j];
				}
			}
		}

		/**
		 * 检查阴影位置，并在地图上赋值3
		 * @desc 使用当前砖块形状，位置，从最底往上摆，直到不和2重叠
		 */
		public function cheakShadow():void {
			if(!GameConfig.USE_SHADOW){
				return;
			}
			if (!this.curBlock){
				return;
			}
			if (!this.canDropBlock()){
				return;
			}
				
			// 清理所有3的位置，TODO，可以考虑记忆位置，减少循环次数
			for (var i:Number = 0, iLen:Number = this.mapArr.length; i < iLen; i++) {
				for (var j:Number = 0, jLen:Number = this.mapArr[0].length; j < jLen; j++) {
					if (this.mapArr[i][j] == 3)
						this.mapArr[i][j] = 0;
				}
			}

			// 从curPos[0]开始往下，找到1(运动的砖块)，让1往下看，一次循环加一次距离，直到找到2或者越界，终止循环
			// 在上诉结果中考虑和运动钻快阴影碰撞时不显示
			var hasFound:Boolean;
			for (var i1:Number = 0, i1Len:Number = this.mapArr.length; i1 < i1Len; i1++) {
				hasFound = false;
				for (var j1:Number = 3; j1 >= 0; j1--) {
					for (var k1:Number = 0, k1Len:Number = 4; k1 < k1Len; k1++) {
						if (this.mapArr[this.curPos[0] + j1] == undefined) {
							break;
						}
						if (this.mapArr[this.curPos[0] + j1][this.curPos[1] + k1] == 1) {
							// 判断墙，固定砖块
							if (this.mapArr[this.curPos[0] + j1 + i1] == undefined) {
								hasFound = true;
								break;
							}
							if (this.mapArr[this.curPos[0] + j1 + i1][this.curPos[1] + k1] == 2) {
								hasFound = true;
								break;
							}
						}
					}

					if (hasFound){
						break;
					}	
				}

				// 判断下落点是否重合【1】 - 刷新阴影 -- 跳出循环
				// 这里注意改变i可能影响主循环，不过这里的改变直接跳出，因此没有影响
				if (hasFound) {
					var dropDis:Number = i1 - 1;
					if (dropDis == 0)
						return;
					for (var i2:Number = 0; i2 < 4; i2++) {
						for (var j2:Number = 0; j2 < 4; j2++) {
							if(this.mapArr[this.curPos[0] + i2 + dropDis] == undefined) break;
							if (this.mapArr[this.curPos[0] + i2 + dropDis][this.curPos[1] + j2] == 1) {
								return;
							}
						}
					}
					for (var i3:Number = 0; i3 < 4; i3++) {
						for (var j3:Number = 0; j3 < 4; j3++) {
							if (this.mapArr[this.curPos[0] + i3][this.curPos[1] + j3] == 1) {
								this.mapArr[this.curPos[0] + i3 + dropDis][this.curPos[1] + j3] = 3;
							}
						}
					}
					break;
				}
			}
		}

		/**
		 * 清空地图
		 */
		public function clearMap():void {
			if (!this.mapArr)
				this.init();
			for (var i:Number = 0, iLen:Number = GameConfig.VBLOCK_NUM; i < iLen; i++) {
				for (var j:Number = 0, jLen:Number = GameConfig.HBLOCK_NUM; j < jLen; j++) {
					this.mapArr[i][j] = 0;
				}
			}
			this.curBlock = null;
		}

		/**
		 * 下落砖块
		 * @desc 由于地图移动砖块只有1，所以直接让地图的1降落即可
		 */
		public function dropBlock():void {
			// 由于是下落，为避免重叠，从下往上判断
			// 注意最低点未必代表可以降落
			if (!this.curBlock)
				return;
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

			if (!canDrop) {
				this.curBlock = null;
				this.clearBlockLine();
			} else {
				this.curPos[0]++;
			}
		}

		/**
		 * 直接降落到地步
		 */
		public function dropBlockToBottom():void {
			while (this.canDropBlock()) {
				this.dropBlock();
			}
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
		 * 旋转砖块
		 */
		public function switchBlock():void {
			if (!this.canSwitchBlock() || !this.curBlock)
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
		 * 是否可降落砖块
		 */
		private function canDropBlock():Boolean {
			if (!this.curBlock)
				return false;
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
		 * 是否可右移砖块
		 */
		private function canRightBlock():Boolean {
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
			if (this.curBlock)
				return;
			var clearLine:Number;
			var canClear:Boolean;
			var i:Number;
			var j:Number;
			var k:Number;
			var hasClear:Boolean = false;
			var clearRows:Vector.<Number> = new Vector.<Number>();
			for (i = 0; i < 4; i++) {
				canClear = true;
				for (j = this.mapArr[0].length - 1; j >= 0; j--) {
					if (this.mapArr[this.curPos[0] + i] == undefined) {
						canClear = false;
						break;
					}
					if (this.mapArr[this.curPos[0] + i][j] != 2) {
						canClear = false;
						break;
					}
				}
				if (canClear) {
					clearLine = this.curPos[0] + i;
					if (clearLine == 0)
						return;
					
					// 在消除行的上方全部下移
					for (k = clearLine; k > 0; k--) {
						for (j = this.mapArr[0].length - 1; j >= 0; j--) {
							this.mapArr[k][j] = this.mapArr[k - 1][j];
							this.mapArr[k - 1][j] = 0;
						}
					}
					clearRows.push(clearLine);
					
					// 统计行最后播放特效
					hasClear = true;
				}
			}
			
			// 播放消除特效
			if(GameConfig.USE_CLEAR_EFFECT && hasClear) {
				ClearEffectModel.instance.showOnRows(clearRows);
			}
		}

		/**
		 * 降落消除行
		 * @desc 理论上需要在消除内一起发生，但是可能为了动画需要，可不为一帧内发生
		 */
		private function clearFallBlock():void {
			if (this.curBlock)
				return;
			var i:Number;
			var j:Number;
			var iLen:Number;
			var jLen:Number;
			// 找到固定砖块的顶部行,由于下边的逻辑是嵌套2曾循环，理论上尽量找到砖块的顶部比较节省计算时间
			var headBlockLine:Number = this.mapArr.length - 1;
			var hasFound:Boolean;
			for (i = 0, iLen = this.mapArr.length; i < iLen; i++) {
				hasFound = false;
				for (j = 0, jLen = this.mapArr[0].length; j < jLen; j++) {
					if (this.mapArr[i][j] == 2) {
						headBlockLine = i;
						hasFound = true;
						break;
					}
				}
				if (hasFound) {
					break;
				}
			}
			if (headBlockLine == this.mapArr.length - 1 || headBlockLine == 0)
				return;

			var canFall:Boolean;
			var fallLine:Number;
			var fallLineNum:Number;
			var k:Number;
			var kLen:Number;
			for (i = headBlockLine; i < this.mapArr.length; i++) {
				canFall = true;
				for (j = this.mapArr[0].length; j >= 0; j--) {
					if (this.mapArr[i][j] == 2) {
						canFall = false;
						break;
					}
				}
				if (canFall) {
					// 向下最多判断多3行（共四行）注意数组越界问题
					// 如果找到立刻停止循环，得到fallLineNum
					fallLineNum = 1;
					fallLine = i;
					hasFound = false;
					for (k = 0; k < 4; k++) {
						for (j = this.mapArr[0].length - 1; j >= 0; j--) {
							if (this.mapArr[fallLine + k] == undefined)
								hasFound = true;
							break;
							if (this.mapArr[fallLine + k][j] != 0)
								hasFound = true;
							break;
						}
						if (hasFound) {
							break;
						} else {
							fallLineNum++;
						}
					}

					//降落fallLineNum行
//					for (j = this.mapArr[0].length-1; j >= 0; j--) {
//						this.mapArr[i-1+fallLineNum][j] = this.mapArr[i-1][j];
//						this.mapArr[i-1][j] = 0;
//					}

					for (k = fallLine - 1; k >= headBlockLine; k--) {
						for (j = this.mapArr[0].length - 1; j >= 0; j--) {
							this.mapArr[k + fallLineNum][j] = this.mapArr[k][j];
							this.mapArr[k][j] = 0;
						}
					}
				}
			}
		}

		private function init():void {
			if (!this.mapArr)
				this.mapArr = [];
			for (var i:Number = 0, iLen:Number = GameConfig.VBLOCK_NUM; i < iLen; i++) {
				var arr:Array = [];
				// this.mapArr.push(arr);
				for (var j:Number = 0, jLen:Number = GameConfig.HBLOCK_NUM; j < jLen; j++) {
					arr.push(0);
				}
				this.mapArr.push(arr);				
			}
		}
	}
}
