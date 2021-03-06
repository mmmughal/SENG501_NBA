# NBA bball

###### This part of the code was from the original file
rm(list = ls()) # clear the history from the previous run (i.e. variables)
cat("\014")# Clear Console
closeAllConnections() # close any file connections if any
dev.off()# Clear All Graphs in the plot area

######Set the system parameters and environments variables
hcmd <-system("which hadoop", intern = TRUE)
Sys.setenv(HADOOP_CMD=hcmd)

hstreaming <- system("find /usr -name hadoop-streaming*jar", intern=TRUE)
Sys.setenv(HADOOP_STREAMING= hstreaming[1])

Sys.getenv("HADOOP_CMD")
Sys.getenv("HADOOP_STREAMING")

library(rmr2)
library (rhdfs)
library(lattice)
library(nutshell)
library(igraph)

# install.packages("forecast")
library(forecast)
library(fpp)

hdfs.init()

#****************** CoachesCareer **************

coachesCareer.col.classes <-
  c(coachid  ="factor", firstname ="factor", lastname ="factor",  season_win ="integer", season_loss ="integer", playoff_win ="integer", playoff_loss ="integer")

coachesCareer.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = coachesCareer.col.classes,
    col.names = names(coachesCareer.col.classes)
  )

#coachesCareer
coachesCareer.hdfs<-from.dfs('/user/biadmin/coachescareer.csv',format=coachesCareer.in.format)
coachesCareer_data<-coachesCareer.hdfs$val

#****************** CoachSeason ****************

coachSeason.col.classes <-
  c(coachid="factor",year="integer",yr_older="integer",firstname="factor",lastname="factor",season_win="integer",season_loss="integer",playoff_win="integer",playoff_loss="integer",team="factor"
  )
coachSeason.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = coachSeason.col.classes,
    col.names = names(coachSeason.col.classes)
  )

#coachSeason
coachSeason.hdfs<-from.dfs('/user/biadmin/coachseason.csv',format=coachSeason.in.format)
coachSeason_data<-coachSeason.hdfs$val

total <- merge(coachesCareer_data,coachSeason_data,by="coachid")

#****************** Draft *********************
draft.col.classes <-
 c(draft_year ="integer",   draft_round ="integer",  selection ="integer",  team ="factor",    firstname ="factor",
   lastname ="factor",   ilkid ="factor", draft_from ="factor", leag ="factor"
  )
draft.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = draft.col.classes,
    col.names = names(draft.col.classes)
  )

draft.hdfs<-from.dfs('/user/biadmin/draft.csv',format=draft.in.format)
draft_data<-draft.hdfs$val
#***************** playerAllstar ***************
playerAllstar.col.classes <-
 c(ilkid="factor",year="integer",firstname="factor",lastname="factor",conference="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
  dreb="integer", oreb="integer",  reb ="integer", asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
   fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
  )
playerAllstar.in.format <-
 make.input.format(
  "csv",
   sep = ",",
    colClasses = playerAllstar.col.classes,
    col.names = names(playerAllstar.col.classes)
  )
#playerAllstar
playerAllstar.hdfs<-from.dfs('/user/biadmin/playerallstar.csv',format=playerAllstar.in.format)
playerAllstar_data<-playerAllstar.hdfs$val
#ilkid <- merge(draft_data,playerAllstar_data,by="ilkid")
#***************** playerPlayoff ****************
playerPlayoff.col.classes <-
  c(ilkid="factor",year="integer",firstname="factor",lastname="factor",team="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
    dreb="integer", oreb="integer", reb ="integer", asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
    fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
  )
playerPlayoff.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = playerPlayoff.col.classes,
    col.names = names(playerPlayoff.col.classes)
  )

#playerPlayoff
playerPlayoff.hdfs<-from.dfs('/user/biadmin/playerplayoff.csv',format=playerPlayoff.in.format)
playerPlayoff_data<-playerPlayoff.hdfs$val

#****************** playerPlayoffCareer *********
playerPlayoffCareer.col.classes <-
  c(ilkid="factor",firstname="factor",lastname="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
    dreb="integer", oreb="integer", reb="integer",asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
    fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
  )
playerPlayoffCareer.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = playerPlayoffCareer.col.classes,
    col.names = names(playerPlayoffCareer.col.classes)
  )

#playerPlayoffCareer
playerPlayoffCareer.hdfs<-from.dfs('/user/biadmin/playerplayoffcareer.csv',format=playerPlayoffCareer.in.format)
playerPlayoffCareer_data<-playerPlayoffCareer.hdfs$val

