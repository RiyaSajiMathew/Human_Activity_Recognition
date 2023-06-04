




# HUMAN ACTIVITY RECOGNITION (DATA COLLECTION, PREPARATION & ANALYSIS)



#*******************************************************************************

# Data Preparation and Analysis

#*******************************************************************************



# To clear all global variables.

#rm() removes all of the objects that are stored in our global environment

rm(list = ls())    



#*********************** Setting working directory *****************************



# First set the working directory to the location of our script

dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir)         #setting the working directory


# To get our file path

File_Path <- file.path(dir, "Activity")
File_Path               #To view in console


#Appending our Activity folder to the path and
# get the file names under Activity folder of our captured data

file_names <- list.files(file.path(dir, "Activity"))
file_names              #To view in console


# To get the number of files in our Activity folder

no.files <- length(file_names) 
no.files              #To view in console



#****************************** Question 1 *************************************


# Load each of the files you captured in Part 1 as a data frame, 
# use computational methods to achieve this.
# Use names that are meaningful and consistent (e.g., subj1_act1). 
# You should have created 12 data frames at the end of 
# this task.



# Create an empty list of files.

activity_list <- list()


#Importing files to individual data frames

for(i in 1:length(file_names)){
  
  assign(paste( sub(".csv","",file_names[i])),# sub() to replace .csv with file name 
         
         # Read each file into dataframes and store them into activity_list
         
         activity_list[[i]] <- as.data.frame(  
           
           read.csv(paste(File_Path,"/",file_names[i],sep=""),  #Reading file names
                    
                    strip.white = TRUE,  #To strip white spaces in dataframe.
                    
                    header = FALSE ,     # R creates column names V1,V2,..
                    
                    stringsAsFactors=FALSE,
                    
                    na.strings = c(""," ","NA"))))}


# To check the number of dataframes created

length(activity_list)   # Thus, we have created 12 data frames 




#***********************************************************************


# Using computational methods, find the data markers which determine the actual 
# data (human activity) needed for this assignment. Obtain the indexes for the  
# start and end markers. 


# Create an empty list 

df_list = list()  #To store the newly created dataframes



for(i in 1:length(activity_list)){
  
  # To get the markers for dataframes in activity_list
  
  data_marker <- activity_list[[i]][activity_list[[i]]$V1 =="Sample",] #we have 3 markers per dataframe
  
  print(data_marker)                                                   #To view in console
  
  
  # To get marker indexes
  
  data_marker_index <- row.names(data_marker)  #Gives the row indices of each marker
  
  print(data_marker_index)                     #To view in console
  
  
  # To get the starting index of data marker
  
  data_marker_start_index <- data_marker_index[2]   #Gives the index of the 2nd marker
  
  print(data_marker_start_index)                    #To view in console
  
  
  # To get the ending index of data marker
  
  data_marker_end_index <- as.numeric(data_marker_index[3])-1   #Gives the index where the marker ends
  
  print(data_marker_end_index)                                  #To view in console
  
  
  
  #*****************************************************************************
  
  # Obtain the desire data. 
  
  # Using computational methods, use the markers obtained in point 2,get 
  # the data between these markers only. Save the new data in separate
  # data frames.
  
  
  df_list[[i]] <- activity_list[[i]][data_marker_start_index:data_marker_end_index, ]
  
  #Extracting the data in between data_marker_start_index & data_marker_end_index
  #from each dataframe in activity_list
  
  #Storing them in empty list, df_list
  
  #*****************************************************************************
  
  
  # Name Variables. 
  # Once you have stored your data into data frames and identified the  
  # data markers, name each of your variables. Using computational methods 
  # (e.g., a for loop), name each variable using the data marker. You should 
  # have named each of the variables from each data frame. 
  
  
  names(df_list[[i]]) <- df_list[[i]][1,]  # Setting the name of each column 
  # to be the same as first row
  
  df_list[[i]] <- df_list[[i]][-1,]        # Remove the first row
  
  
  #*****************************************************************************
  
  # Remove Specific Data. 
  
  # For this assignment we only need the columns containing the number of
  # samples and gyroscope's data. Thus, maintain only the gyroscope data
  # and drop the undesired data. At the end, each data frame should have 
  # four columns only. 
  
  
  df_list[[i]] <- subset(df_list[[i]], select = c(Sample, gX,gY,gz))
  
  #We extract a subset of each dataframe in df_list with only 4 variables 
  # which are Sample, gX,gY,gz
}




