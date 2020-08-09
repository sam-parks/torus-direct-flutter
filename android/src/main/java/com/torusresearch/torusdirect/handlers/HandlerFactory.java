package com.torusresearch.torusdirect.handlers;

import com.torusresearch.torusdirect.interfaces.ILoginHandler;
import com.torusresearch.torusdirect.types.CreateHandlerParams;
import com.torusresearch.torusdirect.types.LoginType;
import com.torusresearch.torusdirect.utils.Helpers;

import java.security.InvalidParameterException;

public class HandlerFactory {
    public static ILoginHandler createHandler(CreateHandlerParams params) throws InvalidParameterException {
        LoginType typeOfLogin = params.getTypeOfLogin();
        if (Helpers.isEmpty(params.getClientId()) || Helpers.isEmpty(params.getVerifier()) || Helpers.isEmpty(params.getRedirect_uri())) {
            throw new InvalidParameterException("Invalid Params");
        }
        String domain = params.getJwtParams().getDomain();
        switch (typeOfLogin) {
            case GOOGLE:
                return new GoogleHandler(params);
            case FACEBOOK:
                return new FacebookHandler(params);
            case REDDIT:
                return new RedditHandler(params);
            case DISCORD:
                return new DiscordHandler(params);
            case TWITCH:
                return new TwitchHandler(params);
            case APPLE:
            case GITHUB:
            case LINKEDIN:
            case TWITTER:
            case WEIBO:
            case LINE:
            case EMAIL_PASSWORD:
            case JWT:
                if (Helpers.isEmpty(domain)) throw new InvalidParameterException("Invalid params");
                return new JwtHandler(params);
            default:
                throw new InvalidParameterException("Invalid login type");
        }
    }
}
