## ----eval = FALSE-------------------------------------------------------------
install.packages("devtools")
library(devtools)
devtools::session_info()


## ----eval = FALSE-------------------------------------------------------------
install.packages('DSI')
install.packages('DSOpal')
install.packages('dsBaseClient', repos=c(getOption('repos'), 'http://cran.datashield.org'), dependencies=TRUE)
install.packages("metafor")
devtools::install_github("timcadman/ds-helper")


## ----message = FALSE----------------------------------------------------------
library(DSI)
library(DSOpal)
library(dsBaseClient)
library(dsHelper)
library(metafor)


## ----eval = FALSE-------------------------------------------------------------
devtools::session_info()


## -----------------------------------------------------------------------------
builder <- DSI::newDSLoginBuilder()
builder$append(
  server = "cordelia",
  url = "https://opal-demo.obiba.org",
  user = "dsuser",
  password = "P@ssw0rd",
  resource = "CORDELIA.cordelia44",
)
logindata <- builder$build()


## -----------------------------------------------------------------------------
conns <- DSI::datashield.login(logins = logindata, 
                                     assign = TRUE, 
                                     symbol = "res")


## -----------------------------------------------------------------------------
ds.ls()


## -----------------------------------------------------------------------------
ds.class("res")


## -----------------------------------------------------------------------------
DSI::datashield.assign.expr(conns = conns, 
                            symbol = "D",
                            expr = quote(as.resource.data.frame(res)))



## -----------------------------------------------------------------------------
ds.ls()


## -----------------------------------------------------------------------------
ds.summary("D")


## -----------------------------------------------------------------------------
ds.dim(x="D", datasources = conns)

ds.colnames(x="D", datasources = conns)


## -----------------------------------------------------------------------------
ls()


## -----------------------------------------------------------------------------
ds.dim("D")

ds.colnames("D")


## -----------------------------------------------------------------------------

ds.class(x='D$hdl', datasources = conns)
ds.length(x='D$hdl', datasources = conns)
ds.mean(x='D$hdl', datasources = conns)



## -----------------------------------------------------------------------------
?ds.quantileMean


## -----------------------------------------------------------------------------
ds.quantileMean(x='D$hdl', datasources = conns)

ds.quantileMean(x='D$hdl',type = "split", datasources = conns)



## -----------------------------------------------------------------------------
?ds.var


## -----------------------------------------------------------------------------
ds.var(x = "D$hdl", type = "split", datasources = conns)


## -----------------------------------------------------------------------------
a<-ds.var(x = "D$hdl", type = "split", datasources = conns)[[1]]
a
b<-ds.var(x = "D$hdl", type = "split", datasources = conns)[[1]][[1,1]]
b


## -----------------------------------------------------------------------------
ds.table("D$sexo")


## ----eval = FALSE-------------------------------------------------------------
# neat_stats <- dh.getStats(
# 	df = "D",
#   vars = c("edad", "HTA", "hdl", "ldl", "trig", "creat",
#            "IMC", "talla", "cintura", "peso", "col_tto",
#            "diabetes", "diab_tto", "insuline", "FC"))
# 
# neat_stats


## ----eval = FALSE-------------------------------------------------------------
# datashield.errors()


## -----------------------------------------------------------------------------
ds.ls(datasources = conns)
ds.log(x='D$hdl', newobj='hdl_log', datasources = conns)
ds.ls(datasources = conns)
ds.mean(x="hdl_log",datasources= conns)
ds.mean(x="D$hdl",datasources= conns)


## -----------------------------------------------------------------------------
ds.sqrt(x='D$hdl', newobj='hdl_sqrt', datasources = conns)
ds.ls(datasources = conns)
ds.mean(x="hdl_sqrt",datasources= conns)
ds.mean(x="D$hdl",datasources= conns)


## -----------------------------------------------------------------------------
ds.dataFrame(c("D", "hdl_sqrt", "hdl_log"), newobj = "D")
ds.colnames("D")


## -----------------------------------------------------------------------------
# first find the column name you wish to refer to
ds.colnames(x="D")
# then check which levels you need to apply a boolean operator to:
ds.levels(x="D$sexo")
?ds.dataFrameSubset


