
> [!IMPORTANT]  
> ⚠️ **This is a fork of [CodetrixStudio/CapacitorGoogleAuth](https://github.com/CodetrixStudio/CapacitorGoogleAuth)**, the original project is no longer maintained. This fork includes the **bare minimum changes needed to keep the plugin functional**.


<h1 align="center">CapacitorGoogleAuth</h1>
<p align="center"><strong><code>@daniele-rolli/capacitor-google-auth</code></strong></p>
<p align="center">formerly</p>
<p align="center"><strong><code>@codetrix-studio/capacitor-google-auth</code></strong></p>
<p align="center"><strong>CAPACITOR 6</strong></p>
<p align="center">
Capacitor plugin for Google Auth.
</p>

## Breaking change in V6

In the v6 version, `clientId` in the initialize method is used in priority over other places you could set up. If before you were using this only on the web, unset it on mobile. Or set it conditionally to replicate old behavior.

## Contributions

PRs are welcome and much appreciated that keeps this plugin up to date with Capacitor and official Google Auth platform library feature parity.

Try to follow good code practices. You can even help keeping the included demo updated.

PRs for features that are not aligned with the official Google Auth library are discouraged.

(We are beginner-friendly here)

## Install

#### 1. Install package

```sh
npm i --save @daniele-rolli/capacitor-google-auth

# pnpm 
pnpm add @daniele-rolli/capacitor-google-auth

# yarn 
yarn add @daniele-rolli/capacitor-google-auth
```

#### 2. Update capacitor deps

```sh
npx cap update
```

## Updating

If need migrate to different Capacitor versions [see instruction for migrate plugin to new version](#migration-guide).

## Usage

### WEB

Register plugin and manually initialize

```ts
import { GoogleAuth } from '@daniele-rolli/capacitor-google-auth';

// use hook after platform dom ready
GoogleAuth.initialize({
  clientId: 'CLIENT_ID.apps.googleusercontent.com',
  scopes: ['profile', 'email'],
  grantOfflineAccess: true,
});
```

or if need use meta tags (Optional):

```html
<meta name="google-signin-client_id" content="{your client id here}" />
<meta name="google-signin-scope" content="profile email" />
```

#### Options

- `clientId` - The app's client ID, found and created in the Google Developers Console.
- `scopes` – same as [Configure](#Configure) scopes
- `grantOfflineAccess` – boolean, default `false`, Set if your application needs to refresh access tokens when the user is not present at the browser.

Use it

```ts
GoogleAuth.signIn();
```

#### Angular

init hook

```ts
// app.component.ts
constructor() {
  this.initializeApp();
}

initializeApp() {
  this.platform.ready().then(() => {
    GoogleAuth.initialize()
  })
}
```

sign in function

```ts
import { GoogleAuth } from "@daniele-rolli/capacitor-google-auth";
import { Auth, GoogleAuthProvider, signInWithCredential } from '@angular/fire/auth';

async googleSignIn() {
  let googleUser = await GoogleAuth.signIn();

  /*
    If you use Firebase you can forward and use the logged in Google user like this:
  */
  constructor(private auth: Auth){}

  const googleUser = await GoogleAuth.signIn();
  const _credential = GoogleAuthProvider.credential(googleUser.authentication.idToken);
  return signInWithCredential(this.auth, _credential);
}
```

#### Vue 3

```vue
<script setup lang="ts">
import { defineComponent, onMounted } from 'vue';
import { GoogleAuth } from '@daniele-rolli/capacitor-google-auth';

onMounted(() => {
  GoogleAuth.initialize();
});

async function logIn() {
  const response = await GoogleAuth.signIn();
  console.log(response);
}
</script>
```

or see more [CapacitorGoogleAuth-Vue3-example](https://github.com/reslear/CapacitorGoogleAuth-Vue3-example)

### iOS

1. Create in Google cloud console credential **Client ID for iOS** and get **Client ID** and **iOS URL scheme**

2. Add **identifier** `GIDClientID` to `Info.plist`<br>
   `<key>GIDClientID</key><string>VALUE</string>`

3. Add **identifier** `REVERSED_CLIENT_ID` as **URL schemes** to `Info.plist` from **iOS URL scheme**<br>
   (Xcode: App - Targets/App - Info - URL Types, click plus icon)

### Android

Set **Client ID** (by order of importance in the plugin):
1. Set `clientId` in initialize method
2. Set `androidClientId` in `capacitor.config.json`
3. Set `clientId` in `capacitor.config.json`
4. Set `server_client_id` in `strings.xml`

```xml
<resources>
  <string name="server_client_id">Your Web Client Key</string>
</resources>
```

Changing Play Services Auth version (Optional) :

This plugin uses `com.google.android.gms:play-services-auth:21.2.0` by default, you can override it providing `gmsPlayServicesAuthVersion` at `variables.gradle`

**Refresh method**

This method should be called when the app is initialized to establish if the user is currently logged in. If true, the method will return an accessToken, idToken and an empty refreshToken.
```ts
checkLoggedIn() {
    GoogleAuth.refresh()
        .then((data) => {
            if (data.accessToken) {
                this.currentTokens = data;
            }
        })
        .catch((error) => {
            if (error.type === 'userLoggedOut') {
                this.signin()
            }
        });
}
```

## Configure

| Name                     | Type     | Description                                                                                                                   |
| ------------------------ | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| clientId                 | string   | The app's client ID, found and created in the Google Developers Console.                                                      |
| iosClientId              | string   | Specific client ID key for iOS                                                                                                |
| androidClientId          | string   | Specific client ID key for Android                                                                                            |
| scopes                   | string[] | Scopes that you might need to request to access Google APIs<br>https://developers.google.com/identity/protocols/oauth2/scopes |
| serverClientId           | string   | This ClientId used for offline access and server side handling                                                                |
| forceCodeForRefreshToken | boolean  | Force user to select email address to regenerate AuthCode <br>used to get a valid refreshtoken (work on iOS and Android)      |

Provide configuration in root `capacitor.config.json`

```json
{
  "plugins": {
    "GoogleAuth": {
      "scopes": ["profile", "email"],
      "serverClientId": "xxxxxx-xxxxxxxxxxxxxxxxxx.apps.googleusercontent.com",
      "forceCodeForRefreshToken": true
    }
  }
}
```

or in `capacitor.config.ts`

```ts
/// <reference types="'@daniele-rolli/capacitor-google-auth'" />

const config: CapacitorConfig = {
  plugins: {
    GoogleAuth: {
      scopes: ['profile', 'email'],
      serverClientId: 'xxxxxx-xxxxxxxxxxxxxxxxxx.apps.googleusercontent.com',
      forceCodeForRefreshToken: true,
    },
  },
};

export default config;
```
#### Note: scopes can be configured under <code><a href="#initialize">initialize</a></code> function.

## API

<docgen-index>

* [`initialize(...)`](#initialize)
* [`signIn()`](#signin)
* [`refresh()`](#refresh)
* [`signOut()`](#signout)
* [Interfaces](#interfaces)

</docgen-index>
<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initialize(...)

```typescript
initialize(options?: InitOptions) => void
```

Initializes the GoogleAuthPlugin, loading the gapi library and setting up the plugin.

| Param         | Type                                                | Description                        |
| ------------- | --------------------------------------------------- | ---------------------------------- |
| **`options`** | <code><a href="#initoptions">InitOptions</a></code> | - Optional initialization options. |

**Since:** 3.1.0

--------------------


### signIn()

```typescript
signIn() => Promise<User>
```

Initiates the sign-in process and returns a Promise that resolves with the user information.

**Returns:** <code>Promise&lt;<a href="#user">User</a>&gt;</code>

--------------------


### refresh()

```typescript
refresh() => Promise<Authentication>
```

Refreshes the authentication token and returns a Promise that resolves with the updated authentication details.

**Returns:** <code>Promise&lt;<a href="#authentication">Authentication</a>&gt;</code>

--------------------


### signOut()

```typescript
signOut() => Promise<any>
```

Signs out the user and returns a Promise.

**Returns:** <code>Promise&lt;any&gt;</code>

--------------------


### Interfaces


#### InitOptions

| Prop                     | Type                  | Description                                                                                                                                      | Default            | Since      |
| ------------------------ | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------ | ---------- |
| **`clientId`**           | <code>string</code>   | The app's client ID, found and created in the Google Developers Console. Common for Android or iOS. The default is defined in the configuration. |                    | 3.1.0      |
| **`scopes`**             | <code>string[]</code> | Specifies the scopes required for accessing Google APIs The default is defined in the configuration.                                             |                    | 3.4.0-rc.4 |
| **`grantOfflineAccess`** | <code>boolean</code>  | Set if your application needs to refresh access tokens when the user is not present at the browser. In response use `serverAuthCode` key         | <code>false</code> | 3.1.0      |


#### User

| Prop                 | Type                                                      | Description                                                         |
| -------------------- | --------------------------------------------------------- | ------------------------------------------------------------------- |
| **`id`**             | <code>string</code>                                       | The unique identifier for the user.                                 |
| **`email`**          | <code>string</code>                                       | The email address associated with the user.                         |
| **`name`**           | <code>string</code>                                       | The user's full name.                                               |
| **`familyName`**     | <code>string</code>                                       | The family name (last name) of the user.                            |
| **`givenName`**      | <code>string</code>                                       | The given name (first name) of the user.                            |
| **`imageUrl`**       | <code>string</code>                                       | The URL of the user's profile picture.                              |
| **`serverAuthCode`** | <code>string</code>                                       | The server authentication code.                                     |
| **`authentication`** | <code><a href="#authentication">Authentication</a></code> | The authentication details including access, refresh and ID tokens. |


#### Authentication

| Prop               | Type                | Description                                      |
| ------------------ | ------------------- | ------------------------------------------------ |
| **`accessToken`**  | <code>string</code> | The access token obtained during authentication. |
| **`idToken`**      | <code>string</code> | The ID token obtained during authentication.     |
| **`refreshToken`** | <code>string</code> | The refresh token.                               |

</docgen-api>

## Migration guide

#### Migrate from 3.3.x to 3.4.x

Install version 3.4.x:

```sh
npm i --save @codetrix-studio/capacitor-google-auth@^3.4
```

Follow instruction for you project [Updating to Capacitor 6](https://capacitorjs.com/docs/next/updating/6-0).

#### Migrate from 3.2.x to 3.3.x

Install version 3.3.x:

```sh
npm i --save @codetrix-studio/capacitor-google-auth^3.3
```

Follow instruction for you project [Updating from Capacitor 4 to Capacitor 5](https://capacitorjs.com/docs/updating/5-0).

#### Migrate from 3.2.1 to 3.2.2

for `Android` in file `MainActivity.onCreate`

```diff
- this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
-   add(GoogleAuth.class);
- }});
+ this.registerPlugin(GoogleAuth.class);
```

#### Migrate from 3.1.x to 3.2.x

Install version 3.2.x:

```sh
npm i --save @codetrix-studio/capacitor-google-auth^3.2
```

Follow instruction for you project [Updating from Capacitor 3 to Capacitor 4](https://capacitorjs.com/docs/updating/4-0).

#### Migrate from 3.0.2 to 3.1.0

```diff
- GoogleAuth.init()
+ GoogleAuth.initialize()
```

#### Migrate from 2 to 3

Install version 3.x.x:

```sh
npm i --save @codetrix-studio/capacitor-google-auth^3.0
```

After [migrate to Capcitor 3](https://capacitorjs.com/docs/updating/3-0) updating you projects, see diff:

##### WEB

```diff
- import "@codetrix-studio/capacitor-google-auth";
- import { Plugins } from '@capacitor/core';
+ import { GoogleAuth } from '@codetrix-studio/capacitor-google-auth'

- Plugins.GoogleAuth.signIn();
+ GoogleAuth.init()
+ GoogleAuth.signIn()
```

#### Migrate from 1 to 2

Install version 2.x.x:

```sh
npm i --save @codetrix-studio/capacitor-google-auth@2
```

for capacitor 2.x.x use [instruction](https://github.com/CodetrixStudio/CapacitorGoogleAuth/blob/79129ab37288f5f5d0bb9a568a95890e852cebc2/README.md)

## License

[MIT](./LICENSE)
