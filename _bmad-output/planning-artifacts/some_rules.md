# Universal Tournament Management System
## Complete Rules & Algorithms Reference

---

## Table of Contents

1. [Tournament Format Rules](#1-tournament-format-rules)
2. [Bracket Generation Algorithms](#2-bracket-generation-algorithms)
3. [Single Elimination — Complete Rules](#3-single-elimination--complete-rules)
4. [Double Elimination — Complete Rules](#4-double-elimination--complete-rules)
5. [Round Robin Rules & Scheduling](#5-round-robin-rules--scheduling)
6. [Swiss Rules & Pairing Algorithm](#6-swiss-rules--pairing-algorithm)
7. [Tiebreaker Chain](#7-tiebreaker-chain)
8. [State Machine Rules](#8-state-machine-rules)

---

## 1. Tournament Format Rules

### Single Elimination
Every participant who loses one match is immediately eliminated. The bracket is pre-generated in full before play begins. The total number of matches always equals **N − 1**, where N is the registered participant count. A third-place match is optional and, when enabled, is a standalone match played between the two semi-final losers independent of the final.

### Double Elimination
Participants must lose twice to be eliminated. Two parallel bracket graphs run simultaneously: a **Winners Bracket (WB)** and a **Losers Bracket (LB)**. A loss in the Winners Bracket routes a participant to a specific slot in the Losers Bracket. A loss in the Losers Bracket ends the run entirely. The Grand Final is contested between the WB champion (zero losses) and the LB champion (one loss).

### Round Robin
Every participant plays every other participant exactly once. Total match count is **N × (N − 1) / 2**. Double Round Robin doubles all matches, with home and away assignments alternating between legs.

### Swiss
Participants are never eliminated. All play a fixed number of rounds equal to **⌈log₂(N)⌉**. After each round, players are re-paired against opponents with identical win/loss records. No two participants may face each other more than once across the entire tournament.

### ESports Swiss (Advancement-Based)
A variant where participants play until reaching a preset win or loss threshold rather than a fixed round count. Example: first to 3 wins advances; first to 3 losses is eliminated. Pairing is restricted to participants who share the same current win and loss counts at the time of pairing.

---

## 2. Bracket Generation Algorithms

### Padding Algorithm
If N participants are registered, compute the next power of two: **P = 2^⌈log₂(N)⌉**. Inject **P − N** Bye entities to fill the bracket to exactly P slots. Byes are assigned the numerically lowest seed values so the Fold Seeding algorithm places them opposite the highest seeds, ensuring top-seeded participants receive a first-round walkover.

> **Rule:** All Byes must be placed exclusively in Round 1. No Bye may appear in Round 2 or later. If the bracket is padded correctly to the next power of two, Round 1 absorbs all Byes and every subsequent round is full with no empty slots.

### Fold Seeding Algorithm
Sort all participants and Byes by seed number ascending. Split the sorted list into two halves:
- **Top half:** Seeds 1 through P/2
- **Bottom half:** Seeds P/2+1 through P, reversed

Pair each position across the two halves: Seed 1 vs. Seed P, Seed 2 vs. Seed P−1, and so on. Apply this fold recursively within each sub-bracket quarter and eighth.

**This guarantees:**
- The top seed and second seed cannot meet before the Final
- Seeds 1 through 4 cannot meet before the Semi-Finals
- Seeds 1 through 8 cannot meet before the Quarter-Finals

### Bracket Position Assignment Rule
Fold seeding defines pairings, but positions within the bracket are fixed as follows:
- Seed 1 is placed in Position 1 of the **top half**
- Seed 2 is placed in Position 1 of the **bottom half**
- Seed 3 is placed in the opposite quarter from Seed 1
- Seed 4 is placed in the opposite quarter from Seed 2
- Seeds 5–8 are distributed one per eighth, each in the opposite eighth from their closest higher seed
- This pattern continues recursively for all remaining seeds

Position assignment is **deterministic and locked at generation time**. It must not change after the bracket is published.

### Re-Seeding vs. Fixed Bracket Rule
The system must define one of two configurations before generation:

**Fixed Bracket:** All match node routing is written at generation time and never changes. A lower seed who upsets a higher seed inherits and travels the higher seed's pre-assigned bracket path. No routing entries are ever rewritten after generation.

**Re-Seeded Bracket:** After each round, all remaining participants are re-ranked by current standing and bracket positions are reassigned so the strongest remaining participants remain on opposite sides of the bracket. This requires routing table entries to be rewritten after each round rather than generated upfront. The system must declare which mode is active before the tournament begins, as the two modes require fundamentally different generation logic.

---

## 3. Single Elimination — Complete Rules

### Core Elimination Rule
One loss eliminates a participant from the tournament unconditionally. There are no second chances.

### Match Count Formula
Total matches = **N − 1**
All N − 1 match nodes are instantiated at generation time. No match nodes are created dynamically during play.

### Routing Table at Generation Time
For every match node, the Routing Table must contain exactly one entry:
- **On_Win → Destination Match Node** (the next match in the bracket)

For all matches except the Final, the On_Loss condition has no destination — the participant is eliminated and their slot is marked as such. For the optional third-place match, exactly two On_Loss entries are created: one for each semi-final loser routing to the third-place match node.

### Third-Place Match Rule
When enabled, one additional match node is created at generation time. Both semi-final losers are routed to this node via On_Loss edges. This match is played in parallel with or immediately before the Final and produces no further routing — its winner is assigned third place and its loser fourth place.

### Bye Auto-Advancement Rule
Whenever a participant is routed into a match node where the opposing slot contains a Bye entity, the system immediately marks that match as a Walkover, records the real participant as the winner, and fires a MatchCompleted event. Routing then continues to the next match node.

### Bye Propagation Depth Limit
If a participant receives a Bye in Round 1, and their Round 2 opponent subsequently withdraws before play begins, recursive auto-advancement continues. However, the system must impose a maximum propagation depth of **3 consecutive automatic walkovers** before requiring a human decision. An uncapped recursive chain is a logic risk and must be treated as an error state requiring manual intervention.

---

## 4. Double Elimination — Complete Rules

### Core Elimination Rule
A participant is eliminated only after losing **two matches**. The first loss moves them from the Winners Bracket to the Losers Bracket. The second loss, occurring anywhere in the Losers Bracket, ends their run.

### Match Count Formula
Total match nodes pre-instantiated at generation time: **2N − 2**
One additional node — the Grand Final bracket reset — is **conditionally instantiated** only when the LB champion defeats the WB champion in Game 1 of the Grand Final. It must not be pre-instantiated as a persistent node.

### Winners Bracket Structure
Identical to a standard Single Elimination bracket. All WB routing rules, seeding rules, and position assignment rules from Section 3 apply without modification.

### Losers Bracket Structure
The LB does not mirror the WB. It uses an alternating round structure:

- **Drop-In Rounds (even LB round numbers):** Fresh losers arriving from the Winners Bracket are injected and paired against LB survivors. No LB survivor plays another LB survivor in this round type.
- **Consolidation Rounds (odd LB round numbers):** LB survivors play each other exclusively. No new players are introduced. The field is halved.

This alternating structure continues until one participant remains in the LB. That participant advances to the Grand Final.

### WB-to-LB Drop Mapping Rule
The specific round in which a WB loser enters the LB is determined by which WB round they lost in:

| WB Loss Round | LB Entry Round             |
| ------------- | -------------------------- |
| WB Round 1    | LB Round 1 (Consolidation) |
| WB Round 2    | LB Round 2 (Drop-In)       |
| WB Round 3    | LB Round 4 (Drop-In)       |
| WB Round 4    | LB Round 6 (Drop-In)       |
| WB Round R    | LB Round 2(R − 1)          |

This staggered mapping ensures a player who just lost in the WB does not immediately face a player who has already survived multiple LB rounds. The mapping must be **explicitly encoded in the Routing Table at generation time**, not inferred or calculated at runtime.

### Losers Bracket Internal Seeding Rule
When participants drop into the same LB round from the WB, they must not be placed in the same half of the LB sub-bracket if they came from the same WB sub-bracket half. This mirrors the fold seeding principle: the goal is to prevent rematches as long as possible and ensure the two strongest LB participants remain on opposite sides until the LB Final.

### Grand Final Structure
The Grand Final is contested between the WB champion (zero losses) and the LB champion (one loss). Two configurations are valid and the system must declare one before generation:

**Configuration A — WB Advantage (Standard):**
The WB champion needs only one win to claim the title. The LB champion must win two consecutive matches. Game 1 is played normally. If the LB champion wins Game 1, a bracket reset (Game 2) is played with both participants at one loss each. If the WB champion wins Game 1, the tournament ends immediately — no reset.

**Configuration B — Neutral Final:**
The Grand Final is a single decisive game with no structural advantage given to either finalist. The first to win the required number of games (Best of 1, Best of 3, etc.) wins the tournament.

> The system must encode the active configuration in the Routing Table before the tournament begins. The two configurations produce different conditional routing logic and cannot be switched after generation.

### Grand Final Bracket Reset Rule
The bracket reset match node is conditionally instantiated only if the LB champion wins Game 1. At that moment the system:
1. Creates one new match node
2. Assigns both finalists to it with each carrying exactly one loss
3. Fires a MatchNodeCreated event
4. Notifies all connected clients of the new node via the real-time push layer

If the WB champion wins Game 1, the bracket reset node is **never created**.

---

## 5. Round Robin Rules & Scheduling

### Berger Table Scheduling Algorithm
Fix one participant as an anchor. In each round, rotate all other participants clockwise by one position around the anchor. Each rotation produces one complete round of N/2 simultaneous matches, with no participant appearing more than once per round. For odd N, a Bye entity occupies the anchor position and the participant opposite it in any given rotation receives a rest round that round.

### Round Count
For N participants, the total number of rounds required so every participant has faced every other participant exactly once is:
- **N − 1 rounds** if N is even
- **N rounds** if N is odd (due to Bye rotation)

### Double Round Robin
All matches from the single round robin are repeated in a second leg. Home and away assignments are swapped between legs. The second leg uses the same Berger rotation sequence in reverse order to ensure balanced scheduling.

### No Routing Table
Round Robin generates **no Routing Table entries** at generation time. There are no advancement paths. All match nodes are peers. Results flow exclusively to the Standings entity.

---

## 6. Swiss Rules & Pairing Algorithm

### Round Count Rule
The recommended number of rounds for N participants is **⌈log₂(N)⌉**.

| Participants | Minimum Rounds |
| ------------ | -------------- |
| 8            | 3              |
| 16           | 4              |
| 32           | 5              |
| 64           | 6              |
| 128          | 7              |
| 256          | 8              |

### Halt State Rule
The Generation Engine may not produce Round R+1 until every match in Round R is in a Completed or Forfeited state. A single unresolved match in the current round freezes all pairing for the next round.

### Score-Group Formation
After each round, all participants are sorted into Score Groups — clusters of players sharing an identical win/loss/draw record. Within each group, participants are ordered by their primary configured tiebreaker score descending.

### Dutch Pairing Algorithm (FIDE Standard)
Within each Score Group:
1. Split the group into a **top half** and a **bottom half** by rank within the group
2. Pair Position 1 of the top half against Position 1 of the bottom half, Position 2 against Position 2, and so on

Two hard constraints govern every pairing:
- **No rematches:** No participant may be paired against a prior opponent at any point in the tournament
- **Color/side balance:** In formats with a color or side assignment, each participant's color history across all prior rounds must be considered. A participant who has played more games on one side than the other should receive the opposite side in the next round where possible

### Downfloating Rule
When a valid pairing cannot be completed within a Score Group due to rematch conflicts, the unpaired participant is downfloated to the **next lower Score Group** and paired against the highest-ranked eligible opponent in that group. The downfloated participant plays a stronger-record opponent than normal for that round.

### Backtracking Rule
If downfloating fails — because all candidates in the lower group are also prior opponents — the algorithm backtracks to the previous pairing attempt within the original Score Group and tries the next-best combination. Backtracking continues until a valid pairing is found. If no valid pairing exists anywhere, the tournament director must be notified for manual resolution.

### Core Matching Problem
The pairing engine is formally a **maximum weighted matching problem on a general graph**. Each potential pairing is an edge. Edge weights encode preference:
- Same Score Group opponent → highest weight
- Adjacent Score Group (downfloat) → medium weight
- Prior opponent → weight zero (forbidden, never selected)

The **Edmonds Blossom Algorithm** solves this optimally in **O(n³)** time.

### No Routing Table
Like Round Robin, Swiss generates **no pre-written Routing Table entries**. Routing for each round is calculated dynamically by the pairing engine after the previous round is fully resolved.

---

## 7. Tiebreaker Chain

When participants share an equal score, tiebreakers are evaluated in the configured priority order. Evaluation stops as soon as a difference is found between tied participants.

### Buchholz (BH)
Sum of all opponents' final point totals across the tournament. Rewards the participant who faced the strongest field.

### Buchholz Cut-1 (BH-1)
Buchholz score minus the single lowest opponent score. Reduces the influence of one very weak opponent dragging a score down unfairly.

### Median Buchholz
Buchholz score minus both the highest and lowest opponent scores. The most balanced variant; recommended for large open events.

### Sonneborn-Berger (SB)
Sum of the final scores of every defeated opponent, plus half the final scores of every drawn opponent. Rewards winning specifically against strong opponents rather than just accumulating wins against weak ones.

### Average Rating of Opponents (ARO)
Mean ELO or seed rating of all opponents faced. Most applicable in rating-based events and esports brackets where participants carry numerical rankings.

### Head-to-Head
The direct match result between the two tied participants. Applicable only when the tied participants have met during the tournament. When more than two participants are tied, head-to-head is evaluated as a mini round-robin subset of results among only the tied group.

### Cumulative Score
The running sum of a participant's score recorded after each individual round, accumulated across all rounds. Rewards front-loaded performance — a participant who wins early accumulates more cumulative score than one who wins the same total but concentrated in later rounds.

### Playoff / Coin-Flip Protocol
If all configured tiebreakers are exhausted without resolution, a live playoff match is the required final arbiter. A coin-flip or random draw is reserved only for logistical situations where a playoff match is impossible to organize.

---

## 8. State Machine Rules

### Legal Match States
`Pending → CheckIn → InProgress → [Disputed] → Completed`
`Pending → CheckIn → Forfeited`
`Pending → Walkover` *(Bye opponent only)*

### Transition Rules

| From       | Trigger                          | To         | Side Effect                                    |
| ---------- | -------------------------------- | ---------- | ---------------------------------------------- |
| Pending    | Scheduled window opens           | CheckIn    | Notifications sent to both participants        |
| CheckIn    | Both participants confirm        | InProgress | Match timer starts if applicable               |
| CheckIn    | Window expires, one absent       | Forfeited  | Absent participant penalized                   |
| CheckIn    | Window expires, both absent      | Escalated  | Human review required                          |
| InProgress | Score submitted                  | Disputed   | Dispute window timer starts                    |
| Disputed   | Window expires with no challenge | Completed  | MatchCompleted event fired                     |
| Disputed   | Challenge raised                 | Disputed   | DisputeRaised event; downstream routing frozen |
| Disputed   | Director resolves                | Completed  | Corrected MatchCompleted event fired           |
| Completed  | Routing table query              | —          | Downstream match slots populated               |
| Pending    | Opponent slot is Bye             | Walkover   | Auto-advancement fires immediately             |

### Auto-Advancement Rule
Whenever a participant is routed into a match node where the opposing slot is a Bye entity, the system immediately marks that match as a Walkover, declares the real participant the winner, and fires a MatchCompleted event. This triggers recursive routing to the next match node.

### Bye Propagation Depth Limit
A maximum of **3 consecutive automatic walkovers** are permitted before the system enters an error state and requires human intervention. An uncapped recursive chain is a generation logic error.

### Dispute Window Rule
A configurable dispute window opens after every score submission before the MatchCompleted event fires. If no dispute is raised before the window closes, the match resolves automatically. If a dispute is raised, all downstream routing is frozen until a director-level authority issues a resolution.

### Auto-Forfeit Rule
If a participant fails to check in within the configured check-in window, the match resolves in favor of the participant who did check in. If neither checks in, the match escalates for human review. The organization must define a default forfeit policy before any tournament using check-in enforcement goes live.

### Optimistic Concurrency Control Rule
Every match node carries an integer version field. A score submission is accepted only if the version number matches the value read at the start of the operation. If the version has changed — meaning a concurrent submission was processed first — the command is rejected with a conflict error and the submitter must retry with the current state. This prevents duplicate completions without requiring distributed locks.

### Idempotency Rule
Every score submission command carries a unique client-generated idempotency key. If the same key arrives more than once, the system returns the result of the first processing without re-executing any logic. This makes all submissions safe to retry on network failure without risk of double-completion or duplicate events.

---

*End of Document — UTMS Rules & Algorithms v2.0*