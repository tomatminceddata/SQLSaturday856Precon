exec sp_execute_external_script 
@language =N'Python',
@script=N'import os
OutputDataSet["env_variable_name"] = pandas.Series([i[0] for i in os.environ.items()])
OutputDataSet["env_variable_value"] = pandas.Series([i[1] for i in os.environ.items()])'
WITH RESULT SETS ((env_variable_name nvarchar(max), env_variable_value nvarchar(max)))