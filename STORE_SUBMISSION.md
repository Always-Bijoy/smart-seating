# Play Store Submission Guide — Smart Seating

> **One-time setup:** Replace every `YOUR_GITHUB_USERNAME` below with your actual GitHub username.
> Your repo name should match: `smart_seating`

---

## Step 1 — Push files to GitHub

Make sure these files are committed and pushed to the **`main`** branch of your GitHub repo:

```
smart_seating/
├── PRIVACY_POLICY.md        ✅ required by Play Store
├── TERMS_AND_CONDITIONS.md  ✅ optional but recommended
└── STORE_SUBMISSION.md      (this file)
```

After pushing, verify your raw URLs load plain text in a browser:

| Document | Raw URL |
|----------|---------|
| Privacy Policy | `https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/smart_seating/main/PRIVACY_POLICY.md` |
| Terms & Conditions | `https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/smart_seating/main/TERMS_AND_CONDITIONS.md` |

---

## Step 2 — Replace placeholders in the markdown files

Open both `PRIVACY_POLICY.md` and `TERMS_AND_CONDITIONS.md` and fill in:

| Placeholder | Replace with |
|-------------|-------------|
| `YOUR_GITHUB_USERNAME` | Your actual GitHub username |
| `[your-email@example.com]` | Your support / developer email |
| `[Your Address, Dhaka, Bangladesh]` | Your registered address |
| `[Your Country / Bangladesh]` | `Bangladesh` (or your country) |
| `[Your City/Country]` | e.g., `Dhaka, Bangladesh` |

---

## Step 3 — Google Play Console fields

### App Content → Privacy Policy
Paste this URL into the **Privacy policy** field:
```
https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/smart_seating/main/PRIVACY_POLICY.md
```

### Store Listing — Full Description
You can include this line at the end of your app description:
```
Privacy Policy: https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/smart_seating/main/PRIVACY_POLICY.md
```

---

## Step 4 — App Content declarations (Data Safety section)

In **Play Console → App content → Data safety**, answer as follows:

| Question | Answer |
|----------|--------|
| Does your app collect or share any of the required user data types? | **Yes** |
| Location — Approximate location | **No** |
| Location — Precise location | **Yes (optional, user-initiated)** |
| Is location data collected? | **Yes** |
| Is location data shared? | **No** |
| Is location data ephemeral? | **Yes** (not retained after session) |
| Personal info (name, email, etc.) | **No** |
| App activity | **No** |
| Device or other IDs | **No** |
| Is data encrypted in transit? | **N/A** (no data leaves the device) |
| Can users request data deletion? | **Yes** (by uninstalling the app) |

---

## Step 5 — Content Rating Questionnaire

| Section | Answer |
|---------|--------|
| Category | **Utility / Travel & Local** |
| Violence | None |
| Sexual content | None |
| Profanity | None |
| Controlled substances | None |
| Location sharing | User's own location only, not shared with others |

Expected rating: **Everyone (E)** / **PEGI 3**

---

## Step 6 — App Details for Listing

### Short Description (80 chars max)
```
Find the shadiest bus seat based on real-time sun position for your route.
```

### Full Description (4000 chars max — sample)
```
Smart Seating tells you exactly which side of the bus to sit on to avoid direct sunlight on your journey.

Just enter your origin and destination, pick your departure time, and Smart Seating calculates the sun's position for your route heading — then recommends whether to sit on the LEFT or RIGHT side for maximum shade.

Features:
• Real-time sun position compass (Live Tracker)
• Works for any route — enter any two cities
• Optional GPS to auto-detect your starting location
• Works offline — no internet required
• Supports English and বাংলা (Bengali)
• No account or sign-up required

How it works:
Smart Seating uses solar geometry algorithms to calculate the sun's azimuth and elevation at your departure time and location. It then determines which side of the bus faces the sun based on your route's compass heading.

Privacy:
All calculations happen on your device. No personal data is collected or transmitted.
```

### Keywords / Tags
```
bus seat, sun shade, travel comfort, seat finder, sun tracker, Bangladesh bus, dhaka bus
```

---

## Checklist Before Submitting

- [ ] `PRIVACY_POLICY.md` pushed to GitHub `main` branch
- [ ] Raw URL is publicly accessible (test in browser — incognito)
- [ ] All `YOUR_GITHUB_USERNAME` placeholders replaced
- [ ] All `[your-email@example.com]` placeholders replaced
- [ ] Privacy Policy URL pasted into Play Console
- [ ] Data Safety section completed
- [ ] App signed with release keystore
- [ ] `minSdkVersion` set (recommended: 21)
- [ ] App icon 512×512 PNG uploaded
- [ ] At least 2 screenshots per device type uploaded
- [ ] Content rating questionnaire completed
- [ ] Target SDK meets current Play Store requirements (API 35 for 2025+)

---

*Generated for Smart Seating — February 20, 2026*
