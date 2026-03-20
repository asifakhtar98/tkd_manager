# Supabase Multi-Factor Authentication (MFA)

Complete reference for setting up and managing MFA.

## Overview

Supabase supports:
- **TOTP**: Time-based One-Time Password (Google Authenticator, Authy, etc.)
- **Phone**: SMS-based verification (requires SMS provider)

**TOTP is free** and enabled by default on all projects.

## Assurance Levels

- **AAL1**: Basic authentication (email/password, magic link, OAuth)
- **AAL2**: Multi-factor verified (TOTP or phone code verified)

## TOTP MFA Flow

### Step 1: Enroll Factor

```javascript
const { data, error } = await supabase.auth.mfa.enroll({
  factorType: 'totp',
  friendlyName: 'My Authenticator App'
})

if (data) {
  console.log('Factor ID:', data.id)
  console.log('QR Code:', data.totp.qr_code)    // Display to user
  console.log('Secret:', data.totp.secret)       // For manual entry
  console.log('URI:', data.totp.uri)             // otpauth:// URI
}
```

**Display QR code** to user so they can scan it with their authenticator app.

### Step 2: Verify Enrollment

After user adds the secret to their app and sees a 6-digit code:

```javascript
// Create challenge
const { data: challengeData, error: challengeError } =
  await supabase.auth.mfa.challenge({
    factorId: data.id
  })

// Verify user's code
const { data: verifyData, error: verifyError } =
  await supabase.auth.mfa.verify({
    factorId: data.id,
    challengeId: challengeData.id,
    code: '123456'  // User's 6-digit code
  })

if (!verifyError) {
  console.log('MFA enrolled successfully!')
}
```

### Step 3: Challenge on Sign-In

After regular sign-in, check if MFA is required:

```javascript
// Sign in
const { data: signInData, error: signInError } =
  await supabase.auth.signInWithPassword({
    email: 'user@example.com',
    password: 'password123'
  })

// Check for MFA factors
const { data: factorsData } = await supabase.auth.mfa.listFactors()

if (factorsData.totp.length > 0) {
  // MFA required - challenge user
  const factorId = factorsData.totp[0].id

  const { data: challengeData } = await supabase.auth.mfa.challenge({
    factorId
  })

  // Prompt user for code
  const code = prompt('Enter your 6-digit authentication code')

  const { data: verifyData, error: verifyError } =
    await supabase.auth.mfa.verify({
      factorId,
      challengeId: challengeData.id,
      code
    })

  if (!verifyError) {
    // Session promoted to AAL2
    console.log('MFA verified!')
  }
}
```

## Combined Challenge + Verify

Convenience method that combines challenge and verify:

```javascript
const { data, error } = await supabase.auth.mfa.challengeAndVerify({
  factorId: 'factor-id',
  code: '123456'
})
```

## List Factors

```javascript
const { data, error } = await supabase.auth.mfa.listFactors()

console.log('TOTP factors:', data.totp)
console.log('Phone factors:', data.phone)
```

## Unenroll Factor

User-initiated factor removal:

```javascript
const { data, error } = await supabase.auth.mfa.unenroll({
  factorId: 'factor-id'
})
```

## Check Assurance Level

```javascript
const { data, error } = await supabase.auth.mfa.getAuthenticatorAssuranceLevel()

console.log('Current level:', data.currentLevel)  // 'aal1' or 'aal2'
console.log('Required level:', data.nextLevel)    // What's needed
```

## Enforce MFA with RLS

Require AAL2 for sensitive operations:

```sql
-- Only AAL2 users can update sensitive data
CREATE POLICY "Require MFA for updates"
ON sensitive_table
FOR UPDATE
TO authenticated
USING ((auth.jwt()->>'aal') = 'aal2');
```

## Phone MFA

### Enroll Phone Factor

```javascript
const { data, error } = await supabase.auth.mfa.enroll({
  factorType: 'phone',
  phone: '+13334445555'
})
```

### Verify Phone Factor

```javascript
const { data: challengeData } = await supabase.auth.mfa.challenge({
  factorId: data.id
})

// User receives SMS with code
const { data: verifyData, error } = await supabase.auth.mfa.verify({
  factorId: data.id,
  challengeId: challengeData.id,
  code: '123456'
})
```

