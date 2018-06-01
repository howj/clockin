select t1.qid, t1.dqid, t1.log_q_id as start_id, t2.log_q_id as end_id, t1.q_detail as start_details, t2.q_detail as end_details, t1.client_ts as start_ts, t2.client_ts as end_ts from player_quests_log as t1 left outer join player_quests_log as t2 on t1.dqid = t2.dqid and t2.q_s_id = 0 where t1.qid=8 and t1.q_s_id = 1 and t1.cid=2 group by uid;