#*******************************************************************************

#  Remove from the environment variables that are not needed, 
#  maintain only the data frames after Step 5

ls()                                     #gives all the items in environment

ls(pattern = "df_")                      #Gives items that shows a pattern "df_"


#  setdiff function gives the different items between ls() and ls(pattern = "df_"). 


rm(list = setdiff(ls(), ls(pattern = "df_")))  #removes all the different items


# Only the list df_list containing all dataframes remains 
# in the environment after this step.


#-------------------------------------------------------------------------------



for (i in 1:length(df_list)){
  
  #*****************************************************************************
  
  # Remove empty cells or NAs. 
  
  # Make sure that there are not empty cells or NAs in your 
  # variables. If so, remove the whole row that contains an empty cell or a NA; 
  # if not deeded, inform that within your code using comments. 
  
  any(is.na(df_list[[i]]))                #To check for NAs
  
  df_list[[i]] <- subset(df_list[[i]], gX!="" & gY!="" & gz!="") # Extracts only 
  #non empty rows
  
  print(names(df_list[[i]]))
  
  
  
  #*****************************************************************************
  
  # Check data Structure.Make sure that the variables in the data frame are  
  # numeric,if not, convert the variables into a numeric data type; you might  
  # need to remove any character/symbol within the observations using   
  # computational methods. 
  
  
  #To check the data structure
  
  str(df_list[[i]])    #The variables in each dataframe are character datatype
  
  
  # To convert variables to numeric datatype
  
  # We use function as.numeric()
  
  df_list[[i]]$Sample <- as.numeric(df_list[[i]]$Sample)  #Make "Sample" numeric
  
  df_list[[i]]$gX <- as.numeric(df_list[[i]]$gX)          #Make "gX" numeric
  
  df_list[[i]]$gY <- as.numeric(df_list[[i]]$gY)          #Make "gY" numeric
  
  df_list[[i]]$gz <- as.numeric(df_list[[i]]$gz)          #Make "gz" numeric
  
  #To assign names for the new dataframes
  
  assign(paste0("dataframe_", i),df_list[[i]]) 
  
  print(df_list[[i]])                                      #View in console
  
}



#*******************************************************************************

# Signal Calibration. 

# Use the first rest period of each activity to remove the offset (the amount
# in which the signal is above the 0.0 horizontal line) of each variable. 
# You will need to compute the arithmetic mean of the rest period 
# (e.g., mean(rest)) and then subtract the mean value from the entire 
# variable.




test_duration <- 50                               #Total time taken for the test

for ( i in 1: length(df_list)){
  
  sample_rate <- nrow(df_list[[i]]) %/% test_duration               # 1 sec data
  
  #for 1st 10 sec data
  
  rest_data <- df_list[[i]][1:(sample_rate*10), ]  #To get the first 10 sec data
  
  
  # To subtract the mean value from the entire variable
  
  #for variable gX
  
  df_list[[i]] $ gX <- df_list[[i]] $ gX - mean(rest_data $ gX) 
  
  #for variable gY
  
  df_list[[i]] $ gY <- df_list[[i]] $ gY - mean(rest_data $ gY)
  
  #for variable gz
  
  df_list[[i]] $ gz <- df_list[[i]] $ gz - mean(rest_data $ gz) 
  
}


#********************************************************************************


# Plot data. 

