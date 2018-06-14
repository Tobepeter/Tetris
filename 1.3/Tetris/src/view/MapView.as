package view {
	import laya.display.Sprite;
	import core.GameConfig;
	import model.MapModel;

	/**
	 * 游戏地图显示类
	 */
	public class MapView extends Sprite {
		public function MapView() {
			super();
			this.updateView();
		}

		public function updateView():void {
			var arr:Array = MapModel.instance.mapArr;
			var color:String;
			var size:Number = GameConfig.BLOCK_SIZE;
			this.graphics.clear();
			for (var i:Number = 0, iLen:Number = arr.length; i < iLen; i++) {
				for (var j:Number = 0, jLen:Number = arr[0].length; j < jLen; j++) {
					if (arr[i][j] == 0)
						continue;

					switch (arr[i][j]) {
						case 1:
							color = '#555555';
							break;
						case 2:
							color = '#000000';
							break;
						case 3:
							color = '#999999';
							break;
						default:
							color = '#000000';
							break;
					}
					var x:Number = j * size;
					var y:Number = i * size;

					// 砖块白边大小
					var clipLen:Number = GameConfig.BLOCK_SIZE / 20 >> 0;
//					this.graphics.drawRect(x, y, size, size, color);
					var clipSize: Number = size - 2 * clipLen;
					this.graphics.drawRect(x + clipLen, y + clipLen, size - 2 * clipLen, size - 2 * clipLen, color);
				}
			}
		}
	}
}
