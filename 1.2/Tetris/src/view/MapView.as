package view {
	import laya.display.Sprite;
	import model.GameConfig;
	import model.MapModel;
	public class MapView extends Sprite {
		public function MapView() {
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
					var clipLen:Number = GameConfig.BLOCK_SIZE / 10 >> 0;
//					this.graphics.drawRect(x, y, size, size, color);
					this.graphics.drawRect(x + clipLen, y - clipLen, size - clipLen, size - clipLen, color);
				}
			}
		}
	}
}