# Explore the data by visualising its content. Using the data from the four activities 
# plot these activities in a single plot. Each variable (x,y,z) should be 
# represented with a different colour, label the plot accordingly. Repeat the same 
# procedure for the rest of the subjects, at the end you should have three plots (one 
# for each subject). Example below.



subject1 <- df_list[1:4]  #1st 4 dataframes from df_list belonging to Subject 1 

subject2 <- df_list[5:8]  #Next 4 dataframes from df_list belonging to Subject 2 

subject3 <- df_list[9:12] #Last 4 dataframes from df_list belonging to Subject 3


#Create a list containing subject1,subject2 & subject3

subj_list  <- list(subject1, subject2, subject3)



for (i in 1:length(subj_list)){
  
  #Gyroscopc X
  
  #From each dataframe, the gX variable is considered in subj_x
  
  subj_x <- c( subj_list[[i]][[1]] $ gX,  subj_list[[i]][[2]] $ gX,  
               subj_list[[i]][[3]] $ gX,  subj_list[[i]][[4]] $ gX)
  
  #Gyroscopc Y
  
  #From each dataframe, the gY variable is considered in subj_y
  
  subj_y <- c( subj_list[[i]][[1]] $ gY,  subj_list[[i]][[2]] $ gY,  
               subj_list[[i]][[3]] $ gY,  subj_list[[i]][[4]] $ gY)
  
  
  #Gyroscopc z
  
  #From each dataframe, the gz variable is considered in subj_z
  
  subj_z <- c( subj_list[[i]][[1]] $ gz,  subj_list[[i]][[2]] $ gz,  
               subj_list[[i]][[3]] $ gz,  subj_list[[i]][[4]] $ gz)
  
  
  #To form a matrix , subj containing subj_x, subj_y, subj_z
  
  subj <- rbind(subj_x, subj_y, subj_z)
  
  
  #Plotting
  
  plot(unlist(subj_x) ,ylim = range(subj_x, subj_y, subj_z),        
       
       ylab = "Rotational Velocity(degrees/sec)",                  #y axis label
       
       xlab = "Sample",                                            #x axis label
       
       col="red", 
       
       type="l",                                                     #type= line
       
       main= paste("Subject", i, "-All activities"))                 #plot title
  
  
  lines(unlist(subj_y), col="green")                           #For gyroscopic Y
  
  lines(unlist(subj_z), col="blue")                            #For gyroscopic z
  
  
  
  first_activity <- nrow(subj_list[[i]][[1]])
  
  second_activity <- first_activity + nrow(subj_list[[i]][[2]])
  
  third_activity <- second_activity+ nrow(subj_list[[i]][[3]])
  
  fourth_activity <- third_activity + nrow(subj_list[[i]][[4]])
  
  
  #To give border for each activity
  
  abline(v=c(first_activity, second_activity, third_activity, fourth_activity),
         
         col="#838B83", lwd=1, lty=2 )
  
  
  #To give text for each activity
  
  text(x= first_activity -500,  y= min(subject3[[4]]), "Activity 1")    #for Activity1
  
  text(x= second_activity -500, y=min(subject3[[4]]) , "Activity 2")    #for Activity2
  
  text(x= third_activity -500,  y=min(subject3[[4]]) , "Activity 3")    #for Activity3
  
  text(x=fourth_activity -500,  y=min(subject3[[4]]) , "Activity 4")    #for Activity4 
  
  
  #To give legend to the plot
  
  legend("topleft",legend=c("gx","gy","gz"),        #Legend will be in the top left
         
         lty=1,lwd=1,pch=18,cex = 0.75,
         
         col=c("red","green","blue"),
         
         text.col=c("red","green","blue"))
  
}


#**********************************************8********************************

# Get only the ~30 seconds of activity. Remove the rest data (~10sec) before and after 
# the activity for each activity.

experiment_duration <- list() #empty list

mean_gx <- list()             #empty list

mean_gy <- list()             #empty list

mean_gz <- list()             #empty list

sd_gx <- list()             #empty list

sd_gy <- list()             #empty list

