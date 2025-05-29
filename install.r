install.packages('DSI')
install.packages('DSOpal')

install.packages('dsBaseClient', repos=c(getOption('repos'), 'http://cran.datashield.org'), dependencies=TRUE)

install.packages("metafor")
devtools::install_github("timcadman/ds-helper")