## ----eval = FALSE-------------------------------------------------------------
# ds.dataFrameSubset(df.name = "D",
#                    V1.name = "D$sexo",
#                    V2.name = "Hombre",
#                    Boolean.operator = "==",
#                    newobj = "cordelia.subset.Hombres", datasources= conns)
# 
# ds.dataFrameSubset(df.name = "D",
#                    V1.name = "D$sexo",
#                    V2.name = 'Mujer',
#                    Boolean.operator = "==",
#                    newobj = "cordelia.subset.Mujeres",datasources= conns)


## -----------------------------------------------------------------------------
ds.completeCases(x1="D", newobj="D_without_NA", datasources=conns)


## -----------------------------------------------------------------------------
ds.dataFrameSubset(df.name = "D",
  V1.name = "D$IMC",
  V2.name = "25",
  Boolean.operator = ">=",
  newobj = "subset.IMC.25.plus",
  datasources = conns)


## -----------------------------------------------------------------------------
ds.quantileMean(x="subset.IMC.25.plus$IMC", 
                datasources= conns)

ds.histogram(x="subset.IMC.25.plus$IMC", datasources = conns)


## -----------------------------------------------------------------------------
ds.Boole(
  V1 = "D$IMC",
  V2 = "25",
  Boolean.operator = ">=",
  numeric.output = TRUE,
  newobj = "IMC.25.plus",
  datasources = conns)

ds.Boole(
  V1 = "D$glu",
  V2 = "90",
  Boolean.operator = "<",
  numeric.output = TRUE,
  newobj = "glu.90.less",
  datasources = conns)



## -----------------------------------------------------------------------------
?ds.make 

ds.make(toAssign = "IMC.25.plus+glu.90.less",
        newobj = "IMC.25.plus_glu.90.less",
        datasources = conns)

# If BMI >= 25 and glucose < 6, then BMI.25.plus_GLUC.6.less=2
# If BMI >= 25 and glucose >= 6, then BMI.25.plus_GLUC.6.less=1
# If BMI < 25 and glucose < 6, then BMI.25.plus_GLUC.6.less=1
# If BMI < 25 and glucose >= 6, then BMI.25.plus_GLUC.6.less=0

ds.table(rvar= "IMC.25.plus_glu.90.less",
         datasources = conns)

ds.dataFrame(x=c("D", "IMC.25.plus_glu.90.less"), newobj = "D2")

ds.colnames("D2")

ds.dataFrameSubset(df.name = "D2",
  V1.name = "D2$IMC.25.plus_glu.90.less",
  V2.name = "2",
  Boolean.operator = "==",
  newobj = "subset2",
  datasources = conns)

ds.dim("subset2")



## -----------------------------------------------------------------------------
dh.dropCols(
	df = "D", 
  vars = c("IMC", "sexo"), 
  type = "keep",
  new_obj = "df_subset")
  
ds.colnames("df_subset")


## -----------------------------------------------------------------------------
dh.renameVars(
	df = "D", 
  current_names = c("IMC", "sexo"),
  new_names = c("bmi", "sex"))
  
ds.colnames("D")


## -----------------------------------------------------------------------------
?ds.histogram
ds.histogram(x='D$hdl', datasources = conns)


## -----------------------------------------------------------------------------
ds.scatterPlot(x="D$hdl", y="D$bmi", datasources = conns)


## -----------------------------------------------------------------------------
?ds.heatmapPlot
?ds.contourPlot
?ds.boxPlot


## -----------------------------------------------------------------------------
ds.cor(x='D$bmi', y='D$hdl')


## -----------------------------------------------------------------------------
mod <- ds.glm(formula = "D$hdl~D$bmi", 
              family="gaussian", datasources = conns)
mod


## -----------------------------------------------------------------------------
dh.lmTab(
  model = mod, 
  type = "glm_ipd", 
  direction = "wide", 
  ci_format  = "separate")


## -----------------------------------------------------------------------------
glm_mod1<-ds.glm(formula="D$diabetes ~ D$bmi + D$hdl*D$sex", 
                 family='binomial', datasources = conns)


## -----------------------------------------------------------------------------
DSI::datashield.workspace_save(conns = conns, ws = "workspace2025")


## -----------------------------------------------------------------------------
DSI::datashield.logout(conns)


## -----------------------------------------------------------------------------
conns <- datashield.login(logins = logindata, 
                          assign = TRUE, symbol = "D")
ds.ls()
datashield.logout(conns)

conns <- datashield.login(logins = logindata, restore = "workspace2025")
ds.ls()