## Admin MFA Operations

### Delete Factor (Admin Override)

If user loses access to their authenticator device:

```javascript
// Server-side with service role key
const { error } = await supabaseAdmin.auth.admin.mfa.deleteFactor({
  id: 'factor-id',
  userId: 'user-id'
})
```

## Recovery

**No Recovery Codes**: Supabase doesn't have recovery codes.

**Solution**: Users can enroll up to **10 factors**. Recommend enrolling 2+ factors so one acts as backup.

```javascript
// Enroll backup factor
const { data } = await supabase.auth.mfa.enroll({
  factorType: 'totp',
  friendlyName: 'Backup Authenticator'
})
```

## Complete MFA Setup Example

```javascript
async function setupMFA() {
  // Step 1: Enroll
  const { data: enrollData, error: enrollError } =
    await supabase.auth.mfa.enroll({
      factorType: 'totp',
      friendlyName: 'My Authenticator'
    })

  if (enrollError) {
    console.error('Enroll error:', enrollError.message)
    return { success: false }
  }

  // Step 2: Display QR code to user
  // User scans with authenticator app

  // Step 3: Verify enrollment
  const code = prompt('Enter the 6-digit code from your authenticator app')

  const { data: challengeData } = await supabase.auth.mfa.challenge({
    factorId: enrollData.id
  })

  const { error: verifyError } = await supabase.auth.mfa.verify({
    factorId: enrollData.id,
    challengeId: challengeData.id,
    code
  })

  if (verifyError) {
    console.error('Verification failed:', verifyError.message)
    return { success: false }
  }

  return { success: true, message: 'MFA enabled!' }
}
```

## Complete MFA Sign-In Example

```javascript
async function signInWithMFA(email, password) {
  // Step 1: Regular sign-in
  const { data: signInData, error: signInError } =
    await supabase.auth.signInWithPassword({ email, password })

  if (signInError) {
    return { success: false, error: signInError.message }
  }

  // Step 2: Check if MFA required
  const { data: factorsData } = await supabase.auth.mfa.listFactors()

  if (factorsData.totp.length === 0) {
    // No MFA - sign in complete
    return { success: true, session: signInData.session }
  }

  // Step 3: MFA challenge
  const factorId = factorsData.totp[0].id
  const { data: challengeData } = await supabase.auth.mfa.challenge({ factorId })

  // Step 4: Get code from user
  const code = prompt('Enter your authentication code')

  // Step 5: Verify
  const { data: verifyData, error: verifyError } =
    await supabase.auth.mfa.verify({
      factorId,
      challengeId: challengeData.id,
      code
    })

  if (verifyError) {
    return { success: false, error: 'Invalid code' }
  }

  return { success: true, session: verifyData.session }
}
```

## MFA UI Component Example (React)

```javascript
function MFASetup() {
  const [qrCode, setQrCode] = useState(null)
  const [factorId, setFactorId] = useState(null)
  const [code, setCode] = useState('')
  const [step, setStep] = useState('enroll') // 'enroll', 'verify', 'done'

  const startEnrollment = async () => {
    const { data, error } = await supabase.auth.mfa.enroll({
      factorType: 'totp',
      friendlyName: 'Authenticator App'
    })

    if (!error) {
      setQrCode(data.totp.qr_code)
      setFactorId(data.id)
      setStep('verify')
    }
  }

  const verifyCode = async () => {
    const { data: challengeData } = await supabase.auth.mfa.challenge({
      factorId
    })

    const { error } = await supabase.auth.mfa.verify({
      factorId,
      challengeId: challengeData.id,
      code
    })

    if (!error) {
      setStep('done')
    }
  }

  if (step === 'enroll') {
    return <button onClick={startEnrollment}>Enable MFA</button>
  }

  if (step === 'verify') {
    return (
      <div>
        <img src={qrCode} alt="Scan this QR code" />
        <input
          value={code}
          onChange={(e) => setCode(e.target.value)}
          placeholder="Enter 6-digit code"
        />
        <button onClick={verifyCode}>Verify</button>
      </div>
    )
  }

  return <div>MFA enabled successfully!</div>
}
```
