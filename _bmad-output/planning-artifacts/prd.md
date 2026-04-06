---
stepsCompleted:
  - "step-01-init"
  - "step-02-discovery"
  - "step-02b-vision"
  - "step-02c-executive-summary"
  - "step-03-success"
  - "step-04-journeys"
  - "step-05-domain"
  - "step-06-innovation"
  - "step-07-project-type"
  - "step-08-scoping"
  - "step-09-functional"
  - "step-10-nonfunctional"
  - "step-11-polish"
inputDocuments:
  - "project.md"
  - "architecture.md"
  - "dev_guide.md"
documentCounts:
  briefCount: 1
  researchCount: 0
  brainstormingCount: 0
  projectDocsCount: 2
classification:
  projectType: "web_app"
  domain: "sports_event_management"
  complexity: "medium"
  projectContext: "brownfield"
workflowType: "prd"
---

# Product Requirements Document: TKD Tournament Manager

**Project Goal:** To provide Taekwondo organizers with an easy-to-use tool that automatically creates professional tournament brackets and manages scores with cloud-backed data storage and reliable local UI state persistence.

## Executive Summary

The **TKD Tie Sheet Generator** is a one-stop tool for running Taekwondo tournaments smoothly. It solves the headache of hand-drawing brackets or using complicated spreadsheets. Organizers can now create professional tournament sheets with just one tap using cloud-backed storage. It is perfect for gym owners who need a reliable, fast tool with automatic seeding and professional PDF exports.

### What Makes It Special

- **Automatic Teammate Separation:** The tool automatically seeds players so that students from the same school don't have to face each other in the first round.
- **Professional Sheets:** Export high-quality, "gym-ready" PDFs designed to be printed on standard paper.
- **Smart Seeding:** Brackets are intelligently generated with fair matchups based on school affiliation.
- **Reliable Cloud Storage:** All tournament data is securely stored in the cloud with automatic backups.

## What Success Looks Like

### For the User

- **Data Safety:** All tournament match results are backed up to the cloud. Tournament data is recovered automatically when the app restarts.
- **One-Tap Speed:** Go from a list of player names to a fully seeded Taekwondo bracket in under 60 seconds.
- **Professional Quality:** Printed sheets must be perfectly formatted for the gym floor with clear indicators for Red and Blue players.

### For the System

- **Smooth Interaction:** The bracket view remains smooth and fast even for large tournaments with over 100 players.
- **Accuracy:** The system always follows the rules for separating teammates and advancing winners perfectly.
- **Cloud-First Architecture:** The app is built with cloud storage as the primary source of truth for tournament data, enabling multi-device access and disaster recovery.

## Project Scope & Growth

### Phase 1: The Core Engine (Current Focus)

- **Automatic Brackets:** Single and Double Elimination bracket generation with intelligent seeding.
- **Smart Seeding:** Built-in logic to keep students from the same school apart in early rounds using Dojang separation algorithm.
- **Easy Scoring:** A touch-friendly screen for recording points and penalties during matches.
- **Automatic Advancement:** Winners move forward and losers (in double elimination) move down automatically.
- **Cloud Storage:** All tournament data is securely stored in the cloud with real-time persistence.
- **PDF Printing:** Professional export for physical record-keeping with landscape tie sheets.

### Phase 2: Growth Features

- **Round Robin Format:** Support for round-robin tournament scheduling (everyone fights everyone).
- **Swiss System:** Swiss pairing for larger tournaments with fair bracket balancing.
- **Multi-Ring Coordination:** Real-time updates across multiple rings/tables.
- **School Management:** A central dashboard for managing multiple schools and tracking history.

### Phase 3: Long-term Vision

- **Live Spectator View:** A mobile-friendly site where parents and students can track live scores from their phones.
- **Federation Templates:** Templates for large Taekwondo federations (WT, ITF, etc.) with regional ranking integration.
- **Advanced Analytics:** Historical tournament data analysis and athlete performance tracking.

## User Journeys (Stories)

### 1. The Organizer: "Master Park"

Master Park is organizing a regional tournament with 400 athletes. He uploads his player list, and the app instantly builds 12 divisions. The "Teammate Separation" rule ensures students from the same school don't fight each other in the first round. He then generates links for his volunteers, and from his head table, he watches the progress of every match live on his screen.

### 2. The Scorer: "Sarah"

Sarah is a volunteer at Ring 3. She opens her ring-specific link on a tablet and sees the next match: "Alex vs. Ben." She taps buttons on the screen to add points and penalties. When the match ends, Alex is declared the winner and moves to the next round automatically. Sarah doesn't have to worry about paper or manual math.

### 3. The Coach: "Instructor Jane"

Jane has 15 students fighting at different rings. She scans a QR code at the entrance to see the Live Bracket on her phone. She filters for her school name and sees that three of her students are "On Deck." She quickly sends her assistant instructors to the right rings so they are there on time.

### 4. The Tournament Setup: "Quick Bracket Creation"

Master Park prepares for a tournament by uploading an athlete spreadsheet. The system automatically detects athlete names, dojang affiliations, and weight categories. In under 60 seconds, the system generates balanced brackets with the Dojang separation algorithm and produces professional PDF tie sheets ready to print. All tournament data is immediately backed up to the cloud.

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

- **FR4:** The system creates Single and Double Elimination brackets automatically.
- **FR5:** The system automatically seeds players using the Dojang separation algorithm to keep teammates apart in the first round.
- **FR6:** The system advances winners to the next step and routes losers (in double elimination) correctly.

### 3. Managing Matches & Scores

- **FR7:** Users can see current match pairings and advance matches as they complete.
- **FR8:** Users can record match outcomes and update bracket progression.
- **FR9:** Users can view completed bracket trees showing all match results.

### 4. Storage & Printing

- **FR10:** All tournament data is automatically stored in the cloud (Supabase).
- **FR11:** Data is separated by "Tenant ID" so each user's tournaments are private and safe.
- **FR12:** Users can create professional PDF "Tie Sheets" ready for the printer.

## System Performance & Reliability

### Speed and Response

- **NFR 1:** Creating a large bracket with over 100 players must take **less than 3 seconds**.
- **NFR 2:** The bracket view should move smoothly when scrolling, even for large divisions.
- **NFR 3:** PDF export completion must provide immediate feedback to the user.

### Data Security and Reliability

- **NFR 4:** All tournament data is immediately persisted to Supabase with no data loss.
- **NFR 5:** Each user's data is kept private using tenant isolation (auth.uid()-based RLS policies).
- **NFR 6:** User authentication uses Supabase Email/Password with PKCE flow for security.

### Usage

- **Device Support:** Optimized for web browsers on desktop and tablet devices in landscape orientation.
- **Privacy:** This is a private tool and will not be searchable on Google.

---

## Non-Goals for MVP

- **Offline Tournament Data:** Tournament match data requires an active Supabase connection. UI state (bracket format, participant list) persists locally via HydratedBloc for app restart recovery.
- **Round Robin & Swiss Formats:** These formats are deferred to Phase 2.
- **Dark Mode / Venue Display:** Light Material 3 theme only in MVP.
- **Multi-Ring Live Sync:** Real-time multi-ring updates are planned for Phase 2.
- **Mobile Spectator View:** Read-only mobile access is planned for Phase 2.
