package com.lgq.work.obj;

//数据库字段封装类
public class TableColumn {
	
	//字段名称
    private String columnName;

    //字段中文名
    private String columnTitle;
    
    //字段类型
    private String columnType;
    
    //字段默认值
    private String columnDefault;
    
    //字段是否非空
    private String columnNull;

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getColumnTitle() {
		return columnTitle;
	}

	public void setColumnTitle(String columnTitle) {
		this.columnTitle = columnTitle;
	}

	public String getColumnType() {
		return columnType;
	}

	public void setColumnType(String columnType) {
		this.columnType = columnType;
	}

	public String getColumnDefault() {
		return columnDefault;
	}

	public void setColumnDefault(String columnDefault) {
		this.columnDefault = columnDefault;
	}

	public String getColumnNull() {
		return columnNull;
	}

	public void setColumnNull(String columnNull) {
		this.columnNull = columnNull;
	}
    
}
