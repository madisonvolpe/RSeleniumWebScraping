## Clean the Inmate List 

```{R}
str(dfInmates)
#cleaning the column names

dfInmates<-dfInmates[-1] #removes unncessary column
colnames(dfInmates)[2] <- "DCNumber"
colnames(dfInmates)[5] <- "ReleaseDate"
colnames(dfInmates)[6] <- "CurrentFacility"
colnames(dfInmates)[7] <- "BirthDate"

dfInmates$Race <- factor(dfInmates$Race)
dfInmates$Sex  <- factor(dfInmates$Sex)
dfInmates$ReleaseDate <- as.POSIXct(dfInmates$ReleaseDate, tz="UTC", format = "%m/%d/%Y")
dfInmates$BirthDate <- as.POSIXct(dfInmates$BirthDate, tz = "UTC", format = "%m/%d/%Y")

```

## Attach URLs for each Inmate to dfInmates

```{R}
#store base URL
baseURL <- "http://www.dc.state.fl.us/offenderSearch/detail.aspx?Page=Detail"

#length of data set 
dflength <- length(dfInmates)

#create a URL column to store URLS 
URL_col <- data.frame(matrix(NA, nrow=dflength, ncol =1))

#construct URLS 
URL <- paste(baseURL, "&DCNumber=", dfInmates$DCNumber, "&TypeSearch=AI", sep="")

#append URLs to dfInmates
dfInmates <- cbind(dfInmates, URL)

#generate run time 
run_date <- Sys.Date()

#add run time column 
dfInmates$RunDate <- rep(run_time, nrow(dfInmates))
```
