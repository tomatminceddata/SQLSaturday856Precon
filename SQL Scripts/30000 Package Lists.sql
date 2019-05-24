declare @thePackages table (Package nvarchar(256), PackageVersion nvarchar(256));

insert into @thePackages (Package, PackageVersion)
EXEC sp_execute_external_script
@language = N'Python',
@script = N'
import pkg_resources;
dists = [d for d in pkg_resources.working_set];
import pandas as pd;
OutputDataSet = pd.DataFrame([(i.key, i.version) for i in dists]);
'

select * from @thePackages