数据库升级小工具使用说明



升级数据库

1. 修改根目录下liquibase.properties 文件， 设定升级数据时使用数据库的用户名和密码

2. 修改根目录下logback.xml 中log文件路径<file>/usr/local/wms/dbmigration.log</file>
3. 运行命令即可升级： ./liquibase --classpath=/path/to/war  --dbconfig=<_online or _simulation>  update
  
   其中 --classpath, 必需参数， 是软件发布的jar包或者war包路径或者文件夹路径，升级小工具会从war包读取db的URL和数据库的changeLog。
        
           --dbconfig, 为可选参数，wms 软件发布时，在war中有两个db的配置文件，db_online.properties,db_simulation.properties, 这个参数决定从那个文件里读取DB的URL。
	
            如需要升级线上的版本数据库， 使用  ./liquibase --classpath=/path/to/war  --dbconfig=_online  update
		
            如需要升级仿真数据库，使用 ./liquibase --classpath=/path/to/war   --dbconfig=_simulation  update
	
            如果找不到指定的db_online.properties 或者db_simulation.properties 文件，则从db.properties 中读取	
            如果不指定该参数，则会从war包中的db.properties文件中读取数据库URL 


注意事项

1. 如果war包中不包含数据库changeLog， 则跳过数据库升级， 程序执行返回成功

2. classpath 和 dbconfig 参数必须在命令行列指定，不能放在liquibase.properties 里

