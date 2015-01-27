<!---ORM CFC Generator By J Harvey jchharvey@webDevSourcerer.com
Creates a CFScript CFC for ORM Database Components
Version 1.0.2.2

Notes:
Updated to crawl over all Tables within a Specified DataSource

Still to Do: 
-- Add support for Foreign Key Constraints:
--->

<form method="post" style="text-align: center; margin-left: auto; margin-right: auto; width: 550px; height: 250px; border:2px solid #f5f5f5; border-radius:4px; background: #eeeeee;">
<h2 >ColdFusion ORM Component Generator</h2>
<p>Your Components will be created within the <em>/CFC/-datasourcename-</em> folder.</p>
Datasource:<input type="text" name="tempdsn" value=""><br>
<input type="submit">
<p style="margin-bottom: 15px;">Version 1.0.2.2</p>
</form>





<cfif isdefined('form.tempdsn')>
<div style="margin-left: auto; margin-right: auto; overflow: auto; width: 550px; height: 450px; border:2px solid #f5f5f5; border-radius:4px; background: #fff;">
    <h2 style="text-align: center;">Generating your components...</h2>
    <cfoutput>
    <cfdbinfo datasource="#form.tempdsn#" name="Database" type="tables">
    <!---cfdump var="#Database#"---> 
    <cfquery dbtype="query" name="table_names">
       Select TABLE_NAME from Database where TABLE_TYPE='table' and TABLE_SCHEM='dbo'
    </cfquery>
    
    <cfdirectory action="create" directory="cfc/#form.tempdsn#/">
    
    <cfloop query="table_names">
    Creating ORM Component for Table: <strong><em>#table_names.table_name#</em></strong><br>
    <cfquery name="temp" datasource="#form.tempdsn#" >
		SELECT * FROM information_schema.columns
		WHERE table_name = '#table_names.table_name#' and table_name !='trace_%'
		ORDER BY ordinal_position
	</cfquery>
     <!---cfdump var="#temp#"--->
     <cfsavecontent variable="DBSchema" >
component output="false" persistent="true" table="#temp.table_name#" accessors="true"
{<cfloop query="temp" >
	<cfset datatype = ''>
	<cfswitch expression="#temp.data_type#" >
		<cfcase value="int"><cfset datatype = 'cf_sql_integer'><cfset sqldt = 'numeric'></cfcase>
		<cfcase value="numeric"><cfset datatype = 'cf_sql_numeric'><cfset sqldt = 'numeric'></cfcase>
		<cfcase value="datetime"><cfset datatype = 'cf_sql_date'><cfset sqldt = 'datetime'></cfcase>
		<!---Boolean--->
		<cfcase value="bit"><cfset datatype = 'cf_sql_bit'><cfset sqldt = 'bit'></cfcase>
		<!---The String Types--->
		<cfcase value="char"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="nchar"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="varchar"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="nvarchar"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="text"><cfset datatype = 'cf_sql_longvarchar'><cfset sqldt = 'string'></cfcase>
	</cfswitch>
	property name="#column_name#" column="#column_name#" getter="true" <cfif currentrow eq 1>setter="false" 	
	fieldtype="id" 	generator="identity"<cfelse> setter="true" <cfif sqldt eq 
	'datetime'>ORMtype="date"<cfelse>type="#sqldt#"</cfif> sqltype="#datatype#"</cfif>;
	</cfloop>

	public function init(){
		return this;
	}
}
</cfsavecontent>

<cffile action="write" file="#expandpath('cfc/#form.tempdsn#/#temp.table_name#.cfc')#" output="#DBSchema#" >   
    </cfloop>
    
    
    </cfoutput>
</div>
    
</cfif>