DROP TABLE IF EXISTS final_projects_prs;
CREATE TABLE final_projects_prs
SELECT *
FROM all_pr_features
INNER JOIN (
SELECT slug
FROM all_pr_features
GROUP BY slug
HAVING COUNT(*) > 10 ) GT_170
USING (slug);



DROP TABLE IF EXISTS temp_gh_tt_join;
CREATE TABLE temp_gh_tt_join AS
SELECT
slug,
tt.gh_team_size,
tt.git_num_commits AS git_num_commits,
tt.`gh_num_issue_comments` AS  gh_num_issue_comments,
prf.`comments` AS num_commit_comments,
prf.`review_comments` AS pull_req_comments,
tt.`gh_num_pr_comments` AS gh_num_pr_comments ,
prf.`additions`,
prf.`deletions`,
prf.`churn`,
prf.`changed_files`,
tt.`gh_src_churn` ,
tt.`gh_test_churn` ,
tt.`gh_files_added` ,
tt.`gh_files_deleted` ,
tt.`gh_files_modified` ,
tt.`gh_tests_added` ,
tt.`gh_tests_deleted` ,
tt.`gh_src_files` ,
tt.`gh_doc_files` ,
tt.`gh_other_files`,
tt.`gh_commits_on_files_touched` ,
tt.`gh_sloc`,
tt.`gh_test_lines_per_kloc` ,
tt.`gh_test_cases_per_kloc` ,
tt.`gh_asserts_cases_per_kloc`,
tt.`gh_by_core_team_member`,
prf.`title_len`,
prf.`desc_len`,
tt.`git_num_committers`,
prf.`Id` ,
prf.`state`,
prf.`merged`,
prf.`merge_commit_sha` ,
prf.`delta_mins_merge`,
prf.`delta_mins_close`,
prf.updated_at
FROM final_projects_prs as prf
INNER JOIN
`travistorrent_27_10_2016` as tt
ON tt.gh_pull_req_num = prf.`pr_num`
;

DROP TABLE gh_tt_join_proj_info;
CREATE TABLE gh_tt_join_proj_info AS
SELECT temp_gh_tt_join.*,open_issues_count, watchers_count, subscribers_count
FROM temp_gh_tt_join
INNER JOIN all_project_info
USING (slug);

DROP TABLE IF EXISTS final_preprocessed_data;
CREATE TABLE final_preprocessed_data AS 
SELECT *
FROM
(
SELECT 
slug,
gh_team_size,
git_num_commits,
gh_num_issue_comments,
num_commit_comments,
pull_req_comments,
gh_num_pr_comments ,
`additions`,
`deletions`,
`churn`,
`changed_files`,
`gh_src_churn` ,
`gh_test_churn` ,
`gh_files_added` ,
`gh_files_deleted` ,
`gh_files_modified` ,
`gh_tests_added` ,
`gh_tests_deleted` ,
`gh_src_files` ,
`gh_doc_files` ,
`gh_other_files`,
`gh_commits_on_files_touched` ,
`gh_sloc`,
`gh_test_lines_per_kloc` ,
`gh_test_cases_per_kloc` ,
`gh_asserts_cases_per_kloc`,
`gh_by_core_team_member`,
`title_len`,
`desc_len`,
`git_num_committers`,
`Id` ,
`state`,
`merged`,
`merge_commit_sha` ,
`delta_mins_merge`,
`delta_mins_close`,
updated_at,
open_issues_count,
 watchers_count, 
 subscribers_count
FROM gh_tt_join_proj_info
GROUP BY 
slug,
gh_team_size,
git_num_commits,
gh_num_issue_comments,
num_commit_comments,
pull_req_comments,
gh_num_pr_comments ,
`additions`,
`deletions`,
`churn`,
`changed_files`,
`gh_src_churn` ,
`gh_test_churn` ,
`gh_files_added` ,
`gh_files_deleted` ,
`gh_files_modified` ,
`gh_tests_added` ,
`gh_tests_deleted` ,
`gh_src_files` ,
`gh_doc_files` ,
`gh_other_files`,
`gh_commits_on_files_touched` ,
`gh_sloc`,
`gh_test_lines_per_kloc` ,
`gh_test_cases_per_kloc` ,
`gh_asserts_cases_per_kloc`,
`gh_by_core_team_member`,
`title_len`,
`desc_len`,
`git_num_committers`,
`Id` ,
`state`,
`merged`,
`merge_commit_sha` ,
`delta_mins_merge`,
`delta_mins_close`,
updated_at,
open_issues_count,
 watchers_count, 
 subscribers_count) stuff
 ORDER BY updated_at;


SELECT SUM(total_pr)
FROM(
SELECT slug, COUNT(*) as total_pr
FROM all_pr_features
GROUP BY slug
HAVING COUNT(*) > 10 
ORDER BY COUNT(*) DESC)
X;

SELECT slug, COUNT(*)
FROM `final_preprocessed_data`
GROUP BY slug
ORDER BY COUNT(*) DESC;
/*CREATE INDEX tt_pull_req
ON travistorrent_27_10_2016(gh_pull_req_num);*/

/*CREATE INDEX pr_feat_pull_req
ON all_pr_features(pr_num);*/

SELECT *
FROM travistorrent_27_10_2016
WHERE `gh_pull_req_num` = 9306;

SELECT cur_month, COUNT(*)
FROM
(SELECT MONTH(updated_at) as cur_month
FROM final_projects_prs
) R
GROUP BY cur_month;

SELECT cur_month, SUM(CASE WHEN merged = 'True' then 1 else 0 END) as accepted, SUM(CASE WHEN merged = 'False' then 1 else 0 END) as rejected,COUNT(merged) as total
FROM
(
SELECT MONTH(updated_at) as cur_month, merged
FROM `final_preprocessed_data`
) S
GROUP BY cur_month;
