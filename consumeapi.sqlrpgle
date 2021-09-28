**free
//This Program has an example of using the HTTP SQL Functions to consume the webservices.
//This is the endpoint we are going to use for calling webservices https://jsonplaceholder.typicode.com/posts
//Declaration------------------------------------------------------------------------------------------------------*
Dcl-s MessageText      varchar(32740);
Dcl-s MessageLength    int(5);
Dcl-s ResponseMsg      varchar(9999);
Dcl-s ResponseHeader   varchar(1000);
Dcl-s ResponsePos      packed(4);
Dcl-s Url              char(50);
Dcl-s ReturnedSQLCode  char(5);
Dcl-s header           char(250);
Dcl-c ENDPOINT         'https://jsonplaceholder.typicode.com/posts';
Dcl-c HTTPGET          '/1';
Dcl-c HTTPPOST         '';
Dcl-C HTTPPUT          '/1';
Dcl-c HTTPDELETE       '/1';
Dcl-c TODO             '{"title":"sabarish", "body":"sabarish_test", "userId":"9718"}';
Dcl-c UPDATE_TODO      '{"id":101, "title":"sabarish", "body":"sabarish_todo", "userId":"9718"}';
Dcl-c PATCH_TODO       '{"title":"sabarish", "body":"sabarish_test"}'; 
header ='<httpHeader><header name="Content-Type" value="application/json"></header></httpHeader>';
EXEC SQL SET OPTION COMMIT = *NONE; 
EXEC SQL CALL QSYS2.QCMDEXC('CHGJOB CCSID(37)');

// GET Method------------------------------------------------------------------------------------------------------*
Url = ENDPOINT + HTTPGET;
EXEC SQL SELECT COALESCE(Varchar(ResponseMsg,9999),' '),Varchar(ResponseHttpHeader,1000) into :ResponseMsg,
         :ResponseHeader From Table(Systools.HttpGetClobVerbose(Trim(:url),Trim(:header))) as InternalServices;
Exec SQL GET DIAGNOSTICS CONDITION 1 :ReturnedSqlCode = DB2_RETURNED_SQLCODE;          
EXEC SQL INSERT INTO SABARISH/API_RESPONSE (METHOD, SENT_HEADER, SENT_BODY,URL, RESPONSE, SQL_CODE) 
VALUES('GET', :header, ' ',:endpoint,:ResponseMsg,:ReturnedSqlCode);

//POST Method------------------------------------------------------------------------------------------------------*
Url = ENDPOINT + HTTPPOST;
EXEC SQL SELECT COALESCE(Varchar(ResponseMsg,9999),' '),Varchar(ResponseHttpHeader,1000) into :ResponseMsg,
         :ResponseHeader From Table(Systools.HttppostClobVerbose(Trim(:url),trim(:header),trim(:todo))) as 
         InternalServices;
Exec SQL GET DIAGNOSTICS CONDITION 1 :ReturnedSqlCode = DB2_RETURNED_SQLCODE;            
EXEC SQL INSERT INTO SABARISH/API_RESPONSE (METHOD, SENT_HEADER, SENT_BODY,URL, RESPONSE, SQL_CODE) 
VALUES('POST', :header, ' ',:endpoint,:ResponseMsg,:ReturnedSqlCode);

//PUT Method------------------------------------------------------------------------------------------------------*
Url = ENDPOINT + HTTPPUT;
EXEC SQL SELECT COALESCE(Varchar(ResponseMsg,9999),' '),Varchar(ResponseHttpHeader,1000) into :ResponseMsg,
         :ResponseHeader From Table(Systools.HttpputClobVerbose(Trim(:url),trim(:header),
         trim(:update_todo))) as InternalServices;
Exec SQL GET DIAGNOSTICS CONDITION 1 :ReturnedSqlCode = DB2_RETURNED_SQLCODE;            
EXEC SQL INSERT INTO SABARISH/API_RESPONSE (METHOD, SENT_HEADER, SENT_BODY,URL, RESPONSE, SQL_CODE) 
VALUES('PUT', :header, ' ',:endpoint,:ResponseMsg,:ReturnedSqlCode);
//DELETE Method------------------------------------------------------------------------------------------------------*
Url = ENDPOINT + HTTPDELETE;
EXEC SQL SELECT COALESCE(Varchar(ResponseMsg,9999),' '),Varchar(ResponseHttpHeader,1000) into :ResponseMsg,
         :ResponseHeader From Table(Systools.HttpdeleteClobVerbose(Trim(:url),trim(:header))) as InternalServices;
Exec SQL GET DIAGNOSTICS CONDITION 1 :ReturnedSqlCode = DB2_RETURNED_SQLCODE;            
EXEC SQL INSERT INTO SABARISH/API_RESPONSE (METHOD, SENT_HEADER, SENT_BODY,URL, RESPONSE, SQL_CODE) 
VALUES('DELETE', :header, ' ',:endpoint,:ResponseMsg,:ReturnedSqlCode);
*INLR = *ON;                                                                        