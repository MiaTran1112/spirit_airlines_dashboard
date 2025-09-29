WITH base AS (
  SELECT
    DATE_TRUNC('year', DATE_SUBMITTED_ID) AS review_year,
    CABIN_STAFF_SERVICE,
    FOOD_AND_BEVERAGES,
    GROUND_SERVICE,
    INFLIGHT_ENTERTAINMENT,
    WIFI_AND_CONNECTIVITY
  FROM SKYTRAX_REVIEWS_DB.MARTS.FCT_REVIEW_ENRICHED
  WHERE AIRLINE = 'Spirit Airlines'
    AND DATE_SUBMITTED_ID IS NOT NULL
)
SELECT
  review_year,
  rating_type,
  AVG(rating_value) AS avg_rating,
  COUNT(rating_value) AS review_count
FROM base
UNPIVOT (
  rating_value FOR rating_type IN (
    CABIN_STAFF_SERVICE,
    FOOD_AND_BEVERAGES,
    GROUND_SERVICE,
    INFLIGHT_ENTERTAINMENT,
    WIFI_AND_CONNECTIVITY
  )
) u
GROUP BY review_year, rating_type
ORDER BY review_year, rating_type;
