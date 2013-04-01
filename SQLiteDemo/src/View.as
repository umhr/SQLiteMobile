package  
{
	
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.events.DataGridEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author umhr
	 */
	public class View extends Sprite 
	{
		private static var _instance:View;
		public function View(block:Block){init();};
		public static function getInstance():View{
			if ( _instance == null ) {_instance = new View(new Block());};
			return _instance;
		}
		
		private var _log:TextArea;
		private var _insertButton:PushButton;
		private var _deleteButton:PushButton;
		private var _dataGrid:DataGrid;
		private var _id:InputText;
		private var _name:InputText;
		private var _date:InputText;
		private function init():void
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			_id = new InputText(this, 35, 8);
			_id.width = 50;
			_name = new InputText(this, _id.x + _id.width+4, 8, "name");
			_name.width = 80;
			_date = new InputText(this, _name.x + _name.width+4, 8);
			_date.width = 200;
			_insertButton = new PushButton(this, _date.x + _date.width+4, 8, "Insert", onInsert);
			_insertButton.width = 80;
			_insertButton.height = 16;
			setInputText();
			
			_dataGrid = new DataGrid();
			_dataGrid.addColumn("no").setWidth(30);
			_dataGrid.addColumn("id").setWidth(50);
			_dataGrid.addColumn("name").setWidth(80);
			_dataGrid.addColumn("date").setWidth(200);
			
			var dataGridColumn:DataGridColumn = new DataGridColumn("img");
			dataGridColumn.cellRenderer = LoaderCellRenderer;
			_dataGrid.addColumn(dataGridColumn).setWidth(80);
			_dataGrid.width = 465-8;
			_dataGrid.height = 290;
			_dataGrid.x = 4;
			_dataGrid.y = 34;
			_dataGrid.editable = true;
			_dataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT, dataGrid_itemFocusOut);
			_dataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, dataGrid_itemEditEnd);
			addChild(_dataGrid);
			
			_deleteButton = new PushButton(this, 360, 330, "Delete", onDelete);
			_deleteButton.height = 16;
			
			_log = new TextArea(this, 4, 360, "");
			_log.width = 465 - 8;
		}
		
		private var _focusDataField:String;
		
		private function dataGrid_itemEditEnd(event:DataGridEvent):void 
		{
			_focusDataField = event.dataField;
		}
		
		private function dataGrid_itemFocusOut(event:DataGridEvent):void 
		{
			var rowIndex:int = int(event.rowIndex);
			var data:Object = _dataGrid.getItemAt(rowIndex);
			var no:String = data["no"];
			var value:String = data[_focusDataField];
			
			DataManager.getInstance().sqlUpdate(no, _focusDataField, value);
		}
		
		private function onDelete(event:Event):void 
		{
			var data:Object = _dataGrid.selectedItem;
			if (data == null) {
				return;
			}
			var no:int = int(data["no"]);
			DataManager.getInstance().sqlDelete(no);
		}
		
		public function setDataGrid(data:Object):void {
			_dataGrid.removeAll();
			
			var obj:Object;
			var index:int = 0;
			
			for (var p:String in data) { 
				obj = { };
				for (var q:String in data[p]) { 
					if (q == "img") {
						var byteArray:ByteArray = data[p][q];
						byteArray.uncompress();
						var bitmapData:BitmapData = new BitmapData(80, 20, false, 0xFFFFFFFF);
						bitmapData.setPixels(new Rectangle(0, 0, 80, 20), byteArray);
						var bitmap:Bitmap = new Bitmap(bitmapData);
						
						obj[q] = bitmap;
					}else {
						obj[q] = data[p][q];
					}
					
				}
				_dataGrid.addItem( obj );
				index ++;
			}
		}
		
		private function onInsert(event:Event):void 
		{
			var id:String = _id.text;
			var name:String = _name.text;
			var type:String = _date.text;
			
			var byteArray:ByteArray = new ByteArray();
			var bitmapData:BitmapData = new BitmapData(80, 20, false, 0xFFFFFFFF);
			var rand:int = Math.floor(Math.random() * 0xFFFF);
			bitmapData.perlinNoise(80 ,20 , 1 , rand , false , true , (8|4|2|1));
			byteArray.writeBytes(bitmapData.getPixels(bitmapData.rect));
			byteArray.compress();
			
			DataManager.getInstance().sqlInsert(id, name, type, byteArray);
			
			setInputText();
		}
		
		private function setInputText():void 
		{
			_id.text = "";
			_id.text += String.fromCharCode((Math.floor(Math.random() * 24) + 65));
			_id.text += String.fromCharCode((Math.floor(Math.random() * 24) + 65));
			_id.text += String.fromCharCode((Math.floor(Math.random() * 24) + 65));
			
			_date.text = new Date().toString();
		}
		
		public function setLog(text:String):void {
			if (_log == null) { return };
			
			_log.text += text + "\n";
			
		}
	}
}
class Block { };