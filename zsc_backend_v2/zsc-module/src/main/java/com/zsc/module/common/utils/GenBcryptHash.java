package com.zsc.module.common.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class GenBcryptHash {
    public static void main(String[] args) {
        System.out.println(new BCryptPasswordEncoder().encode(args[0]));
    }
}
