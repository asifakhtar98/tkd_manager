# Supabase Authentication Methods

Complete reference for all authentication methods.

## Email/Password Authentication

### Sign Up

```javascript
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123',
  options: {
    data: {
      first_name: 'John',
      last_name: 'Doe',
      age: 27
    },
    emailRedirectTo: 'https://yourapp.com/welcome'
  }
})

// Returns:
// - data.user: User object
// - data.session: Session (null if email confirmation required)
```

**Email Verification**:
- Hosted projects: Email verification required by default
- Self-hosted/local: Disabled by default
- If enabled, session is null until email verified

### Sign In

```javascript
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123'
})

// Returns:
// - data.user: User object
// - data.session: Session with access_token and refresh_token
```

## Magic Link (Passwordless)

Magic links are one-time use links sent via email.

```javascript
const { data, error } = await supabase.auth.signInWithOtp({
  email: 'user@example.com',
  options: {
    shouldCreateUser: false,  // Don't create user if doesn't exist
    emailRedirectTo: 'https://yourapp.com/welcome'
  }
})
```

**Limitations**:
- One request per 60 seconds per user
- Links expire after 1 hour
- One-time use only

## OTP (One-Time Password)

Uses same API as magic links but with 6-digit codes.

### Email OTP

```javascript
// Send OTP
const { data, error } = await supabase.auth.signInWithOtp({
  email: 'user@example.com'
})

// Verify OTP
const { data: { session }, error } = await supabase.auth.verifyOtp({
  email: 'user@example.com',
  token: '123456',
  type: 'email'
})
```

### Phone OTP

```javascript
// Send OTP to phone
const { data, error } = await supabase.auth.signInWithOtp({
  phone: '+13334445555'
})

// Verify phone OTP
const { data: { session }, error } = await supabase.auth.verifyOtp({
  phone: '+13334445555',
  token: '123456',
  type: 'sms'
})
```

**Note**: Phone auth requires SMS provider configuration (Twilio, etc.)

## OAuth Providers

### Supported Providers

- `apple`, `azure`, `bitbucket`, `discord`, `facebook`
- `github`, `gitlab`, `google`, `keycloak`, `linkedin`
- `notion`, `twitch`, `twitter`, `slack`, `spotify`
- `workos`, `zoom`

### Sign In with OAuth

```javascript
const { data, error } = await supabase.auth.signInWithOAuth({
  provider: 'github',
  options: {
    redirectTo: 'https://yourapp.com/auth/callback',
    scopes: 'repo read:user'  // Provider-specific scopes
  }
})
```

### Sign In with ID Token (Native Apps)

```javascript
const { data, error } = await supabase.auth.signInWithIdToken({
  provider: 'google',
  token: 'your-id-token-from-google-sdk'
})
```

### OAuth Callback Handling

```javascript
// In your callback route
import { useEffect } from 'react'

function AuthCallback() {
  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session) {
        // Redirect to app
        window.location.href = '/dashboard'
      }
    })
  }, [])

  return <div>Loading...</div>
}
```

## Anonymous Authentication

Create temporary users without credentials.

```javascript
// Sign in anonymously
const { data, error } = await supabase.auth.signInAnonymously()

// Check if user is anonymous
const isAnonymous = data.session.user.is_anonymous
```

### Convert Anonymous to Permanent

```javascript
// Step 1: Add email
const { error } = await supabase.auth.updateUser({
  email: 'user@example.com'
})

// Step 2: User verifies email, then add password
const { error } = await supabase.auth.updateUser({
  password: 'password123'
})

// Or link OAuth identity
const { error } = await supabase.auth.linkIdentity({
  provider: 'google'
})
```

## Identity Management

### Link Additional Identity

```javascript
const { data, error } = await supabase.auth.linkIdentity({
  provider: 'google'
})
```

### Unlink Identity

```javascript
const { data, error } = await supabase.auth.unlinkIdentity({
  identity_id: 'identity-uuid'
})
```

### Get User Identities

```javascript
const { data: { identities }, error } = await supabase.auth.getUserIdentities()
```

## Update User

```javascript
// Update email (sends confirmation)
const { data, error } = await supabase.auth.updateUser({
  email: 'newemail@example.com'
})

// Update password
const { data, error } = await supabase.auth.updateUser({
  password: 'new_password'
})

// Update metadata
const { data, error } = await supabase.auth.updateUser({
  data: { full_name: 'Jane Doe' }
})
```

## Sign Out

```javascript
// Sign out current session
const { error } = await supabase.auth.signOut()

// Sign out all sessions globally
const { error } = await supabase.auth.signOut({ scope: 'global' })

// Sign out other sessions (keep current)
const { error } = await supabase.auth.signOut({ scope: 'others' })
```

**Scopes**:
- `global` (default): Terminates all sessions
- `local`: Only current session
- `others`: All but current session

## Error Handling

```javascript
const { data, error } = await supabase.auth.signInWithPassword({ ... })

if (error) {
  switch (error.message) {
    case 'Invalid login credentials':
      console.error('Wrong email or password')
      break
    case 'Email not confirmed':
      console.error('Please verify your email')
      break
    case 'User already registered':
      console.error('Email already in use')
      break
    default:
      console.error('Auth error:', error.message)
  }
  return
}

// Success
console.log('User:', data.user)
```

## Common Error Codes

| Error | Description |
|-------|-------------|
| `invalid_credentials` | Wrong email/password |
| `email_not_confirmed` | Email not verified |
| `user_not_found` | User doesn't exist |
| `user_already_exists` | Email already registered |
| `weak_password` | Password doesn't meet requirements |
| `otp_expired` | OTP code expired |
| `refresh_token_not_found` | Invalid refresh token |
