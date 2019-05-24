
/* https://docs.microsoft.com/en-us/sql/advanced-analytics/tutorials/demo-data-iris-in-sql?view=sql-server-2017 */

/* ********************************* creating a sample table
CREATE DATABASE irissql
GO
USE irissql
GO
***********************************/


/* ********************************* creating the data table
DROP TABLE IF EXISTS iris_data;
GO
CREATE TABLE iris_data (
  id INT NOT NULL IDENTITY PRIMARY KEY
  , "Sepal.Length" FLOAT NOT NULL, "Sepal.Width" FLOAT NOT NULL
  , "Petal.Length" FLOAT NOT NULL, "Petal.Width" FLOAT NOT NULL
  , "Species" VARCHAR(100) NOT NULL, "SpeciesId" INT NOT NULL
);
***********************************/



/* ********************************* populating  the data table
--CREATE PROCEDURE get_iris_dataset
--AS
--BEGIN
INSERT INTO [dbo].[iris_data]
           ([Sepal.Length]
           ,[Sepal.Width]
           ,[Petal.Length]
           ,[Petal.Width]
           ,[Species]
           ,[SpeciesId])
EXEC sp_execute_external_script @language = N'Python', 
@script = N'
from sklearn import datasets
iris = datasets.load_iris()
iris_data = pandas.DataFrame(iris.data)
iris_data["Species"] = pandas.Categorical.from_codes(iris.target, iris.target_names)
iris_data["SpeciesId"] = iris.target
', 
@input_data_1 = N'', 
@output_data_1_name = N'iris_data'
--WITH RESULT SETS (("Sepal.Length" float not null, "Sepal.Width" float not null, "Petal.Length" float not null, "Petal.Width" float not null, "Species" varchar(100) not null, "SpeciesId" int not null));
--END;
--GO
***********************************/

/* ********************************* populating  the data table
CREATE PROCEDURE generate_iris_model (@trained_model varbinary(max) OUTPUT)
AS
BEGIN
EXEC sp_execute_external_script @language = N'Python',
@script = N'
import pickle
from sklearn.naive_bayes import GaussianNB
GNB = GaussianNB()
trained_model = pickle.dumps(GNB.fit(iris_data[[0,1,2,3]], iris_data[[4]].values.ravel()))
'
, @input_data_1 = N'select "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "SpeciesId" from iris_data'
, @input_data_1_name = N'iris_data'
, @params = N'@trained_model varbinary(max) OUTPUT'
, @trained_model = @trained_model OUTPUT;
END;
***********************************/

/************************************
CREATE TABLE iris_models (  
  model_name VARCHAR(50) NOT NULL DEFAULT('default model') PRIMARY KEY,  
  model VARBINARY(MAX) NOT NULL  
);
***********************************/

/* *********************************
DECLARE @model varbinary(max);
DECLARE @new_model_name varchar(50)
SET @new_model_name = 'Naive Bayes'
EXEC generate_iris_model @model OUTPUT;
DELETE iris_models WHERE model_name = @new_model_name;
INSERT INTO iris_models (model_name, model) values(@new_model_name, @model);

************************************/

/* *********************************
CREATE PROCEDURE predict_species (@model varchar(100))
AS
BEGIN
DECLARE @nb_model varbinary(max) = (SELECT model FROM iris_models WHERE model_name = @model);
EXEC sp_execute_external_script @language = N'Python', 
@script = N'
import pickle
irismodel = pickle.loads(nb_model)
species_pred = irismodel.predict(iris_data[[1,2,3,4]])
iris_data["PredictedSpecies"] = species_pred
OutputDataSet = iris_data[[0,5,6]] 
print(OutputDataSet)
'
, @input_data_1 = N'select id, "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "SpeciesId" from iris_data'
, @input_data_1_name = N'iris_data'
, @params = N'@nb_model varbinary(max)'
, @nb_model = @nb_model
WITH RESULT SETS ( ("id" int, "SpeciesId" int, "SpeciesId.Predicted" int));
END;
GO
*****************************************/

EXEC predict_species 'Naive Bayes';