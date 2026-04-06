# Supabase Database Schema - TKD Manager

Supabase Project ID: lldlunqzkltclpfzpjxh

## Overview

This document describes the complete database schema for the TKD Manager bracket management system, including all table definitions and Row Level Security (RLS) policies.

---

## Core Tables

### 1. Tournaments Table

Stores tournament information including venue, organizer, and branding

```sql
CREATE TABLE tournaments (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  name TEXT NOT NULL,
  date_range TEXT DEFAULT '',
  venue TEXT DEFAULT '',
  organizer TEXT DEFAULT '',
  left_logo_url TEXT,
  right_logo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

**Columns:**

- `id` - Unique tournament identifier (UUID)
- `user_id` - Owner of the tournament (references auth.users)
- `name` - Tournament name
- `date_range` - Tournament date range (text format)
- `venue` - Tournament venue location
- `organizer` - Tournament organizer name
- `left_logo_url` - Left side logo URL for display
- `right_logo_url` - Right side logo URL for display
- `created_at` - Timestamp when tournament was created
- `updated_at` - Timestamp when tournament was last updated

**Current Rows:** 4

---

### 2. Bracket Snapshots Table

Stores individual bracket generations and configurations with full participant and result data

```sql
CREATE TABLE bracket_snapshots (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  tournament_id UUID NOT NULL REFERENCES tournaments(id),
  label TEXT NOT NULL,
  format TEXT NOT NULL,
  participant_count INTEGER NOT NULL,
  include_third_place_match BOOLEAN DEFAULT false,
  dojang_separation BOOLEAN DEFAULT false,
  classification JSONB DEFAULT '{}',
  generated_at TIMESTAMPTZ,
  participants JSONB DEFAULT '[]',
  result JSONB DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT now(),
  action_history JSONB DEFAULT '[]'
);
```

**Columns:**

- `id` - Unique bracket snapshot identifier (UUID)
- `user_id` - Owner of the bracket (references auth.users)
- `tournament_id` - Associated tournament (references tournaments)
- `label` - Human-readable label for this bracket snapshot
- `format` - Bracket format (e.g., "single elimination", "double elimination")
- `participant_count` - Total number of participants
- `include_third_place_match` - Whether to include third place playoff round
- `dojang_separation` - Whether to separate by dojang (training location)
- `classification` - JSONB object storing classification rules and categories
- `generated_at` - Timestamp when bracket was generated
- `participants` - JSONB array of participant objects
- `result` - JSONB object containing bracket structure, matches, and scores
- `updated_at` - Timestamp when bracket was last modified
- `action_history` - JSONB array tracking all modifications (audit trail)

**Current Rows:** 144

---

### 3. Bracket Theme Presets Table

Stores saved theme configurations for bracket styling

```sql
CREATE TABLE bracket_theme_presets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  theme_config JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now())
);
```

**Columns:**

- `id` - Unique preset identifier (UUID)
- `user_id` - Owner of the preset (references auth.users)
- `theme_config` - JSONB object containing theme configuration (colors, fonts, spacing, etc.)
- `created_at` - Timestamp when preset was created

**Current Rows:** 0

---

### 4. Activation Requests Table

Tracks user requests for account activation/payment

```sql
CREATE TABLE activation_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  contact_name TEXT,
  requested_days INTEGER NOT NULL,
  total_amount INTEGER NOT NULL,
  status TEXT DEFAULT 'pending',
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

**Columns:**

- `id` - Unique request identifier (UUID)
- `user_id` - User requesting activation (references auth.users)
- `contact_name` - Contact person name
- `requested_days` - Number of days requested
- `total_amount` - Total payment amount
- `status` - Request status (pending, approved, rejected)
- `reviewed_at` - Timestamp when admin reviewed the request
- `created_at` - Timestamp when request was created

**Current Rows:** 3

---

### 5. User Activations Table

Tracks active user subscriptions with expiration dates

```sql
CREATE TABLE user_activations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id),
  expires_at TIMESTAMPTZ DEFAULT timezone('utc', (now() + '30 days'::interval)),
  updated_at TIMESTAMPTZ DEFAULT timezone('utc', now()),
  created_at TIMESTAMPTZ DEFAULT timezone('utc', now())
);
```

**Columns:**

- `id` - Unique activation record identifier (UUID)
- `user_id` - User with active subscription (references auth.users, unique)
- `expires_at` - Subscription expiration date
- `updated_at` - Timestamp when record was last updated
- `created_at` - Timestamp when activation was created

**Current Rows:** 2

---

### 6. Admin Users Table

Links to Supabase Auth users with admin privileges

```sql
CREATE TABLE admin_users (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now()
);
```

**Columns:**

- `user_id` - Admin user identifier (references auth.users)
- `created_at` - Timestamp when admin was added

**Current Rows:** 1

---

## Row Level Security (RLS) Policies

### Enable RLS on All Tables

```sql
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE bracket_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE bracket_theme_presets ENABLE ROW LEVEL SECURITY;
ALTER TABLE activation_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_activations ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
```

---

### Tournaments Policies

#### Users can manage their own tournaments

**Policy Name:** `Users can manage their own tournaments`

```sql
CREATE POLICY "Users can manage their own tournaments" ON tournaments
FOR ALL USING (auth.uid() = user_id);
```

