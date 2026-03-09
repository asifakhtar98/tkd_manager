---
stepsCompleted:
  - 'step-01-init'
  - 'step-02-discovery'
  - 'step-02b-vision'
  - 'step-02c-executive-summary'
  - 'step-03-success'
  - 'step-04-journeys'
  - 'step-05-domain'
  - 'step-06-innovation'
  - 'step-07-project-type'
  - 'step-08-scoping'
  - 'step-09-functional'
  - 'step-10-nonfunctional'
  - 'step-11-polish'
inputDocuments:
  - 'project.md'
  - 'architecture.md'
  - 'dev_guide.md'
documentCounts:
  briefCount: 1
  researchCount: 0
  brainstormingCount: 0
  projectDocsCount: 2
classification:
  projectType: 'web_app'
  domain: 'sports_event_management'
  complexity: 'medium'
  projectContext: 'brownfield'
workflowType: 'prd'
---

# Product Requirements Document: TKD Tournament Manager

**Project Goal:** To provide Taekwondo organizers with an easy-to-use tool that automatically creates professional tournament brackets and manages scores, even without an internet connection.

## Executive Summary
The **TKD Tie Sheet Generator** is a one-stop tool for running Taekwondo tournaments smoothly. It solves the headache of hand-drawing brackets or using complicated spreadsheets. Organizers can now create professional tournament sheets with just one tap—no internet required. It is perfect for gym owners who need a reliable tool that works even when the gym Wi-Fi is down.

### What Makes It Special
- **Automatic Teammate Separation:** The tool automatically seeds players so that students from the same school don't have to face each other in the first round.
- **Flexible Formats:** Instantly create Single Elimination, Double Elimination, or Round Robin (everyone fights everyone) brackets.
- **Professional Sheets:** Export high-quality, "gym-ready" PDFs designed to be printed on standard paper.
- **Data Safety:** All scores are saved directly on your tablet or computer. You never have to worry about losing data if the app closes or the battery dies.

## What Success Looks Like

### For the User
- **Bulletproof Reliability:** 100% confidence that match results are safe. Even if the app closes accidentally, everything is restored right where you left it.
- **One-Tap Speed:** Go from a list of player names to a fully seeded Taekwondo bracket in under 60 seconds.
- **Professional Quality:** Printed sheets must be perfectly formatted for the gym floor with clear indicators for Red and Blue players.

### For the System
- **Smooth Interaction:** The bracket view remains smooth and fast even for large tournaments with over 100 players.
- **Accuracy:** The system always follows the rules for separating teammates and advancing winners perfectly.
- **Future-Ready:** The core of the app is built so that adding a cloud account later will be easy and won't require a total rewrite.

## Project Scope & Growth

### Phase 1: The Core Engine (Current Focus)
- **Automatic Brackets:** Single, Double, and Round Robin generation.
- **Smart Seeding:** Built-in logic to keep students from the same school apart in early rounds.
- **Easy Scoring:** A touch-friendly screen for recording points and penalties during matches.
- **Automatic Advancement:** Winners move forward and losers (in double elimination) move down automatically.
- **Offline Save:** Everything is saved directly on your device so it works without Wi-Fi.
- **PDF Printing:** Professional export for physical record-keeping.

### Phase 2: Growth Features
- **Cloud Sync:** Connect your data to an online account to see results across multiple tablets.
- **School Management:** A central dashboard for managing multiple schools and federations.
- **Staff Accounts:** Restricted links for volunteer scorers that sync back to the main head table.

### Phase 3: Long-term Vision
- **Live Fan View:** A mobile-friendly site where parents and students can track live scores from their phones.
- **National Standards:** Templates for large Taekwondo federations (WT, ITF, etc.) and regional rankings.

## User Journeys (Stories)

### 1. The Organizer: "Master Park"
Master Park is organizing a regional tournament with 400 athletes. He uploads his player list, and the app instantly builds 12 divisions. The "Teammate Separation" rule ensures students from the same school don't fight each other in the first round. He then generates links for his volunteers, and from his head table, he watches the progress of every match live on his screen.

### 2. The Scorer: "Sarah"
Sarah is a volunteer at Ring 3. She opens her ring-specific link on a tablet and sees the next match: "Alex vs. Ben." She taps buttons on the screen to add points and penalties. When the match ends, Alex is declared the winner and moves to the next round automatically. Sarah doesn't have to worry about paper or manual math.

### 3. The Coach: "Instructor Jane"
Jane has 15 students fighting at different rings. She scans a QR code at the entrance to see the Live Bracket on her phone. She filters for her school name and sees that three of her students are "On Deck." She quickly sends her assistant instructors to the right rings so they are there on time.

### 4. The Backup: "Gym Wi-Fi Failure"
Halfway through the finals, the gym Wi-Fi stops working. Scorer Sarah's tablet loses connection, but she keeps scoring because the app saves everything on the tablet itself. She doesn't have to stop the match or go back to paper. When the internet returns 10 minutes later, the app automatically syncs her results back to the main system.

## Domain & Industry Requirements
- **Format Standards:** Support for World Taekwondo (WT) and ITF scoring rules as needed.
- **Youth Privacy:** Careful handling of student data since many competitors are minors.
- **Fair Seeding:** Strict adherence to school separation rules to keep the tournament fair and exciting.

## Functional Requirements (Capability Contract)

### 1. Setup & List Management
- **FR1:** Users can quickly upload player lists from spreadsheets or add them one by one.
- **FR2:** Users can manage athlete details like Name, Age, Weight, Rank, and School names.
- **FR3:** The system validates that all information is complete before creating brackets.

### 2. The Generation Engine
- **FR4:** The system creates Single, Double, and Round Robin brackets automatically.
- **FR5:** The system automatically seeds players to keep teammates apart in the first round.
- **FR6:** The system advances winners to the next step and routes losers (in double elimination) correctly.

### 3. Managing Matches & Scores
- **FR7:** Scorers can see a live queue of matches for their specific ring.
- **FR8:** Scorers can record points, penalties, and different types of wins (KO, Points Gap, etc.).
- **FR9:** Scorers can use an 'Undo' button to fix a mistake without disrupting the tournament flow.

### 4. Storage & Printing
- **FR10:** All data is saved on the tablet so the tournament can continue without internet.
- **FR11:** Data is separated by "Tenant ID" so each school's records are private and safe.
- **FR12:** Users can create professional PDF "Tie Sheets" ready for the printer.

## System Performance & Reliability

### Speed and Response
- **NFR 1:** The scoring buttons must react instantly (**less than 0.1 seconds**) when tapped to ensure accurate timing.
- **NFR 2:** Creating a large bracket with over 100 players must take **less than 3 seconds**.
- **NFR 3:** The bracket view should move smoothly when zooming and scrolling, even for large divisions.

### Data Security and Reliability
- **NFR 4:** If the app closes or is refreshed, it must recover back to the exact current match state in **under 2 seconds**.
- **NFR 5:** No data shall ever be lost during offline usage.
- **NFR 6:** Each school’s data is kept private and cannot be viewed by others.

### Usage
- **Device Support:** Best used on modern tablets (like iPad or Android tablets) in wide (landscape) mode.
- **No Search Engine Tracking:** This is a private tool and will not be searchable on Google.
