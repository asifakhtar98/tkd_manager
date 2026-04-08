# Supabase Session Management

Complete reference for session lifecycle, tokens, and state management.

## Session Structure

A session consists of:
- **Access Token (JWT)**: Short-lived (default 1 hour), contains user claims
- **Refresh Token**: Longer-lived, single-use, used to get new access tokens

## Get Session

### Client-Side (getSession)

```javascript
// Fast, reads from local storage
const { data: { session }, error } = await supabase.auth.getSession()

if (session) {
  console.log('Access token:', session.access_token)
  console.log('Refresh token:', session.refresh_token)
  console.log('User:', session.user)
  console.log('Expires at:', session.expires_at)
}
```

**Warning**: Don't use for server-side authorization - doesn't validate JWT.

### Server-Side (getUser)

```javascript
// Validates JWT against Auth server (secure)
const { data: { user }, error } = await supabase.auth.getUser()

if (user) {
  console.log('User ID:', user.id)
  console.log('Email:', user.email)
  console.log('Metadata:', user.user_metadata)
}
```

**Always use on server** for authorization decisions.

## Auth State Changes

```javascript
const { data: { subscription } } = supabase.auth.onAuthStateChange(
  (event, session) => {
    console.log('Event:', event)
    console.log('Session:', session)
  }
)

// Cleanup on unmount
subscription.unsubscribe()
```

### Events

| Event | Description |
|-------|-------------|
| `INITIAL_SESSION` | Initial session load |
| `SIGNED_IN` | User signed in |
| `SIGNED_OUT` | User signed out |
| `TOKEN_REFRESHED` | Access token refreshed |
| `USER_UPDATED` | User metadata updated |
| `PASSWORD_RECOVERY` | Password reset initiated |

### React Example

```javascript
import { useEffect, useState } from 'react'

function AuthProvider({ children }) {
  const [session, setSession] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
      setLoading(false)
    })

    // Listen for changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setSession(session)
      }
    )

    return () => subscription.unsubscribe()
  }, [])

  if (loading) return <div>Loading...</div>

  return children
}
```

## Token Refresh

### Automatic Refresh

Supabase automatically refreshes tokens before expiry. No action needed.

### Manual Refresh

```javascript
const { data: { session }, error } = await supabase.auth.refreshSession()
```

### Handle Refresh Events

```javascript
supabase.auth.onAuthStateChange((event, session) => {
  if (event === 'TOKEN_REFRESHED') {
    console.log('New access token:', session.access_token)
    // Update external services if needed
  }
})
```

## Set Session

For SSR or when you have tokens from elsewhere:

```javascript
const { data: { session }, error } = await supabase.auth.setSession({
  access_token: 'your-access-token',
  refresh_token: 'your-refresh-token'
})
```

## Session Configuration

### JWT Expiry

- **Default**: 1 hour (3600 seconds)
- **Minimum**: 5 minutes (shorter causes performance issues)
- **Configure**: Dashboard → Auth → Settings → JWT expiry limit

### Refresh Token Behavior

- **Single-use**: Each refresh token can only be used once
- **Reuse window**: 10-second window for concurrent requests
- **Rotation**: Enabled by default for security

### Session Termination

Sessions terminate when:
1. User signs out
2. User changes password
3. Security-sensitive actions occur
4. Inactivity timeout (Pro plan)
5. Maximum lifetime expiration (Pro plan)
6. Single-session enforcement (Pro plan)

## Server-Side Rendering (SSR)

### Install SSR Package

```bash
npm install @supabase/ssr
```

### Browser Client

```javascript
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  )
}
```

### Server Client (Next.js)

```javascript
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const cookieStore = await cookies()

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {
            // Server Component - cookies are read-only
          }
        }
      }
    }
  )
}
```

### Middleware (Required for SSR)

```typescript
// middleware.ts
import { type NextRequest, NextResponse } from 'next/server'
import { createServerClient } from '@supabase/ssr'

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          response = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options)
          )
        }
      }
    }
  )

  // Refresh session
  await supabase.auth.getUser()

  return response
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico).*)']
}
```

## Storage Options

### Local Storage (Default)

```javascript
// Default behavior - persists in localStorage
const supabase = createClient(url, key)
```

### Custom Storage

```javascript
const supabase = createClient(url, key, {
  auth: {
    storage: {
      getItem: (key) => customGet(key),
      setItem: (key, value) => customSet(key, value),
      removeItem: (key) => customRemove(key)
    }
  }
})
```

### Disable Persistence

```javascript
const supabase = createClient(url, key, {
  auth: {
    persistSession: false
  }
})
```

## Protected Routes

### Client-Side Check

```javascript
async function checkAuth() {
  const { data: { session } } = await supabase.auth.getSession()

  if (!session) {
    window.location.href = '/login'
    return null
  }

  return session
}
```

### Server-Side Check (Next.js)

```javascript
import { redirect } from 'next/navigation'

export default async function ProtectedPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  return <div>Protected content for {user.email}</div>
}
```

## JWT Claims

Access token contains claims you can use:

```javascript
const { data: { session } } = await supabase.auth.getSession()

// Decode JWT (client-side)
const payload = JSON.parse(atob(session.access_token.split('.')[1]))

console.log(payload.sub)        // User ID
console.log(payload.email)      // Email
console.log(payload.role)       // Role (authenticated/anon)
console.log(payload.aal)        // Assurance level (aal1/aal2)
console.log(payload.session_id) // Session ID
console.log(payload.exp)        // Expiration timestamp
```