#****************** playerRegularSeason **********
playerRegularSeason.col.classes <-
  c(ilkid="factor",year="integer",firstname="factor",lastname="factor",team="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
    oreb="integer", dreb="integer", reb="integer", asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
    fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
  )
playerRegularSeason.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = playerRegularSeason.col.classes,
    col.names = names(playerRegularSeason.col.classes)
  )

#playerRegularSeason
playerRegularSeason.hdfs<-from.dfs('/user/biadmin/playerregularseason.csv',format=playerRegularSeason.in.format)
playerRegularSeason_data<-playerRegularSeason.hdfs$val

#****************** playerRegularSeasonCareer ****************
playerRegularSeasonCareer.col.classes <-
  c(ilkid="factor",firstname="factor",lastname="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
    oreb="integer", dreb="integer", reb="integer",asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
    fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
  )
playerRegularSeasonCareer.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = playerRegularSeasonCareer.col.classes,
    col.names = names(playerRegularSeasonCareer.col.classes)
  )	

#playerRegularSeasonCareer
playerRegularSeasonCareer.hdfs<-from.dfs('/user/biadmin/playerregularseasoncareer.csv',format=playerRegularSeasonCareer.in.format)
playerRegularSeasonCareer_data<-playerRegularSeasonCareer.hdfs$val



#****************** PLAYER *********************
# define for data format for player
player.col.classes <-
  c(ilkid="factor", firstname="factor", lastname="factor", position="factor", firstseason="integer", lastseason="integer", h_feet="double", h_inches="double", 
    weight="double", college="factor", birthdate ="factor"
  )
player.in.format <- 
  make.input.format(
    "csv",
    sep = ",",
    colClasses = player.col.classes,
    col.names = names(player.col.classes)
  )

#player
player.hdfs<-from.dfs('/user/biadmin/player.csv',format=player.in.format)
player_data<-player.hdfs$val
##Merging all ilkid data
playoff<- merge(playerPlayoff_data,playerPlayoffCareer_data,by="ilkid")
regularseason<- merge(playerRegularSeason_data,playerRegularSeasonCareer_data,by="ilkid")
#allstar<- merge(player_data,playerAllstar_data,by="ilkid")
#finalilkid <- merge(bigilkid,bigilkid2,by="ilkid")

#****************** TEAM ***********************

######################### Define the Data format (i.e. according to the available data study the format and adopt it to col classes and names)
team.col.classes <-
  c(team ="factor", location ="factor",   name ="factor", leag ="factor"
  )
team.in.format <- 
  make.input.format(
    "csv", 
    sep = ",",
    colClasses = team.col.classes,
    col.names = names(team.col.classes)
  )

#############Read The file using from.dfs
team.hdfs<-from.dfs('/user/biadmin/teams.csv',format=team.in.format) # read the file with a specified format
team_data<-team.hdfs$val


#***************** teamSeason *******************
teamSeason.col.classes <- 
  c(team="factor",year="integer",leag="factor",o_fgm="integer",o_fga="integer",o_ftm="integer",o_fta="integer",o_oreb="integer",o_dreb="integer",o_reb="integer", o_asts="integer",
    o_pf="integer", o_stl="integer", o_to="integer", o_blk="integer", o_3pm="integer", o_3pa="integer", o_pts="integer", d_fgm="integer", d_fga="integer", d_ftm="integer",
    d_fta="integer", d_oreb="integer", d_dreb="integer", d_reb="integer",d_asts="integer",d_pf="integer", d_stl="integer", d_to="integer", d_blk="integer", d_3pm="integer",
    d_3pa="integer", d_pts="integer", pace="double", won="integer", lost="integer"
  )
teamSeason.in.format <-
  make.input.format(
    "csv",
    sep = ",",
    colClasses = teamSeason.col.classes,
    col.names = names(teamSeason.col.classes)
  )

#teamSeason
teamSeason.hdfs<-from.dfs('/user/biadmin/teamseason.csv',format=teamSeason.in.format)
teamSeason_data<-teamSeason.hdfs$val


#teamstats 
teamstats<- merge(team_data,teamSeason_data,by="team")

playoffteam<- merge(teamstats, playoff, by="team")
regularteam<- merge(regularseason, teamstats, by="team")
coachteam<- merge(coachSeason_data,teamstats, by="team")

