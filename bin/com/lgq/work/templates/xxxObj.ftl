package ${packageName};

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "${tableName}")
public class ${objName}{

<#if modelColumn?exists>
	<#list modelColumn as model>
    	<#if (model.columnType = 'varchar' || model.columnType = 'text')>
    private String ${model.columnName};
    
    	</#if>
    	<#if (model.columnType = 'int')>
    private int ${model.columnName};
    
    	</#if>
	</#list>
</#if>
<#if modelColumn?exists>
	<#list modelColumn as model>
		<#if (model.columnType = 'varchar' || model.columnType = 'text')>
			<#if (model.columnName = 'id')>
	@Id
			</#if>
    public String get${model.columnName}() {
        return ${model.columnName};
    }

    public void set${model.columnName}(String ${model.columnName}) {
        this.${model.columnName} = ${model.columnName};
    }
    
		</#if>
		<#if (model.columnType = 'int')>
			<#if (model.columnName = 'id')>
	@Id
			</#if>
    public int get${model.columnName}() {
        return ${model.columnName};
    }

    public void set${model.columnName}(int ${model.columnName}) {
        this.${model.columnName} = ${model.columnName};
    }
    
		</#if>
	</#list>
</#if>
}
