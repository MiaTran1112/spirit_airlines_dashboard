WITH spirit_reviews AS (
  SELECT 
      CABIN_STAFF_SERVICE,
      INFLIGHT_ENTERTAINMENT,
      FOOD_AND_BEVERAGES,
      SEAT_COMFORT,
      WIFI_AND_CONNECTIVITY
  FROM SKYTRAX_REVIEWS_DB.MARTS.FCT_REVIEW_ENRICHED
  WHERE AIRLINE = 'Spirit Airlines'
)
SELECT 
    rating_type,
    AVG(rating_value) AS avg_rating
FROM spirit_reviews
UNPIVOT (
    rating_value FOR rating_type IN (
        CABIN_STAFF_SERVICE, 
        INFLIGHT_ENTERTAINMENT, 
        FOOD_AND_BEVERAGES, 
        SEAT_COMFORT, 
        WIFI_AND_CONNECTIVITY
    )
) AS unpvt
GROUP BY rating_type
ORDER BY avg_rating DESC;