sd_gz <- list()             #empty list



for (i in 1:length(df_list)){
  
  sample_rate <- nrow(df_list[[i]]) %/% test_duration   #1 sec data
  
  first_resting_time <- 10*sample_rate        #1st 10 sec data
  
  final_resting_time <- 40*sample_rate        #1st 40 sec data
  
  final_resting_end_time <- 50*sample_rate    #50 sec data
  
  #We need 30sec data for each dataframe in df_list which will be 
  # stored in list experiment_duration
  
  experiment_duration[[i]] <- df_list[[i]][(first_resting_time + 1): final_resting_time, ]
  
  
  
  #******************************************************************************
  
  # Simple statistical metrics. Compute the mean and standard deviation for each 
  # activity and for each participant.
  
  mean_gx[[i]] <- mean(experiment_duration[[i]]$gX)  #mean of variable gX for each subject
  
  
  mean_gy[[i]] <- mean(experiment_duration[[i]]$gY)  #mean of variable gY for each subject
  
  
  mean_gz[[i]] <- mean(experiment_duration[[i]]$gz)  #mean of variable gz for each subject
  
  
  sd_gx[[i]] <- sd(experiment_duration[[i]]$gX)        #sd of variable gX for each subject
  
  
  sd_gy[[i]] <- sd(experiment_duration[[i]]$gY)        #sd of variable gY for each subject
  
  
  sd_gz[[i]] <- sd(experiment_duration[[i]]$gz)        #sd of variable gz for each subject
  
}


#*******************************************************************************

# Plot the statistical metrics. Using a boxplot, build a plot using the mean values from 
# the subjects for each activity. You should have three boxes (x,y,z) per activity in a 
# single plot. Repeat the process and build another plot using the standard deviation.
# Example below. 


###### For Mean

#For Activity 1

# Choose only Activity 1 data for Subject 1, subject2 and subject 3
mean_gx_act_1  <- c(mean_gx[[1]], mean_gx[[5]], mean_gx[[9]])     #only gX
mean_gy_act_1  <- c(mean_gy[[1]], mean_gy[[5]], mean_gy[[9]])     #only gY
mean_gz_act_1  <- c(mean_gz[[1]], mean_gz[[5]], mean_gz[[9]])     #only gz 


#For Activity 2
# Choose only Activity 2 data for Subject 1, subject2 and subject 3
mean_gx_act_2  <- c(mean_gx[[2]], mean_gx[[6]], mean_gx[[10]])     #only gX 
mean_gy_act_2  <- c(mean_gy[[2]], mean_gy[[6]], mean_gy[[10]])     #only gY 
mean_gz_act_2  <- c(mean_gz[[2]], mean_gz[[6]], mean_gz[[10]])     #only gz 


#For Activity 3
# Choose only Activity 3 data for Subject 1, subject2 and subject 3
mean_gx_act_3  <- c(mean_gx[[3]], mean_gx[[7]], mean_gx[[11]])     #only gX 
mean_gy_act_3  <- c(mean_gy[[3]], mean_gy[[7]], mean_gy[[11]])     #only gY 
mean_gz_act_3  <- c(mean_gz[[3]], mean_gz[[7]], mean_gz[[11]])     #only gz 


#For Activity 4
# Choose only Activity 4 data for Subject 1, subject2 and subject 3
mean_gx_act_4  <- c(mean_gx[[4]], mean_gx[[8]], mean_gx[[12]])     #only gX 
mean_gy_act_4  <- c(mean_gy[[4]], mean_gy[[8]], mean_gy[[12]])     #only gY 
mean_gz_act_4  <- c(mean_gz[[4]], mean_gz[[8]], mean_gz[[12]])     #only gz 


#To form a matrix, activity_mean

activity_mean <- cbind ( mean_gx_act_1, mean_gy_act_1, mean_gz_act_1,
                         mean_gx_act_2, mean_gy_act_2, mean_gz_act_2,
                         mean_gx_act_3, mean_gy_act_3, mean_gz_act_3,
                         mean_gx_act_4, mean_gy_act_4, mean_gz_act_4 )

