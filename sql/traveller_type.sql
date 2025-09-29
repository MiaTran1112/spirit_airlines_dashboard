WITH base AS (
  SELECT *
  FROM SKYTRAX_REVIEWS_DB.MARTS.FCT_REVIEW_ENRICHED
  WHERE AIRLINE = 'Spirit Airlines'
),
band_counts AS (
  SELECT
      TYPE_OF_TRAVELLER,
      RATING_BAND,
      COUNT(*) AS review_count
  FROM base
  GROUP BY 1,2
),
traveller_avg AS (
  SELECT
      TYPE_OF_TRAVELLER,
      ROUND(AVG(AVERAGE_RATING), 2) AS avg_rating_traveller
  FROM base
  GROUP BY 1
),
overall AS (
  SELECT ROUND(AVG(AVERAGE_RATING), 2) AS spirit_overall_avg
  FROM base
)
SELECT
    bc.TYPE_OF_TRAVELLER,
    bc.RATING_BAND,
    bc.review_count,
    ROUND(100.0 * bc.review_count/ SUM(bc.review_count) OVER (PARTITION BY bc.TYPE_OF_TRAVELLER), 2) AS percent_share,
    ta.avg_rating_traveller,          -- weighted by review counts
    (SELECT spirit_overall_avg FROM overall) AS spirit_overall_avg
FROM band_counts bc
JOIN traveller_avg ta USING (TYPE_OF_TRAVELLER)
ORDER BY bc.TYPE_OF_TRAVELLER, bc.RATING_BAND;
