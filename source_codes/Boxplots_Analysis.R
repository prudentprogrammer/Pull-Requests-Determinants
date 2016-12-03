library(lsr)
full_data = read.csv(file="../preprocessed_data_v4.csv", header=TRUE, sep=',')

merged_data = subset(full_data, merged == 'True')
unmerged_data = subset(full_data, merged== 'False')

merged_data_closed = merged_data$gh_commits_on_files_touched
unmerged_data_closed = unmerged_data$gh_commits_on_files_touched


wilcox.test(merged_data_closed, unmerged_data_closed, alternative='less')

boxplot(merged_data_closed, unmerged_data_closed, outline = FALSE, col=(c("blue","darkgreen")),
        main="Number of Commits: Merged vs Non-Merged", names = c("Merged", "Non-Merged") , ylab="Counts")



cohensD(merged_data_closed, unmerged_data_closed)

#hist(log(full_data$deletions + 0.5))
#summary(full_data$deletions)


