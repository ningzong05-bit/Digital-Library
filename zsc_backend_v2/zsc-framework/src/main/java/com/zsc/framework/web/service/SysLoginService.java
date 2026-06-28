package com.zsc.framework.web.service;

import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import com.zsc.common.constant.CacheConstants;
import com.zsc.common.constant.Constants;
import com.zsc.common.constant.UserConstants;
import com.zsc.common.core.domain.model.LoginUser;
import com.zsc.common.core.redis.RedisCache;
import com.zsc.common.exception.ServiceException;
import com.zsc.common.exception.user.BlackListException;
import com.zsc.common.exception.user.CaptchaException;
import com.zsc.common.exception.user.CaptchaExpireException;
import com.zsc.common.exception.user.UserNotExistsException;
import com.zsc.common.exception.user.UserPasswordNotMatchException;
import com.zsc.common.utils.MessageUtils;
import com.zsc.common.utils.StringUtils;
import com.zsc.common.utils.ip.IpUtils;
import com.zsc.framework.manager.AsyncManager;
import com.zsc.framework.manager.factory.AsyncFactory;
import com.zsc.framework.security.context.AuthenticationContextHolder;
import com.zsc.system.service.ISysConfigService;

@Component
public class SysLoginService
{
    @Autowired
    private TokenService tokenService;

    @Resource
    private AuthenticationManager authenticationManager;

    @Autowired
    private RedisCache redisCache;

    @Autowired
    private ISysConfigService configService;

    public String login(String username, String password, String code, String uuid)
    {
        // Captcha validation is intentionally disabled for the online test deployment.
        // validateCaptcha(username, code, uuid);
        loginPreCheck(username, password);

        Authentication authentication = null;
        try
        {
            UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(username, password);
            AuthenticationContextHolder.setContext(authenticationToken);
            authentication = authenticationManager.authenticate(authenticationToken);
        }
        catch (Exception e)
        {
            if (e instanceof BadCredentialsException)
            {
                throw new UserPasswordNotMatchException();
            }
            throw new ServiceException(e.getMessage());
        }
        finally
        {
            AuthenticationContextHolder.clearContext();
        }

        LoginUser loginUser = (LoginUser) authentication.getPrincipal();
        return tokenService.createToken(loginUser);
    }

    public void validateCaptcha(String username, String code, String uuid)
    {
        boolean captchaEnabled = configService.selectCaptchaEnabled();
        if (captchaEnabled)
        {
            String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + StringUtils.nvl(uuid, "");
            String captcha = redisCache.getCacheObject(verifyKey);
            if (captcha == null)
            {
                AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL,
                        MessageUtils.message("user.jcaptcha.expire")));
                throw new CaptchaExpireException();
            }
            redisCache.deleteObject(verifyKey);
            if (!code.equalsIgnoreCase(captcha))
            {
                AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL,
                        MessageUtils.message("user.jcaptcha.error")));
                throw new CaptchaException();
            }
        }
    }

    public void loginPreCheck(String username, String password)
    {
        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password))
        {
            throw new UserNotExistsException();
        }
        if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            throw new UserPasswordNotMatchException();
        }
        if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH)
        {
            throw new UserPasswordNotMatchException();
        }
        String blackStr = configService.selectConfigByKey("sys.login.blackIPList");
        if (IpUtils.isMatchedIp(blackStr, IpUtils.getIpAddr()))
        {
            throw new BlackListException();
        }
    }
}
