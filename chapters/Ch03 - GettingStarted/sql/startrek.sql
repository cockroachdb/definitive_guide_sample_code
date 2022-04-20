USE startrek;

SELECT id,
    title,
    count(*) AS quote_count
FROM episodes AS e
    LEFT OUTER JOIN quotes AS q ON (e.id = q.episode)
GROUP BY id,
    title
ORDER BY 3 DESC
LIMIT 10; 

 