select t1.qid, t1.aid as powerup, t1.dqid, t1.log_ts as timestamp
from player_actions_log as t1 left outer join player_quests_log as t2 on t1.dqid = t2.dqid and t2.q_s_id = 0 
where (t1.aid=71 or t1.aid=72) and (t1.cid=5 or t1.cid=6 or t1.cid=7);