#Plotting
boxplot(activity_mean, 
        col = rainbow(3, s = 0.5), 
        at = c(1:3,5:7,9:11,13:15) ,        # Set position for each boxplot
        xaxt = "n",                         # remove the tick labels of the plot 
        xlab = "Mean Values",               # x label
        ylab = "Rotational Velocity",       # y label
        main = "Mean Boxplots"              # plot title
)
axis(side = 1,                              #x axis
     at = c(2,6,10,14),                     # at argument sets where to show the tick marks.
     labels = c("Act 1","Act 2","Act 3", "Act 4"))
legend("topleft",                           # To give legend to the plot
       fill = rainbow(3, s = 0.5), 
       legend = c("x","y","z"), horiz = T)


###### For Standard Deviation

#For Activity 1
# Choose only Activity 1 data for Subject 1, subject2 and subject 3
sd_gx_act_1  <- c(sd_gx[[1]], sd_gx[[5]], sd_gx[[9]])     #only gX 
sd_gy_act_1  <- c(sd_gy[[1]], sd_gy[[5]], sd_gy[[9]])     #only gY 
sd_gz_act_1  <- c(sd_gz[[1]], sd_gz[[5]], sd_gz[[9]])     #only gz 

#For Activity 2
# Choose only Activity 2 data for Subject 1, subject2 and subject 3
sd_gx_act_2  <- c(sd_gx[[2]], sd_gx[[6]], sd_gx[[10]])     #only gX 
sd_gy_act_2  <- c(sd_gy[[2]], sd_gy[[6]], sd_gy[[10]])     #only gY 
sd_gz_act_2  <- c(sd_gz[[2]], sd_gz[[6]], sd_gz[[10]])     #only gz 

#For Activity 3
# Choose only Activity 3 data for Subject 1, subject2 and subject 3
sd_gx_act_3  <- c(sd_gx[[3]], sd_gx[[7]], sd_gx[[11]])     #only gX 
sd_gy_act_3  <- c(sd_gy[[3]], sd_gy[[7]], sd_gy[[11]])     #only gY 
sd_gz_act_3  <- c(sd_gz[[3]], sd_gz[[7]], sd_gz[[11]])     #only gz 

#For Activity 4
# Choose only Activity 4 data for Subject 1, subject2 and subject 3
sd_gx_act_4  <- c(sd_gx[[4]], sd_gx[[8]], sd_gx[[12]])     #only gX 
sd_gy_act_4  <- c(sd_gy[[4]], sd_gy[[8]], sd_gy[[12]])     #only gY 
sd_gz_act_4  <- c(sd_gz[[4]], sd_gz[[8]], sd_gz[[12]])     #only gz 


#To form a matrix, activity_sd

activity_sd <- cbind (  sd_gx_act_1, sd_gy_act_1, sd_gz_act_1,
                        sd_gx_act_2, sd_gy_act_2, sd_gz_act_2,
                        sd_gx_act_3, sd_gy_act_3, sd_gz_act_3,
                        sd_gx_act_4, sd_gy_act_4, sd_gz_act_4 )

#Plotting

boxplot(activity_sd, 
        col = rainbow(3, s = 0.5), 
        at = c(1:3,5:7,9:11,13:15) ,             # Set position for each boxplot
        xaxt = "n",                              # remove the tick labels of the plot 
        xlab = "Standard Deviation Values",      # x label
        ylab = "Rotational Velocity",            # y label
        main = "Standard Deviation Boxplots"     # Plot title
)
axis(side = 1,                                   # x axis 
     at = c(2,6,10,14),                          # at argument sets where to show the tick marks.
     labels = c("Act 1","Act 2","Act 3", "Act 4"))
legend("topleft",                                # To give legend to the plot
       fill = rainbow(3, s = 0.5), 
       legend = c("x","y","z"), 
       horiz = T)







