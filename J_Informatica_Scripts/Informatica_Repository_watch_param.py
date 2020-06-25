import cx_Oracle
import sys
objects_changed=0
LOCATION = "/usr/lib/oracle/19.3/client64/lib"
connection_string = sys.argv[1]+'/'+sys.argv[2] +'''@(DESCRIPTION= (ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=''' +sys.argv[3]+''')(PORT='''+sys.argv[4]+''')) ) (CONNECT_DATA=(SID='''+sys.argv[5]+''') ))'''
connection = cx_Oracle.connect(connection_string)
cursor = connection.cursor()
result=cursor.execute("SELECT count(*) FROM   REP_USERS, REP_VERSION_PROPS, REP_SUBJECT ,opb_object_type WHERE  REP_USERS.USER_ID = REP_VERSION_PROPS.USER_ID AND REP_SUBJECT.SUBJECT_ID = REP_VERSION_PROPS.SUBJECT_ID and SUBJECT_AREA='SOURCE_F' and to_date(last_saved,'mm/dd/yyyy hh24:mi:ss')  >  (SYSDATE) - interval '1' minute and opb_object_type.object_type_id=REP_VERSION_PROPS.OBJECT_TYPE")
for row in result:
    objects_changed=row[0]
cursor.close()
connection.close()
assert(objects_changed)
