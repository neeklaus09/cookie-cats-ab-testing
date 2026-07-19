# A/B Testing: Cookie Cats , Does Delaying the Progression Gate Hurt Retention?

An analysis of a real, randomized A/B test from the mobile game **Cookie Cats**, testing whether
moving a progression gate from level 30 to level 40 affects player retention.

## Business Problem

Cookie Cats places a gate that forces players to wait (or pay) to progress, at level 30. The
product team tested moving this gate to level 40 to see if giving players more uninterrupted
content before the first wall would improve retention. This project analyzes that experiment
to answer: **should the gate move to level 40, or stay at level 30?**

## Data

- Source: public Cookie Cats A/B test dataset, 90,189 players
- Columns: `userid`, `version` (gate_30 / gate_40), `sum_gamerounds`, `retention_1`, `retention_7`
- Tools: PostgreSQL (data validation, aggregation, segmentation) → Python/SciPy (significance
  testing) → Excel (stakeholder summary)

## Method

1. **Data validation** (SQL): checked for duplicate users, nulls, and outliers before trusting
   any result.
2. **Core hypothesis test** (SQL + Python): compared 1-day and 7-day retention between gate_30
   and gate_40 using a two-proportion z-test.
3. **Segment analysis** (SQL + Python): broke players into casual / regular / hardcore groups by
   engagement level (`sum_gamerounds`) to check whether the retention effect was uniform or
   concentrated in specific player types.

## Key Findings

**Data quality:** found and excluded one outlier user (`userid 6390605`) with 49,854 game
rounds — over 16x the next-highest player — before running the segment analysis, since a
single extreme value can distort bucketed rates.

**Overall retention:**

| Metric | gate_30 | gate_40 | p-value | Significant? |
|---|---|---|---|---|
| 1-day retention | 44.82% | 44.23% | 0.074 | No |
| 7-day retention | 19.02% | 18.20% | 0.0016 | **Yes** |

The 1-day gap alone wasn't conclusive — but the 7-day gap was, revealing a real, compounding
effect that a short-term-only view would have missed.

**By engagement segment (7-day retention):**

| Segment | gate_30 | gate_40 | p-value | Significant? |
|---|---|---|---|---|
| Casual (≤10 rounds) | 1.81% | 1.79% | 0.887 | No |
| Regular (11-50 rounds) | 12.03% | 10.81% | 0.00075 | **Yes** |
| Hardcore (50+ rounds) | 56.31% | 53.74% | 0.00010 | **Yes** |

**The real story:** casual players show almost no difference between versions, because most
of them quit long before ever reaching the gate. The retention gap is entirely driven by
regular and hardcore players — the ones actually engaged enough to hit the wall — and for
them, a later, bigger gate causes measurably more churn than an earlier one.

## Recommendation

**Keep the gate at level 30. Do not roll out gate_40.** The later gate placement does not
improve retention for any player segment, and it measurably harms retention among the game's
most engaged players — the ones with the highest long-term value.

## Repo Structure

```
ab_testing_project/
├── README.md
├── data/
│   └── cookie_cats.csv
├── sql/
│   └── analysis_queries.sql       # all SQL: table creation, validation, retention, segments
└── notebook/
    └── ab_test_analysis.ipynb     # z-tests and significance testing
```

## How to Reproduce

1. Load `cookie_cats.csv` into PostgreSQL using the schema and queries in `sql/analysis_queries.sql`
2. Run the notebook in `notebook/` to reproduce the z-test results
3. All queries and code use PostgreSQL 18 and Python 3 with `scipy`, `numpy`

## Possible Extensions

- Power analysis to confirm the test's sample size was adequate to detect this effect size
- Re-test after a longer holdout period to confirm the 7-day effect doesn't itself fade over time
- Test whether the effect differs by acquisition channel or platform (iOS vs Android), if that
  data were available
