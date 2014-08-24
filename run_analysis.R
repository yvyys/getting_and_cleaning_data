# This function uses the data from a experiment about persons,
# wearing a smartphone (Samsung Galaxy S II)and doing different activities.
# The function:
# - Merges the training and the test sets to create one data set
# - Extracts only the measurements on the mean and standard deviation for each measurement
# - Creates a second, independent tidy data set with the average of each variable
#   for each activity and each subject

run_analysis = function (){
  
# for using the function 'join_all'; first requirement
require(plyr)
# for using the functions melt and dcast; last requirement
require(reshape2)

# vector with the two directories and central directory 
setlist=c("train","test")
path="UCI HAR Dataset/"

# paths for 'features' and 'activity_labels'
filefeature=paste(path,"features.txt",sep="")
fileactivitylabels=paste(path,"activity_labels.txt",sep="")

# using the 'for' commando to read automatically
# both datas from the directories train and test
for (set in setlist){

# path from the differents files
  setpath=paste(path,set,sep="")
  fileend=paste(set, ".txt", sep="")
  filesubject=paste(setpath,"/subject_",fileend,sep="")
  fileactivity=paste(setpath,"/y_",fileend,sep="")
  filemeasure=paste(setpath,"/X_",fileend,sep="")

# commando to read the differents files
  subject = read.table(filesubject,sep="")
  activity = read.table(fileactivity,sep="")
  measure = read.table(filemeasure,sep="")

# 'setclass' for giving if the datas are from the 'train' or the 'test' 
  setclass = rep(set, nrow(subject))

# all the tables have the same number of row
# calcul from the number of row from one table
# and put in others tables.
# After that it is possible to join the tables
# with the funcion join_all from the package plyr
  id = 1:nrow(subject)
  subject = cbind(id, setclass, subject)
  activity = cbind(id, activity)
  measure = cbind(id, measure)

# the test and train datas are saved in differents temporaries tables
# and put together  in one temporary table after the 'for' commando
  tablelist = list(subject, activity, measure)
  if(set=="train"){
    temptable_train= join_all(tablelist, by="id")
  }
  else{
    temptable_test= join_all(tablelist, by="id") 
  }
}
temptable = rbind(temptable_train, temptable_test)
temptable= subset(temptable, select=-id)

# take the names from columns in features.txt
# and add the names from the existented temporary table
namescol_1=read.table(filefeature,sep="")
namescol_2=as.character(namescol_1[,2])
namescol_3=c(c("setclass","subject","activityNr"), namescol_2)

# set the columns names from the temporary table
names(temptable)= namescol_3

# create news temporaries tables to merge the activities
temptable_2= temptable

labelsactivity=read.table(fileactivitylabels,sep="")
names(labelsactivity)=c("activityNr","activity")

temptable_3=merge(labelsactivity, temptable_2, by="activityNr", all=TRUE)

# change the order from the columns
namescol_4=c(c("setclass","subject","activity"), namescol_2)

temptable_4= temptable_3[,namescol_4]

# Answer of the 1.st requirement
tableanswer_1=temptable_4

# calcul numric vector from column name with 'mean()' or 'std()'
# from the source file feature.
# '3+' if for the first columns: 'setclass','subject', 'activity'
newlindexcol_1=3+ grep("*mean()*|*std()*",namescol_1[,2])
newlindexcol_1=c(1:3,newlindexcol_1)

# new table with only 'mean()' or 'std()' columns
temptable_5=tableanswer_1[,newlindexcol_1]
temptable_5_names=names(temptable_5)

# remove columns with the function meanFreq()
newlindexcol_2=grep("meanFreq()*",temptable_5_names)

# Answer of the 2.nd requirement
tableanswer_2=temptable_5[,-newlindexcol_2]

# the information about 'train' and 'test' isn't needed 
temptable_6=subset(tableanswer_2,select=-setclass)

# using the functions melt and dcast
# to set the average of each variable
# for each activity and each subject
melt_temptable_6=melt(temptable_6, id=c("subject", "activity"), measure.vars=3:68, variable.name="features")

tableanswer_5= dcast(melt_temptable_6, subject + activity ~ features,mean)

write.table(tableanswer_5, file="tidy_data_from_the_course_project.txt", sep=",", row.names=FALSE)
}