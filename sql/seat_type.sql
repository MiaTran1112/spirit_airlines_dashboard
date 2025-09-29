WITH base AS (
    SELECT *
    FROM SKYTRAX_REVIEWS_DB.MARTS.FCT_REVIEW_ENRICHED
    WHERE AIRLINE = 'Spirit Airlines'
),
band_counts AS (
    SELECT
        SEAT_TYPE,
        RATING_BAND,
        COUNT(*) AS review_count
    FROM base
    GROUP BY 1,2
),
seat_avg AS (
    SELECT
        SEAT_TYPE,
        ROUND(AVG(AVERAGE_RATING), 3) AS avg_rating_seat
    FROM base
    GROUP BY 1
),
overall AS (
    SELECT ROUND(AVG(AVERAGE_RATING), 2) AS spirit_overall_avg
    FROM base
)
SELECT
    bc.SEAT_TYPE,
    bc.RATING_BAND,
    bc.review_count,
    ROUND(100.0 * bc.review_count/ SUM(bc.review_count) OVER (PARTITION BY bc.SEAT_TYPE), 2) AS percent_share,
    sa.avg_rating_seat,
    (SELECT spirit_overall_avg FROM overall) AS spirit_overall_avg
FROM band_counts bc
JOIN seat_avg sa USING (SEAT_TYPE)
ORDER BY bc.SEAT_TYPE, bc.RATING_BAND;
