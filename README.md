# torus_direct

Interact with the Torus Network to assign, store and retrieve private keys. 

## Usage 

Import the package:

```
import 'package:torus_direct/torus_direct.dart';
```

Initialize TorusDirect with the verifier options you want:

```
 TorusDirect.setOptions(
        VerifierType.singleLogin.key,
        verifierName,
        clientId,
        LoginProvider.google.key,
        verifier,
        redirectURL);
```

You can now use the TorusDirect to trigger a login with your verifier options:

```
torusLoginInfo = await TorusDirect.triggerLogin();
```

