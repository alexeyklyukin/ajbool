BEGIN;
SET max_parallel_workers_per_gather=4;
SET force_parallel_mode=on;

CREATE TABLE parallel_test(i int, data ajbool) WITH (parallel_workers = 4);
INSERT INTO parallel_test
SELECT i, CASE i%3 WHEN 0 THEN 't' WHEN 1 THEN 'f' ELSE 'u' END::ajbool as data
FROM generate_series(1,1e6) i;

EXPLAIN (costs off,verbose)
SELECT COUNT(*) FROM parallel_test WHERE data;

EXPLAIN (costs off,verbose)
SELECT data, COUNT(*) FROM parallel_test GROUP BY 1;
ROLLBACK;