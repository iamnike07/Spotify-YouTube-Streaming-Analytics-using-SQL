# 🎵 Spotify & YouTube Streaming Analytics using SQL

## 📌 Project Overview
This project performs an in-depth analytical study of Spotify tracks using SQL.  
It focuses on understanding music popularity, engagement patterns, platform dominance, and statistical outliers by leveraging **advanced SQL techniques** such as window functions, ranking, cumulative metrics, and Z-score analysis.

The dataset combines **Spotify audio features** with **YouTube engagement metrics**, making it suitable for real-world data analytics and interview preparation.

---

## 🛠️ Tech Stack
- PostgreSQL
- SQL (Window Functions, Subqueries, Aggregations)
- pgAdmin / psql
- CSV Dataset

---

## 📊 Dataset Description
The dataset includes:
- Artist & track metadata
- Spotify streaming counts
- YouTube views, likes, comments
- Audio features (energy, danceability, liveness, etc.)
- Platform indicators (most_played_on, official_video)

---

## 📁 Database Schema

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


🔍 Key Analyses Performed
1️⃣ Platform Dominance

Compared Spotify streams vs YouTube views

Identified platform-specific success patterns

2️⃣ Engagement Efficiency

Likes per view ratio

High-engagement but low-visibility tracks

3️⃣ Duration vs Popularity

Short, medium, and long tracks vs average streams

4️⃣ Artist-Level Performance

Tracks outperforming artist averages

Consistency and variability across artists

5️⃣ Advanced Window Function Analysis

Cumulative likes ordered by views

Ranking top tracks per artist and album

6️⃣ Statistical Outlier Detection

Z-score based detection of viral tracks

Identified tracks exceeding 2 standard deviations above mean

📈 Key Insights

A small percentage of tracks contribute to a large share of total streams

High energy does not always guarantee popularity

Official videos significantly improve YouTube engagement

Z-score analysis helps identify viral outliers effectively

🎯 Skills Demonstrated

Advanced SQL querying

Window functions & ranking

Statistical analysis using SQL

Real-world business logic

Clean, interview-ready query design

🚀 Future Enhancements

Power BI dashboard for visualization

Artist-level trend analysis

Machine learning-based popularity prediction
