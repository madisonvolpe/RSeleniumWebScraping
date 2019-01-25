## Download HTMLs using Loop

```{r}
start.time <- Sys.time()

mylist.names <- dfInmates$DCNumber
HTMLs <- as.list(rep(NA, length(mylist.names)))
names(HTMLs) <- mylist.names

for(i in 1:length(URLs)){
  HTMLs[[i]] <- getURL(URLs[[i]])
}

end.time <- Sys.time()

end.time - start.time

save(HTMLs, file = "HTMLs2.rda")
```