tryCatch{{ predictTeamResult <- function(team1, team2, filterSeason)
{
	teamone = team1
	teamtwo = team2
	filterSeason = filterSeason
	
					#****************** CoachesCareer **************

					coachesCareer.col.classes <-
					  c(coachid  ="factor", firstname ="factor", lastname ="factor",  season_win ="integer", season_loss ="integer", playoff_win ="integer", playoff_loss ="integer")

					coachesCareer.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = coachesCareer.col.classes,
						col.names = names(coachesCareer.col.classes)
					  )

					#coachesCareer
					coachesCareer.hdfs<-from.dfs('/user/biadmin/coachescareer.csv',format=coachesCareer.in.format)
					coachesCareer_data<-coachesCareer.hdfs$val

					#****************** CoachSeason ****************

					coachSeason.col.classes <-
					  c(coachid="factor",year="integer",yr_older="integer",firstname="factor",lastname="factor",season_win="integer",season_loss="integer",playoff_win="integer",playoff_loss="integer",team="factor"
					  )
					coachSeason.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = coachSeason.col.classes,
						col.names = names(coachSeason.col.classes)
					  )

					#coachSeason
					coachSeason.hdfs<-from.dfs('/user/biadmin/coachseason.csv',format=coachSeason.in.format)
					coachSeason_data<-coachSeason.hdfs$val

					total <- merge(coachesCareer_data,coachSeason_data,by="coachid")

					#****************** Draft *********************
					draft.col.classes <-
					 c(draft_year ="integer",   draft_round ="integer",  selection ="integer",  team ="factor",    firstname ="factor",
					   lastname ="factor",   ilkid ="factor", draft_from ="factor", leag ="factor"
					  )
					draft.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = draft.col.classes,
						col.names = names(draft.col.classes)
					  )

					draft.hdfs<-from.dfs('/user/biadmin/draft.csv',format=draft.in.format)
					draft_data<-draft.hdfs$val
					#***************** playerAllstar ***************
					playerAllstar.col.classes <-
					 c(ilkid="factor",year="integer",firstname="factor",lastname="factor",conference="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
					  dreb="integer", oreb="integer",  reb ="integer", asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
					   fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
					  )
					playerAllstar.in.format <-
					 make.input.format(
					  "csv",
					   sep = ",",
						colClasses = playerAllstar.col.classes,
						col.names = names(playerAllstar.col.classes)
					  )
					#playerAllstar
					playerAllstar.hdfs<-from.dfs('/user/biadmin/playerallstar.csv',format=playerAllstar.in.format)
					playerAllstar_data<-playerAllstar.hdfs$val
					#ilkid <- merge(draft_data,playerAllstar_data,by="ilkid")
					#***************** playerPlayoff ****************
					playerPlayoff.col.classes <-
					  c(ilkid="factor",year="integer",firstname="factor",lastname="factor",team="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
						dreb="integer", oreb="integer", reb ="integer", asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
						fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
					  )
					playerPlayoff.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = playerPlayoff.col.classes,
						col.names = names(playerPlayoff.col.classes)
					  )

					#playerPlayoff
					playerPlayoff.hdfs<-from.dfs('/user/biadmin/playerplayoff.csv',format=playerPlayoff.in.format)
					playerPlayoff_data<-playerPlayoff.hdfs$val

					#****************** playerPlayoffCareer *********
					playerPlayoffCareer.col.classes <-
					  c(ilkid="factor",firstname="factor",lastname="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
						dreb="integer", oreb="integer", reb="integer",asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
						fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
					  )
					playerPlayoffCareer.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = playerPlayoffCareer.col.classes,
						col.names = names(playerPlayoffCareer.col.classes)
					  )

					#playerPlayoffCareer
					playerPlayoffCareer.hdfs<-from.dfs('/user/biadmin/playerplayoffcareer.csv',format=playerPlayoffCareer.in.format)
					playerPlayoffCareer_data<-playerPlayoffCareer.hdfs$val

					#****************** playerRegularSeason **********
					playerRegularSeason.col.classes <-
					  c(ilkid="factor",year="integer",firstname="factor",lastname="factor",team="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
						oreb="integer", dreb="integer", reb="integer", asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
						fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
					  )
					playerRegularSeason.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = playerRegularSeason.col.classes,
						col.names = names(playerRegularSeason.col.classes)
					  )

					#playerRegularSeason
					playerRegularSeason.hdfs<-from.dfs('/user/biadmin/playerregularseason.csv',format=playerRegularSeason.in.format)
					playerRegularSeason_data<-playerRegularSeason.hdfs$val

					#****************** playerRegularSeasonCareer ****************
					playerRegularSeasonCareer.col.classes <-
					  c(ilkid="factor",firstname="factor",lastname="factor",leag="factor",gp="integer",minutes="integer",pts="integer",
						oreb="integer", dreb="integer", reb="integer",asts="integer", stl="integer", blk="integer", turnover="integer", pf="integer", fga="integer", 
						fgm="integer", fta="integer", ftm="integer", tpa="integer", tpm="integer"
					  )
					playerRegularSeasonCareer.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = playerRegularSeasonCareer.col.classes,
						col.names = names(playerRegularSeasonCareer.col.classes)
					  )	

					#playerRegularSeasonCareer
					playerRegularSeasonCareer.hdfs<-from.dfs('/user/biadmin/playerregularseasoncareer.csv',format=playerRegularSeasonCareer.in.format)
					playerRegularSeasonCareer_data<-playerRegularSeasonCareer.hdfs$val



					#****************** PLAYER *********************
					# define for data format for player
					player.col.classes <-
					  c(ilkid="factor", firstname="factor", lastname="factor", position="factor", firstseason="integer", lastseason="integer", h_feet="double", h_inches="double", 
						weight="double", college="factor", birthdate ="factor"
					  )
					player.in.format <- 
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = player.col.classes,
						col.names = names(player.col.classes)
					  )

					#player
					player.hdfs<-from.dfs('/user/biadmin/player.csv',format=player.in.format)
					player_data<-player.hdfs$val
					##Merging all ilkid data
					playoff<- merge(playerPlayoff_data,playerPlayoffCareer_data,by="ilkid")
					regularseason<- merge(playerRegularSeason_data,playerRegularSeasonCareer_data,by="ilkid")
					#allstar<- merge(player_data,playerAllstar_data,by="ilkid")
					#finalilkid <- merge(bigilkid,bigilkid2,by="ilkid")

					#****************** TEAM ***********************

					######################### Define the Data format (i.e. according to the available data study the format and adopt it to col classes and names)
					team.col.classes <-
					  c(team ="factor", location ="factor",   name ="factor", leag ="factor"
					  )
					team.in.format <- 
					  make.input.format(
						"csv", 
						sep = ",",
						colClasses = team.col.classes,
						col.names = names(team.col.classes)
					  )

					#############Read The file using from.dfs
					team.hdfs<-from.dfs('/user/biadmin/teams.csv',format=team.in.format) # read the file with a specified format
					team_data<-team.hdfs$val


					#***************** teamSeason *******************
					teamSeason.col.classes <- 
					  c(team="factor",year="integer",leag="factor",o_fgm="integer",o_fga="integer",o_ftm="integer",o_fta="integer",o_oreb="integer",o_dreb="integer",o_reb="integer", o_asts="integer",
						o_pf="integer", o_stl="integer", o_to="integer", o_blk="integer", o_3pm="integer", o_3pa="integer", o_pts="integer", d_fgm="integer", d_fga="integer", d_ftm="integer",
						d_fta="integer", d_oreb="integer", d_dreb="integer", d_reb="integer",d_asts="integer",d_pf="integer", d_stl="integer", d_to="integer", d_blk="integer", d_3pm="integer",
						d_3pa="integer", d_pts="integer", pace="double", won="integer", lost="integer"
					  )
					teamSeason.in.format <-
					  make.input.format(
						"csv",
						sep = ",",
						colClasses = teamSeason.col.classes,
						col.names = names(teamSeason.col.classes)
					  )

					#teamSeason
					teamSeason.hdfs<-from.dfs('/user/biadmin/teamseason.csv',format=teamSeason.in.format)
					teamSeason_data<-teamSeason.hdfs$val

	teamstatistics<- merge(team_data,teamSeason_data,by="team")
	
	#team filter
	teamfiltered = subset(teamstatistics, team== teamone)
	
	#teamstats 
	if(filterSeason == "regularseason") {
		teamstats<- merge(regularseason, teamfiltered, by="team")
	}
	else if(filterSeason == "playoff") {
		teamstats<- merge(teamfiltered, playoff, by="team")
	}
	else # for all star
	{
	}
	
	
	
	###map reduce only direct from file... 
	# mapteamdata <- function(.,lines) {
		# key <- cbind(lines$year.y,lines$ilkid) # key composed of year (for teamseason data)
		# t_value5 <- 1 
		# values <- cbind(lines$pts.x, lines$o_pts, lines$won, lines$lost, t_value5)  #pts.x = player on team pts for year, o_pts= team overall points
		
		# keyval (key, values)
	# }
	
	# reduceteamdata <- function(key,values) {
		# t_count = sum(values[5])
		# t_pts <- sum(values[1], na.rm=TRUE) / t_count
		# t_opts <- max(values[2], na.rm=TRUE) / t_count
		# t_won <- max(values[3],na.rm=TRUE)/t_count
		# t_lost <- max(values[4],na.rm=TRUE)/t_count
		
		# values <- cbind(t_pts, t_opts, t_won, t_lost)
		# keyval (key, values)
	# }

	# TeamPlayerDataSummary <- mapreduce(input = teamstats, input.format =air.in.format, 
}

