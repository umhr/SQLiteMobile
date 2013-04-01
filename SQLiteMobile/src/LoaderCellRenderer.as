package {
    // Import the required component classes.
	import fl.containers.UILoader;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.InvalidationType;
	import flash.display.DisplayObject;

    /**
	 * 
	 * http://www.adobe.com/devnet/flash/quickstart/datagrid_pt3.html
	 * 40-47はumhrによる追記
	 * 
     * This class creates a custom cell renderer which displays an image in a cell.
     * Make sure the class is marked "public" and in the case of our custom cell renderer, 
     * extends the UILoader class and implements the ICellRenderer interface.
     */
    public class LoaderCellRenderer extends UILoader implements ICellRenderer {
        protected var _data:Object;
        protected var _listData:ListData;
        protected var _selected:Boolean;

        /**
         * Constructor.
         */
        public function LoaderCellRenderer():void {
            super();
        }

        /**
         * Gets or sets the cell's internal _data property.
         */
        public function get data():Object {
            return _data;
        }
        /** 
         * @private (setter)
         */
        public function set data(value:Object):void {
			
			// DisplayObjectの場合は、配置
			for (var p:String in value) {
				if (value[p] is DisplayObject) {
					addChild(value[p]);
				}
			}
			
            _data = value;
            source = value.data;
        }

        /**
         * Gets or sets the cell's internal _listData property.
         */
        public function get listData():ListData {
            return _listData;
        }
        /**
         * @private (setter)
         */
        public function set listData(value:ListData):void {
            _listData = value;
            invalidate(InvalidationType.DATA);
            invalidate(InvalidationType.STATE);
        }

        /**
         * Gets or sets the cell's internal _selected property.
         */
        public function get selected():Boolean {
            return _selected;
        }
        /**
         * @private (setter)
         */
        public function set selected(value:Boolean):void {
            _selected = value;
            invalidate(InvalidationType.STATE);
        }

        /**
         * Sets the internal mouse state.
         */
        public function setMouseState(state:String):void {
        }
    }
}