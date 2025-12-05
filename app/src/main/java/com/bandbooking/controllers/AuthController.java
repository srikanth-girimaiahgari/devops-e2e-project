// src/main/java/com/bandbooking/controllers/AuthController.java
package com.bandbooking.controllers;

import com.bandbooking.models.User;
import com.bandbooking.services.UserService;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/register")
    public ModelAndView showRegistrationForm() {
        return new ModelAndView("register");
    }

    @PostMapping("/register")
    public ModelAndView registerUser(HttpServletRequest request) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);

        if (userService.register(user)) {
            return new ModelAndView("login").addObject("message", "Registration successful! Please login.");
        } else {
            return new ModelAndView("register").addObject("error", "Username already exists.");
        }
    }

    @GetMapping("/login")
    public ModelAndView showLoginForm() {
        return new ModelAndView("login");
    }

    @PostMapping("/login")
    public ModelAndView loginUser(HttpServletRequest request) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (userService.login(username, password)) {
            request.getSession().setAttribute("user", username);
            return new ModelAndView("redirect:/home");
        } else {
            return new ModelAndView("login").addObject("error", "Invalid username or password.");
        }
    }
}
