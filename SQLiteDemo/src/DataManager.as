package  
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author umhr
	 */
	public class DataManager 
	{
		private static var _instance:DataManager;
		public function DataManager(block:Block){init();};
		public static function getInstance():DataManager{
			if ( _instance == null ) {_instance = new DataManager(new Block());};
			return _instance;
		}
		
		private var _sqlStatement:SQLStatement;
		private var _sqlConnection:SQLConnection;
		private function init():void
		{
			setSQLite();
		}
		
		private function setSQLite():void 
		{
			var file:File = File.documentsDirectory.resolvePath("SQLiteDemo.db");
			_sqlConnection = new SQLConnection();
			_sqlConnection.addEventListener(SQLEvent.OPEN, connectionOpenHandler);
			_sqlConnection.addEventListener(SQLErrorEvent.ERROR, connectionErrorHandler);
			_sqlConnection.open(file);
		}
		
		private function connectionErrorHandler(event:SQLErrorEvent):void 
		{
			View.getInstance().setLog(event.type);
		}
		
		private function connectionOpenHandler(event:SQLEvent):void 
		{
			var sqlString:String = "CREATE TABLE IF NOT EXISTS demo ("
			+ " no INTEGER PRIMARY KEY, id TEXT, name TEXT, date TEXT, img BLOB)";
			
			setSQL(sqlString);
		}
		
		private function setSQL(sqlString:String):void {
			_sqlStatement = new SQLStatement();
			_sqlStatement.sqlConnection = _sqlConnection;
			_sqlStatement.text = sqlString;
			_sqlStatement.addEventListener(SQLEvent.RESULT, onResult);
			_sqlStatement.addEventListener(SQLErrorEvent.ERROR, stmtErrorHandler);
			_sqlStatement.execute();
			
			View.getInstance().setLog(sqlString);
		}
		
		private function onResult(event:SQLEvent):void 
		{
			getData();
		}
		
		private function stmtErrorHandler(event:SQLErrorEvent):void 
		{
			trace(event.type);
		}
		
		public function sqlInsert(id:String, name:String, type:String, byteArray:ByteArray):void {
			
			var sqlString:String = "INSERT INTO demo (no, id, name, date,img)" +
				"VALUES (Null,'" + id +"','" + name +"','" + type +"',:img)";
				
			_sqlStatement = new SQLStatement();
			_sqlStatement.sqlConnection = _sqlConnection;
			_sqlStatement.text = sqlString;
			_sqlStatement.parameters[":img"] = byteArray;
			_sqlStatement.addEventListener(SQLEvent.RESULT, onResult);
			_sqlStatement.addEventListener(SQLErrorEvent.ERROR, stmtErrorHandler);
			_sqlStatement.execute();
		}
		
		public function sqlUpdate(no:String, dataField:String, value:String):void {
			var sqlString:String = "UPDATE demo SET " + dataField +" = :"+ dataField + 
						" WHERE no = :no";
						
			View.getInstance().setLog(sqlString);
			_sqlStatement = new SQLStatement();
			_sqlStatement.sqlConnection = _sqlConnection;
			_sqlStatement.text = sqlString;
			_sqlStatement.parameters[":no"] = no;
			_sqlStatement.parameters[":" + dataField] = value;
			_sqlStatement.addEventListener(SQLEvent.RESULT, getDataResult);
			_sqlStatement.addEventListener(SQLErrorEvent.ERROR, stmtErrorHandler);
			_sqlStatement.execute();
		}
		
		public function sqlDelete(no:int):void {
			var sqlString:String = "DELETE FROM demo WHERE no=" + no;
			setSQL(sqlString);
		}
		
		private function getData():void {
			var sqlString:String = "SELECT no, id, name, date, img FROM demo";
			View.getInstance().setLog(sqlString);
			
			_sqlStatement = new SQLStatement();
			_sqlStatement.sqlConnection = _sqlConnection;
			_sqlStatement.text = sqlString;
			_sqlStatement.addEventListener(SQLEvent.RESULT, getDataResult);
			_sqlStatement.addEventListener(SQLErrorEvent.ERROR, stmtErrorHandler);
			_sqlStatement.execute();
		}		
		
		private function getDataResult(event:SQLEvent):void 
		{
			var result:SQLResult = _sqlStatement.getResult();
			if (result.rowsAffected == 0) {
				View.getInstance().setDataGrid(result.data);
			}
		}
	}
}
class Block { };