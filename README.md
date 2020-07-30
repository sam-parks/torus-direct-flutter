# torus_direct

Interact with the Torus Network to assign, store and retrieve private keys. 

## Usage 

Import the package:

```
import 'package:torus_direct/torus_direct.dart';
```

Initialize TorusDirect depending on the login you require:

```
 TorusDirect.setOptions(
        LoginType.installed.value,
        VerifierType.singleLogin.value,
        verifierName,
        <your-client-id>,
        LoginProvider.google.value,
        google,
        <your-redirect-url>);
```
Logins are dependent on verifier scripts/verifiers. There are other verifiers including singleIdVerifier, andAggregateVerifier, orAggregateVerifier and singleLogin of which you may need to use depending on your required logins. To get your application's verifier script setup, do reach out to hello@tor.us or to read more about verifiers do checkout the docs.

After initialization, you can use TorusDirect to trigger a login with your verifier options:

```
torusLoginInfo = await TorusDirect.triggerLogin();
```

After this you're good to go, reach out to hello@tor.us to get your verifier spun up on the testnet today!

