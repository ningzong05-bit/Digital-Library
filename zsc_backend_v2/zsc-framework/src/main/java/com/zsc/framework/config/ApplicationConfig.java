package com.zsc.framework.config;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.zsc.common.utils.StringUtils;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/**
 * 程序注解配置
 *
 * @author zsc
 */
@Configuration
// 表示通过aop框架暴露该代理对象,AopContext能够访问
@EnableAspectJAutoProxy(exposeProxy = true)
// 指定要扫描的Mapper类的包的路径
@MapperScan({"com.zsc.**.mapper", "com.publicpicturebackend.mapper"})
public class ApplicationConfig
{
    /**
     * 时区配置
     */
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jacksonObjectMapperCustomization()
    {
        return jacksonObjectMapperBuilder -> jacksonObjectMapperBuilder
                .timeZone(TimeZone.getDefault())
                .deserializerByType(Date.class, new FlexibleDateDeserializer());
    }

    private static class FlexibleDateDeserializer extends JsonDeserializer<Date>
    {
        private static final String[] PATTERNS = {
                "yyyy-MM-dd HH:mm:ss",
                "yyyy-MM-dd HH:mm",
                "yyyy-MM-dd",
                "yyyy/MM/dd HH:mm:ss",
                "yyyy/MM/dd HH:mm",
                "yyyy/MM/dd",
                "yyyy-MM-dd'T'HH:mm:ss.SSSX",
                "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
                "yyyy-MM-dd'T'HH:mm:ssX",
                "yyyy-MM-dd'T'HH:mm:ssXXX"
        };

        @Override
        public Date deserialize(JsonParser parser, DeserializationContext context) throws IOException
        {
            if (parser.currentToken() != null && parser.currentToken().isNumeric()) {
                return new Date(parser.getLongValue());
            }
            String value = parser.getValueAsString();
            if (StringUtils.isBlank(value)) {
                return null;
            }
            String dateValue = value.trim();
            for (String pattern : PATTERNS) {
                try {
                    SimpleDateFormat format = new SimpleDateFormat(pattern, Locale.ROOT);
                    format.setLenient(false);
                    format.setTimeZone(TimeZone.getTimeZone("GMT+8"));
                    return format.parse(dateValue);
                } catch (ParseException ignored) {
                }
            }
            return (Date) context.handleWeirdStringValue(Date.class, dateValue,
                    "Expected date formats yyyy-MM-dd or yyyy-MM-dd HH:mm:ss");
        }
    }
}
