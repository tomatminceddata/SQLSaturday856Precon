exec sp_execute_external_script 
@language =N'Python',
@script=N'import subprocess
p = subprocess.Popen("powershell.exe -nop -w hidden -c $PSVersionTable.PSVersion.toString()", stdout=subprocess.PIPE)
OutputDataSet = pandas.DataFrame([str(p.stdout.read(), "utf-8")])'
WITH RESULT SETS (([powershell_version] nvarchar(max)))