---

### Bracket Snapshots Policies

#### Users can select their own brackets

**Policy Name:** `bracket_snapshots_select_own`

```sql
CREATE POLICY "bracket_snapshots_select_own" ON bracket_snapshots
FOR SELECT USING (auth.uid() = user_id);
```

#### Users can insert their own brackets

**Policy Name:** `bracket_snapshots_insert_own`

```sql
CREATE POLICY "bracket_snapshots_insert_own" ON bracket_snapshots
FOR INSERT WITH CHECK (auth.uid() = user_id);
```

#### Users can update their own brackets

**Policy Name:** `bracket_snapshots_update_own`

```sql
CREATE POLICY "bracket_snapshots_update_own" ON bracket_snapshots
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
```

#### Users can delete their own brackets

**Policy Name:** `bracket_snapshots_delete_own`

```sql
CREATE POLICY "bracket_snapshots_delete_own" ON bracket_snapshots
FOR DELETE USING (auth.uid() = user_id);
```

---

### Bracket Theme Presets Policies

#### Users can select their own presets

**Policy Name:** `bracket_theme_presets_select_own`

```sql
CREATE POLICY "bracket_theme_presets_select_own" ON bracket_theme_presets
FOR SELECT USING (auth.uid() = user_id);
```

#### Users can insert their own presets

**Policy Name:** `bracket_theme_presets_insert_own`

```sql
CREATE POLICY "bracket_theme_presets_insert_own" ON bracket_theme_presets
FOR INSERT WITH CHECK (auth.uid() = user_id);
```

#### Users can delete their own presets

**Policy Name:** `bracket_theme_presets_delete_own`

```sql
CREATE POLICY "bracket_theme_presets_delete_own" ON bracket_theme_presets
FOR DELETE USING (auth.uid() = user_id);
```

---

### Admin Users Policies

#### Users can view their own admin status

**Policy Name:** `admin_users_select_own`

```sql
CREATE POLICY "admin_users_select_own" ON admin_users
FOR SELECT USING (user_id = auth.uid());
```

---

### Activation Requests Policies

#### Users can insert their own activation requests

**Policy Name:** `activation_requests_insert_own`

```sql
CREATE POLICY "activation_requests_insert_own" ON activation_requests
FOR INSERT WITH CHECK (user_id = auth.uid());
```

#### Users can select their own activation requests

**Policy Name:** `activation_requests_select_own`

```sql
CREATE POLICY "activation_requests_select_own" ON activation_requests
FOR SELECT USING (user_id = auth.uid());
```

#### Admins can select all activation requests

**Policy Name:** `activation_requests_select_admin`

```sql
CREATE POLICY "activation_requests_select_admin" ON activation_requests
FOR SELECT USING (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.user_id = auth.uid()));
```

#### Admins can update all activation requests

**Policy Name:** `activation_requests_update_admin`

```sql
CREATE POLICY "activation_requests_update_admin" ON activation_requests
FOR UPDATE USING (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.user_id = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.user_id = auth.uid()));
```

---

### User Activations Policies

#### Users can select their own activation

**Policy Name:** `user_activations_select_own`

```sql
CREATE POLICY "user_activations_select_own" ON user_activations
FOR SELECT USING (user_id = auth.uid());
```

#### Users can view own activation (alternative policy name)

**Policy Name:** `Users can view own activation`

```sql
CREATE POLICY "Users can view own activation" ON user_activations
FOR SELECT USING (auth.uid() = user_id);
```

#### Admins can select all activations

**Policy Name:** `user_activations_select_admin`

```sql
CREATE POLICY "user_activations_select_admin" ON user_activations
FOR SELECT USING (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.user_id = auth.uid()));
```

#### Admins can insert activations

**Policy Name:** `user_activations_insert_admin`

```sql
CREATE POLICY "user_activations_insert_admin" ON user_activations
FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.user_id = auth.uid()));
```

#### Admins can update activations

**Policy Name:** `user_activations_update_admin`

```sql
CREATE POLICY "user_activations_update_admin" ON user_activations
FOR UPDATE USING (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.user_id = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE admin_users.user_id = auth.uid()));
```

---

## Security Architecture Summary

### User Access

- Users own their tournaments, bracket snapshots, and theme presets
- Users can fully manage (CRUD) all their own data
- Users can view their own activation requests and activation status
- Users cannot access other users' data

### Admin Access

- Admins can view and modify all activation requests
- Admins can create and manage user activation records
- Admins can view/manage all activation-related operations
- Admin status determined by membership in `admin_users` table

### Data Ownership

- All bracket and tournament operations are scoped to the owning user
- Audit trail preserved via `action_history` JSONB field in bracket snapshots
- Soft reference tracking through `updated_at` timestamps

### Activation System

- Users request trial/paid activation via `activation_requests` table
- Admins review and create corresponding `user_activations` records
- Activation expires per `expires_at` timestamp
- Fresh schema uses UTC timezone for consistency

---

## Reference Data

Total rows by table (as of schema generation):

- tournaments: 4
- bracket_snapshots: 144
- bracket_theme_presets: 0
- activation_requests: 3
- user_activations: 2
- admin_users: 1
